package com.opentexas.cocoslib.core.functions;

import org.cocos2dx.lib.Cocos2dxActivity;

import com.opentexas.cocoslib.core.Cocos2dxActivityWrapper;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.util.Log;

public class CheckSMSFunction {
    private static final String TAG = CheckSMSFunction.class.getSimpleName();

    public static boolean isSMSEnabled() {
    	/*Context ctx = Cocos2dxActivityWrapper.getContext();
    	if (Build.VERSION.SDK_INT < 23) {//一般android6.0以下会在安装时自动获取权限,但在小米机上，可能通过用户权限管理更改权限
    		Log.d(TAG, "SDK_INT < 23 isSendEnabled = true");*/
        return true;
		/*} else {
			//targetSdkVersion<23时 即便运行在android6.0及以上设备 ContextWrapper.checkSelfPermission和Context.checkSelfPermission失效
            //返回值始终为PERMISSION_GRANTED
            //此时必须使用PermissionChecker.checkSelfPermission
			if (ctx.getApplicationInfo().targetSdkVersion < 23) {
				if (PermissionChecker.checkSelfPermission(ctx, Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED) {
					Log.d(TAG, "targetSdkVersion < 23 isSendEnabled = false");
					return false;
				}else {
					Log.d(TAG, "targetSdkVersion < 23 isSendEnabled = true");
					return true;
				}
			} else {
				if(ContextCompat.checkSelfPermission(ctx, Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED) {
					Log.d(TAG, "targetSdkVersion >= 23 isSendEnabled = false");
	                return false;
	            }else {
	            	Log.d(TAG, "targetSdkVersion >= 23 isSendEnabled = true");
	                return true;
				}
			}
		}*/
    }

    public static void setSMSEnabled() {
    	/*Context ctx = Cocos2dxActivityWrapper.getContext();
    	Activity activity = (Activity)ctx;
    	if (!activity.shouldShowRequestPermissionRationale(Manifest.permission.SEND_SMS)) {
    		Intent intent = new Intent();
        	intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        	intent.setAction("android.settings.APPLICATION_DETAILS_SETTINGS");
        	intent.setData(Uri.fromParts("package", ctx.getPackageName(), null));
        	ctx.startActivity(intent);
		}else {
			ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.SEND_SMS}, 1);
		}*/
    }
}
