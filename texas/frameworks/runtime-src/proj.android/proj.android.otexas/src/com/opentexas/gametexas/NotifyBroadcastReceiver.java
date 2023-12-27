package com.opentexas.gametexas;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.support.v4.app.NotificationCompat;

public class NotifyBroadcastReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        // TODO Auto-generated method stub
        String action = intent.getAction();
        String typeStr = intent.getType();
        int index = action.indexOf("intent.action.alarmnotify.matchWillStart");
        if (index == 0) {
            NotificationManager localNotificationManager = (NotificationManager) context
                    .getSystemService("notification");
            NotificationCompat.Builder localBuilder = new NotificationCompat.Builder(
                    context);
            localBuilder.setSmallIcon(R.drawable.ic_stat_gcm);
//             localBuilder.setTicker("比赛即将开始");
//             localBuilder.setTicker(typeStr);
//             localBuilder.setContentTitle("比赛信息");
//             localBuilder.setContentText("您报名的比赛将在一分钟后开始，赶紧回游戏参赛吧！");
//             localBuilder.setAutoCancel( true);
            Intent localIntent = new Intent(context, GameMain.class);
            localIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            localIntent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
            localBuilder.setContentIntent(PendingIntent.getActivity(context, 0,
                    localIntent, PendingIntent.FLAG_ONE_SHOT));
            Notification notfi = localBuilder.build();
            notfi.defaults = Notification.DEFAULT_SOUND;
            notfi.defaults |= Notification.DEFAULT_LIGHTS;
            localNotificationManager.notify(1, notfi);
        }
    }
}
