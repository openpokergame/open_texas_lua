package com.opentexas.cocoslib.core.functions;

import org.cocos2dx.lib.Cocos2dxActivity;

import android.view.Gravity;
import android.view.View;
import android.webkit.WebSettings.LayoutAlgorithm;
import android.webkit.WebView;
import android.widget.FrameLayout;

import com.opentexas.cocoslib.core.Cocos2dxActivityUtil;
import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;

public class WebFunction {
    private static FrameLayout m_webLayout;
    private static FrameLayout.LayoutParams m_lytp;
    private static WebView m_webView;

    public static void openWebPay(final String gotoUrl, final int width, final int height, final int x, final int y) {
        Cocos2dxActivityUtil.runOnUIThreadDelay(new Runnable() {
            @Override
            public void run() {
                if (null == m_webLayout) {
                    m_webLayout = new FrameLayout(Cocos2dxActivity.getContext());
                    m_webLayout.bringToFront();
                    m_lytp = new FrameLayout.LayoutParams(width, height);
                }
                m_lytp.width = width;
                m_lytp.height = height;
                m_lytp.gravity = Gravity.BOTTOM | Gravity.LEFT;
                m_lytp.leftMargin = x;
                m_lytp.bottomMargin = y;
                m_webView = new WebView(Cocos2dxActivity.getContext());
                m_webView.setFocusableInTouchMode(false);   //设置不响应虚拟按键等   这种修改会引入一个问题。如果有需求在网页上面弹出输入框，就没法实现了 
//                // Web重写点击事件的处理
//                @Override 
//                public boolean onKeyDown(int keyCode, KeyEvent event) {
//                    // 发现是返回按钮的话，我们自己做默认处理，其他的交给系统处理
//                    if (KeyEvent.KEYCODE_BACK == keyCode) {
//                        return true;
//                    }
//                    
//                    return false;
//                }
                m_webView.getSettings().setJavaScriptEnabled(true);
                m_webView.getSettings().setSupportZoom(false);
                // setting.setUseWideViewPort(true);
                m_webView.getSettings().setLoadWithOverviewMode(true);
                m_webView.getSettings().setBuiltInZoomControls(false);
                m_webView.getSettings().setLayoutAlgorithm(LayoutAlgorithm.NORMAL);
                m_webView.requestFocus();
                m_webView.loadUrl(gotoUrl);
                m_webView.setVisibility(View.VISIBLE);
                m_webLayout.addView(m_webView);
                Cocos2dxActivityWrapper.getContext().addContentView(m_webLayout, m_lytp);
            }
        }, 5);
    }

    public static void removeWebPay() {
        Cocos2dxActivityUtil.runOnUIThreadDelay(new Runnable() {
            @Override
            public void run() {
                if (null != m_webView && null != m_webLayout) {
                    //ViewGroup vg = (ViewGroup) m_webView.getParent();
                    m_webLayout.removeView(m_webView);
                    m_webView.removeAllViews();
                    m_webView.destroy();
                    m_webView = null;
                }
            }
        }, 5);
    }
}
