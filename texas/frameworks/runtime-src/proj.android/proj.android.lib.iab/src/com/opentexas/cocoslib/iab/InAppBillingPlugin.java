package com.opentexas.cocoslib.iab;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import com.opentexas.cocoslib.core.Cocos2dxActivityUtil;
import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;
import com.opentexas.cocoslib.core.IPlugin;
import com.opentexas.cocoslib.core.LifecycleObserverAdapter;

import com.android.billingclient.api.BillingClient;
import com.android.billingclient.api.BillingClientStateListener;
import com.android.billingclient.api.BillingFlowParams;
import com.android.billingclient.api.BillingResult;
import com.android.billingclient.api.ConsumeParams;
import com.android.billingclient.api.ConsumeResponseListener;
import com.android.billingclient.api.ProductDetails;
import com.android.billingclient.api.Purchase;
import com.android.billingclient.api.PurchasesResponseListener;
import com.android.billingclient.api.PurchasesUpdatedListener;
import com.android.billingclient.api.QueryProductDetailsParams;
import com.android.billingclient.api.QueryPurchasesParams;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;
import java.util.Arrays;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

public class InAppBillingPlugin extends LifecycleObserverAdapter implements IPlugin, BillingClientStateListener, PurchasesUpdatedListener,
        PurchasesResponseListener, ConsumeResponseListener {
    private static final String TAG = InAppBillingPlugin.class.getSimpleName();
    private int retryLimit = 4;
    protected String id;
    private BillingClient _billingClient = null;
    private int _reconnectCount = 0;
    private final LinkedList<QueryTask> _queryTasksList = new LinkedList<>();
    private PurchaseTask _purchaseTask = null;
    private final ScheduledExecutorService _scheduler = Executors.newScheduledThreadPool(1);
    private ScheduledFuture<?> _reconnectSchedule;
    private boolean helperInit = false;
    private final Map<String, ProductDetails> _cachedProductDetailsMap = new HashMap<>();
    private final Map<String, Purchase> _unfinishedPurchasesMap = new HashMap<>();
    private boolean isSetupComplete = false;
    private boolean isSetuping = false;
    private boolean isSupported = false;

    // 开始链接
    private boolean startConnection() {
        if (_reconnectCount > 0) {
            Log.d(TAG, "startConnection: waiting for reconnection");
            return false;
        }
        Activity activity = Cocos2dxActivityWrapper.getContext();
        if (activity == null) {
            Log.i(TAG, "startConnection: activity not found");
            return false;
        }
        boolean connected = false;
        if (_billingClient == null || _billingClient.getConnectionState() == BillingClient.ConnectionState.CLOSED) {
            Log.d(TAG, "startConnection: BillingClient is null or has been closed -- start build");
            _billingClient = BillingClient.newBuilder(activity)
                    .setListener(this)
                    .enablePendingPurchases()
                    .build();
        }
        if (_billingClient.getConnectionState() == BillingClient.ConnectionState.DISCONNECTED) {
            Log.d(TAG, "startConnection: BillingClient disconnected -- start connection");
            _billingClient.startConnection(this);
        } else if (_billingClient.isReady()) {
            Log.d(TAG, "startConnection: BillingClient connected");
            connected = true;
        } else {
            Log.d(TAG, "startConnection: BillingClient connecting");
        }
        return connected;
    }

    // 结束链接
    private void endConnection() {
        if (_billingClient != null) {
            switch (_billingClient.getConnectionState()) {
                case BillingClient.ConnectionState.CONNECTING:
                case BillingClient.ConnectionState.CONNECTED:
                    Log.d(TAG, "endConnection: close BillingClient connection");
                    _billingClient.endConnection();
                    break;
            }
            _billingClient = null;
        }
        _reconnectCount = 0;
    }

    // 查询类
    private static class QueryTask {
        private final Set<String> _productIDsSet;
        private final Map<String, Map<String, Object>> _result;
        private boolean _running = false;
        private int _retryCount = 0;

        public QueryTask(@NonNull final Set<String> productIDsSet) {
            _productIDsSet = new HashSet<>();
            _result = new HashMap<>();

            for (String productID : productIDsSet) {
                ProductDetails product = InAppBillingBridge.getInAppBillingPlugin().getCachedProduct(productID);
                if (product != null) {
                    ProductDetails.OneTimePurchaseOfferDetails details = product.getOneTimePurchaseOfferDetails();
                    if (details != null) {
                        _result.put(productID, infoFromProduct(details));
                    } else {
                        _productIDsSet.add(productID);
                    }
                } else {
                    _productIDsSet.add(productID);
                }
            }
        }

        public boolean isDone() {
            return _productIDsSet.size() <= 0;
        }

        public boolean isRunning() {
            return _running;
        }

        public Set<String> getProductIDsSet() {
            return _productIDsSet;
        }

        public boolean start() {
            if (isDone() || isRunning()) {
                return false;
            }
            _running = true;
            return true;
        }

        public boolean accomplish(boolean success, boolean retriable) {
            _running = false;

            if (!isDone() && !success && retriable && _retryCount < 3) {
                ++_retryCount;
                InAppBillingBridge.callLuaLoadProductsCompleteCallbackMethod("fail");
                return false;
            }

            JSONArray array = new JSONArray();
            for (String productID : _productIDsSet) {
                ProductDetails product = InAppBillingBridge.getInAppBillingPlugin().getCachedProduct(productID);
                if (product != null) {
                    ProductDetails.OneTimePurchaseOfferDetails details = product.getOneTimePurchaseOfferDetails();
                    if (details != null) {
                        Map<String, Object> mapDetails = infoFromProduct(details);
                        _result.put(productID, mapDetails);
                        JSONObject json = new JSONObject();
                        try {
                            String currencyCode = details.getPriceCurrencyCode();
                            double price = details.getPriceAmountMicros() * 0.000001;
                            String dollor = currencyCode + " " + String.format(Locale.US, "%.2f", price);
                            json.put("description", product.getDescription());
                            json.put("sku", product.getProductId());
                            json.put("title", product.getTitle());
                            json.put("type", product.getProductType());
                            json.put("price", price);
                            json.put("priceNum", details.getPriceAmountMicros()); // TODO: fixme?
                            json.put("priceDollar", dollor);
                            array.put(json);
                        } catch (JSONException e) {
                            Log.e(TAG, e.getMessage(), e);
                        }
                    }
                }
            }
            String prdListJson = array.toString();
            Log.d(TAG, "query products return -> " + prdListJson);
            InAppBillingBridge.callLuaLoadProductsCompleteCallbackMethod(prdListJson);
            _productIDsSet.clear();
            return true;
        }

        private Map<String, Object> infoFromProduct(@NonNull ProductDetails.OneTimePurchaseOfferDetails details) {
            String currencyCode = details.getPriceCurrencyCode();
            double price = details.getPriceAmountMicros() * 0.000001;
            Map<String, Object> infoMap = new HashMap<>();
            infoMap.put("currencyCode", currencyCode);
            infoMap.put("price", price);
            // 不使用 details.getFormattedPrice() 格式化价格，某些情况下货币符号会简写进而产生歧义，比如加元只显示“$”而不是“CA$”
            infoMap.put("displayPrice", currencyCode + " " + String.format(Locale.US, "%.2f", price));
            return infoMap;
        }
    }

    // 购买任务
    private static class PurchaseTask {
        private final long _userID;
        private final String _orderID;
        private final String _productID;

        public PurchaseTask(final long userID,
                            @NonNull final String orderID,
                            @NonNull final String productID) {
            _userID = userID;
            _orderID = orderID;
            _productID = productID;
        }

        public long getUserID() {
            return _userID;
        }

        public String getOrderID() {
            return _orderID;
        }

        public String getProductID() {
            return _productID;
        }

        public boolean isValid() {
            return (_userID > 0 && !_orderID.isEmpty() && !_productID.isEmpty());
        }

        // 完成购买
        public void accomplish(PurchaseStatus status) {
            HashMap<String, Object> map = new HashMap<>();
            map.put("status", status.getValue());
        }
    }

    // 停止所有任务
    private void stopAllTasks() {
        List<QueryTask> list = new ArrayList<>(_queryTasksList);
        _queryTasksList.clear();
        for (QueryTask task : list) {
            task.accomplish(false, false);
        }
        if (_purchaseTask != null) {
            _purchaseTask.accomplish(PurchaseStatus.FAILURE);
            _purchaseTask = null;
        }
    }

    // 停止链接
    private void stopSchedule() {
        if (_reconnectSchedule != null) {
            if (!_reconnectSchedule.isDone() || !_reconnectSchedule.isCancelled()) {
                Log.d(TAG, "stopSchedule: " + _reconnectSchedule.toString());
                _reconnectSchedule.cancel(true);
            }
            _reconnectSchedule = null;
        }
    }

    // 链接断开回调，重连计划
    @Override
    public void onBillingServiceDisconnected() {
        if (_reconnectCount >= 3) {
            Log.d(TAG, "onBillingServiceDisconnected: unable to connect");
            _reconnectCount = 0;
            // 连接断开，终止所有任务
            stopAllTasks();
            return;
        }

        double delay = Math.pow(2, _reconnectCount);
        ++_reconnectCount;

        Log.d(TAG, "onBillingServiceDisconnected: try reconnection (" + _reconnectCount + ")");

        stopSchedule();
        _reconnectSchedule = _scheduler.schedule((Runnable) this::startConnection, (long) delay, TimeUnit.SECONDS);
    }

    // 初始化链接回调
    @Override
    public void onBillingSetupFinished(@NonNull BillingResult billingResult) {
        Log.d(TAG, "Setup onBillingSetupFinished: " + billingResult);
        _reconnectCount = 0;
        stopSchedule();
        int responseCode = billingResult.getResponseCode();
        if (responseCode == BillingClient.BillingResponseCode.OK) {
            isSetupComplete = true;
            isSetuping = false;
            isSupported = true;
            InAppBillingBridge.callLuaSteupCompleteCallbackMethod(true);
            // 检查未完成订单
            checkUnfinishedPurchases();
            // 开始任务
            startQueryTask();
            startPurchaseTask();
        } else {
            // 连接失败，终止所有任务
            stopAllTasks();
            // Oh noes, there was a problem.
            Log.e(TAG, "Problem setting up in-app billing: " + responseCode);
            if (retryLimit-- > 0) {
                Log.i(TAG, "retry ... limit left " + retryLimit);
            } else {
                isSetupComplete = true;
                isSetuping = false;
                isSupported = false;
                InAppBillingBridge.callLuaSteupCompleteCallbackMethod(false);
            }
        }
    }

    // 处理购买结果
    @Override
    public void onPurchasesUpdated(@NonNull BillingResult billingResult, @Nullable List<Purchase> purchasesList) {
        Log.d(TAG, "onPurchasesUpdated: " + billingResult);

        int responseCode = billingResult.getResponseCode();
        if (responseCode == BillingClient.BillingResponseCode.OK) {
            if (purchasesList != null) {
                handlePurchases(purchasesList, false);
            }
        } else if (_purchaseTask != null) {
            PurchaseStatus status = PurchaseStatus.FAILURE;
            if (responseCode == BillingClient.BillingResponseCode.USER_CANCELED) {
                status = PurchaseStatus.CANCEL;
            } else if (responseCode == BillingClient.BillingResponseCode.FEATURE_NOT_SUPPORTED) {
                status = PurchaseStatus.UNSUPPORTED;
            } else if (responseCode == BillingClient.BillingResponseCode.ITEM_ALREADY_OWNED) {
                Log.w(TAG, "onPurchasesUpdated: product already owned");
                checkUnfinishedPurchases();
            }
            _purchaseTask.accomplish(status);
            _purchaseTask = null;
        }
    }

    // 处理购买结果
    @Override
    public void onQueryPurchasesResponse(@NonNull BillingResult billingResult, @NonNull List<Purchase> purchasesList) {
        Log.d(TAG, "onQueryPurchasesResponse: " + billingResult);
        if (billingResult.getResponseCode() == BillingClient.BillingResponseCode.OK) {
            handlePurchases(purchasesList, true);
        }
    }

    // 发货后消费成功
    @Override
    public void onConsumeResponse(@NonNull BillingResult billingResult, @NonNull String purchaseToken) {
        Log.d(TAG, "onConsumeResponse: " + billingResult);
        Purchase purchase = _unfinishedPurchasesMap.get(purchaseToken);
        if (purchase == null) {
            Log.w(TAG, "onConsumeResponse: purchase \"" + purchaseToken + "\" not found in cache");
            return;
        }
        String sku = purchase.getProducts().get(0);
        int responseCode = billingResult.getResponseCode();
        if (responseCode == BillingClient.BillingResponseCode.OK) {
            Log.d(TAG, "onConsumeResponse: purchase \"" + purchaseToken + "\" finished");
            Log.i(TAG, "Consumption successful. Provisioning.");
            InAppBillingBridge.callLuaConsumeCompleteCallbackMethod("success:" + sku);
        } else {
            // 下次登录应用的时候，会继续尝试
            InAppBillingBridge.callLuaConsumeCompleteCallbackMethod("fail:" + sku);
        }
    }

    // 构造函数
    public InAppBillingPlugin() {
    }

    @Override
    public void initialize() {
        Cocos2dxActivityWrapper.getContext().addObserver(this);
        disposeRunnable.run();
    }

    // 初始化
    @Override
    public void onCreate(Activity activity, Bundle savedInstanceState) {
        if (helperInit != false) {
            disposeRunnable.run();
        }
        helperInit = true;
    }

    @Override
    public void onDestroy(Activity activity) {
        disposeRunnable.run();
        stopSchedule();
        endConnection();
    }

    // 处理购买结果, 交由服务器处理
    private void handlePurchases(List<Purchase> purchasesList, boolean checkingUnfinishedPurchase) {
        if (purchasesList == null || purchasesList.isEmpty()) {
            Log.d(TAG, "handlePurchases: purchase not found");
            return;
        }
        Log.d(TAG, "handlePurchases: " + purchasesList.size() + " purchase(s) got");
        Set<String> productIDsSet = new HashSet<>();
        List<String> purchaseJsons = new ArrayList<>();
        List<String> purchaseTokens = new ArrayList<>();
        for (Purchase purchase : purchasesList) {
            Log.d(TAG, "purchaseState: " + purchase.getPurchaseState());
            if (purchase.getPurchaseState() == Purchase.PurchaseState.PURCHASED) {
                // 缓存购买信息，用于购买事件统计
                _unfinishedPurchasesMap.put(purchase.getPurchaseToken(), purchase);
                // 记录商品ID方便查询
                productIDsSet.addAll(purchase.getProducts());
                purchaseJsons.add(purchase.getOriginalJson());
                purchaseTokens.add(purchase.getPurchaseToken());
                JSONObject json = new JSONObject();
                try {
                    json.put("purchaseTime", purchase.getPurchaseTime());
                    json.put("developerPayload", purchase.getDeveloperPayload());
                    json.put("itemType", BillingClient.ProductType.INAPP);
                    json.put("orderId", purchase.getOrderId());
                    json.put("originalJson", purchase.getOriginalJson());
                    json.put("packageName", purchase.getPackageName());
                    json.put("signature", purchase.getSignature());
                    json.put("sku", purchase.getProducts().get(0)); // 当前只支持一次购买一个商品
                    json.put("token", purchase.getPurchaseToken());
                    json.put("purchaseState", purchase.getPurchaseState());
                } catch (JSONException e) {
                    Log.e(TAG, e.getMessage(), e);
                }
                InAppBillingBridge.callLuaPurchaseCompleteCallbackMethod(json.toString());
            }
        }
        if (!purchaseJsons.isEmpty()) {
            Log.d(TAG, "handlePurchases: handle purchases -- " + purchaseJsons);
            Map<String, Object> map = new HashMap<>();
            map.put("receiptDatas", purchaseJsons);
            map.put("clear", checkingUnfinishedPurchase);
            map.put("receiptIDs", purchaseTokens);
            // 一次全部给外包调用...暂不支持
        }
        if (!checkingUnfinishedPurchase && _purchaseTask != null && productIDsSet.contains(_purchaseTask.getProductID())) {
            _purchaseTask.accomplish(PurchaseStatus.SUCCESS);
            _purchaseTask = null;
        }
    }

    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
    }

    @Override
    public void setId(String id) {
        this.id = id;
    }

    // 是否完成初始化接口
    public boolean isSetupComplete() {
        return isSetupComplete;
    }

    // 是否支持接口
    public boolean isSupported() {
        return isSupported;
    }

    // 初始化环境接口: 给外部接口使用
    public void setup() {
        Cocos2dxActivityWrapper.getContext().getUIThreadHandler().removeCallbacks(disposeRunnable);
        startConnection();
    }

    // 查询商品接口: 加载查询商品
    public void loadProductList(String[] skus) {
        Set<String> productIDsSet = new HashSet<>();
        // 遍历数组中的每个元素
        for (String sku : skus) {
            productIDsSet.add(sku);
        }
        if (productIDsSet.isEmpty()) {
            Log.d(TAG, "query: invalid parameters");
            return;
        }
        QueryTask task = new QueryTask(productIDsSet);
        boolean success = _queryTasksList.add(task);
        if (success) {
            Log.d(TAG, "query: " + productIDsSet);
            startQueryTask();
        } else {
            Log.d(TAG, "query: adding query task failed -- " + productIDsSet);
            task.accomplish(false, false);
        }
    }

    // 检查未完成的订单接口: 当前暂没有被外部调用
    public void check(String arg) {
        if (startConnection()) {
            checkUnfinishedPurchases();
        }
    }

    // 开始查询商品信息
    private void startQueryTask() {
        if (_queryTasksList.isEmpty()) {
            return;
        }
        QueryTask headTask = _queryTasksList.get(0);
        if (headTask.isDone()) {
            _queryTasksList.remove(0);
            headTask.accomplish(true, false);
            startQueryTask();
        } else if (startConnection() && headTask.start()) {
            List<QueryProductDetailsParams.Product> productList = new ArrayList<>();
            for (String productID : headTask.getProductIDsSet()) {
                productList.add(QueryProductDetailsParams.Product.newBuilder()
                        .setProductId(productID)
                        .setProductType(BillingClient.ProductType.INAPP)
                        .build());
            }
            Log.d(TAG, "startQueryTask: query " + headTask.getProductIDsSet());
            QueryProductDetailsParams queryProductDetailsParams = QueryProductDetailsParams.newBuilder()
                    .setProductList(productList)
                    .build();
            _billingClient.queryProductDetailsAsync(queryProductDetailsParams, (@NonNull BillingResult billingResult,
                                                                                @NonNull List<ProductDetails> productDetailsList) -> {
                Log.d(TAG, "onProductDetailsResponse: " + billingResult);
                for (ProductDetails details : productDetailsList) {
                    _cachedProductDetailsMap.put(details.getProductId(), details);
                }
                QueryTask targetTask = null;
                for (QueryTask task : _queryTasksList) {
                    if (task == headTask) {
                        targetTask = task;
                        break;
                    }
                }
                if (targetTask != null) {
                    boolean success = false;
                    boolean retriable = false;
                    int responseCode = billingResult.getResponseCode();
                    if (responseCode == BillingClient.BillingResponseCode.OK) {
                        success = true;
                    } else if (responseCode == BillingClient.BillingResponseCode.SERVICE_TIMEOUT ||
                            responseCode == BillingClient.BillingResponseCode.SERVICE_DISCONNECTED ||
                            responseCode == BillingClient.BillingResponseCode.SERVICE_UNAVAILABLE ||
                            responseCode == BillingClient.BillingResponseCode.ERROR) {
                        retriable = true;
                    }
                    if (targetTask.accomplish(success, retriable)) {
                        _queryTasksList.remove(targetTask);
                    }
                    startQueryTask();
                }
            });
        }
    }

    // 购买商品接口: 从app调用，点击购买的商品时调用
    public void makePurchase(String orderId, String sku, String uid, String channel) {
        long userID = Long.parseLong(uid);
        String orderID = orderId;
        String productID = sku;
        PurchaseTask task = new PurchaseTask(userID, orderID, productID);
        if (!task.isValid()) {
            Log.d(TAG, "purchase: invalid parameters " + sku);
            task.accomplish(PurchaseStatus.FAILURE);
            return;
        }
        _purchaseTask = task;
        startPurchaseTask();
    }

    // 获取查询过的商品信息，内部缓存，无需再次访问
    public ProductDetails getCachedProduct(@NonNull String productID) {
        return _cachedProductDetailsMap.get(productID);
    }

    // 开始购买任务(界面开始显示，出现购买流程)
    private void startPurchaseTask() {
        if (_purchaseTask == null || !startConnection()) {
            return;
        }
        String productID = _purchaseTask.getProductID();
        ProductDetails details = getCachedProduct(productID);
        if (details == null) {
            Log.d(TAG, "startPurchaseTask: product \"" + productID + "\" not found");
            _purchaseTask.accomplish(PurchaseStatus.FAILURE);
            _purchaseTask = null;
            return;
        }
        Activity activity = Cocos2dxActivityWrapper.getContext();
        if (activity == null) {
            Log.d(TAG, "startConnection: activity not found");
            _purchaseTask.accomplish(PurchaseStatus.FAILURE);
            _purchaseTask = null;
            return;
        }
        BillingFlowParams.ProductDetailsParams params = BillingFlowParams.ProductDetailsParams.newBuilder()
                .setProductDetails(details)
                .build();
        BillingFlowParams billingFlowParams = BillingFlowParams.newBuilder()
                .setProductDetailsParamsList(Collections.singletonList(params))
                .setObfuscatedAccountId(String.valueOf(_purchaseTask.getUserID()))
                .setObfuscatedProfileId(_purchaseTask.getOrderID())
                .build();
        BillingResult billingResult = _billingClient.launchBillingFlow(activity, billingFlowParams);
        int responseCode = billingResult.getResponseCode();
        if (responseCode != BillingClient.BillingResponseCode.OK) {
            PurchaseStatus status = PurchaseStatus.FAILURE;
            if (responseCode == BillingClient.BillingResponseCode.FEATURE_NOT_SUPPORTED) {
                status = PurchaseStatus.UNSUPPORTED;
            } else if (responseCode == BillingClient.BillingResponseCode.ITEM_ALREADY_OWNED) {
                Log.w(TAG, "startConnection: product \"" + productID + "\" already owned");
                checkUnfinishedPurchases();
            }
            _purchaseTask.accomplish(status);
            _purchaseTask = null;
        }
    }

    // 提取购买交易
    private void checkUnfinishedPurchases() {
        Log.d(TAG, "checkUnfinishedPurchases: IN_APP");
        QueryPurchasesParams queryPurchasesParams = QueryPurchasesParams.newBuilder()
                .setProductType(BillingClient.ProductType.INAPP)
                .build();
        _billingClient.queryPurchasesAsync(queryPurchasesParams, this);
    }

    // 消费接口: 完成购买，则进行消费, 需要传入receiptIDs，即token
    public void consume(final String purchaseToken) {
        if (!startConnection()) {
            return;
        }
        Log.d(TAG, "consume: " + purchaseToken);
        ConsumeParams consumeParams = ConsumeParams.newBuilder()
                .setPurchaseToken(purchaseToken)
                .build();
        _billingClient.consumeAsync(consumeParams, this);
    }

    // 自动发货检查(内部)
    private Runnable disposeRunnable = new Runnable() {
        @Override
        public void run() {
            Cocos2dxActivityWrapper.getContext().getUIThreadHandler().removeCallbacks(disposeRunnable);
        }
    };

    // 自动发货检查(接口)
    public void delayDispose(int delaySeconds) {
        Cocos2dxActivityWrapper.getContext().getUIThreadHandler().postDelayed(disposeRunnable, delaySeconds * 1000);
    }
}

// doc:
// 查询商品信息(请求gp)-客户端展示-用户点击购买(请求gp)-支付(用户付钱)-完成(回调)-发货(服务器发货)-消化商品(请求gp)
// 下面是一次性购买或订阅的典型购买流程。
//
//        向用户展示他们可以购买什么。
//        启动购买流程，以便用户接受购买交易。
//        在您的服务器上验证购买交易。
//        向用户提供内容。
//        确认内容已传送给用户。对于消耗型商品，请将购买的商品标记为消耗，以便用户能够再次购买商品。
//
//        订阅会自动续订，直到被取消。订阅可处于下面这几种状态：
//
//        有效：用户信誉良好，可享用订阅内容。
//        已取消：用户已取消订阅，但在到期前仍可享用订阅内容。
//        处于宽限期：用户遇到了付款问题，但仍可享用订阅内容，同时 Google 会重新尝试通过相应的付款方式扣款。
//        暂时保留：用户遇到了付款问题，不能再享用订阅内容，同时 Google 会重新尝试通过相应的付款方式扣款。
//        已暂停：用户暂停了其订阅，在恢复之前不能享用订阅内容。
//        已到期：用户已取消且不能再享用订阅内容。用户在订阅到期时会被视为流失。
