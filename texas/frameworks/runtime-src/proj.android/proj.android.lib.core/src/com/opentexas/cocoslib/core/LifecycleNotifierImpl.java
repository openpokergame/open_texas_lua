package com.opentexas.cocoslib.core;

import java.util.Iterator;
import java.util.LinkedHashSet;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.util.Log;

public class LifecycleNotifierImpl implements ILifecycleNotifier {
    protected final String TAG = getClass().getSimpleName();
    private LinkedHashSet<ILifecycleObserver> observers = new LinkedHashSet<ILifecycleObserver>();

    @Override
    public void addObserver(ILifecycleObserver observer) {
        if (!observers.contains(observer)) {
            observers.add(observer);
        }
    }

    @Override
    public void removeObserver(ILifecycleObserver observer) {
        if (observers.contains(observer)) {
            observers.remove(observer);
        }
    }

    public void onCreate(Activity activity, Bundle savedInstanceState) {
        Iterator<ILifecycleObserver> it = observers.iterator();
        while (it.hasNext()) {
            ILifecycleObserver observer = it.next();
            observer.onCreate(activity, savedInstanceState);
        }
    }

    public void onRestoreInstanceState(Activity activity, Bundle savedInstanceState) {
        Iterator<ILifecycleObserver> it = observers.iterator();
        while (it.hasNext()) {
            ILifecycleObserver observer = it.next();
            observer.onRestoreInstanceState(activity, savedInstanceState);
        }
    }

    public void onStart(Activity activity) {
        Iterator<ILifecycleObserver> it = observers.iterator();
        while (it.hasNext()) {
            ILifecycleObserver observer = it.next();
            observer.onStart(activity);
        }
    }

    public void onRequestPermissionsResult(Activity activity, int requestCode, String[] permissions, int[] grantResults) {
        Iterator<ILifecycleObserver> it = observers.iterator();
        while (it.hasNext()) {
            ILifecycleObserver observer = it.next();
            observer.onRequestPermissionsResult(activity, requestCode, permissions, grantResults);
        }
    }

    public void onRestart(Activity activity) {
        Iterator<ILifecycleObserver> it = observers.iterator();
        while (it.hasNext()) {
            ILifecycleObserver observer = it.next();
            observer.onRestart(activity);
        }
    }

    public void onSaveInstanceState(Activity activity, Bundle outState) {
        Iterator<ILifecycleObserver> it = observers.iterator();
        while (it.hasNext()) {
            ILifecycleObserver observer = it.next();
            observer.onSaveInstanceState(activity, outState);
        }
    }

    public void onPause(Activity activity) {
        Iterator<ILifecycleObserver> it = observers.iterator();
        while (it.hasNext()) {
            ILifecycleObserver observer = it.next();
            observer.onPause(activity);
        }
    }

    public void onResume(Activity activity) {
        Iterator<ILifecycleObserver> it = observers.iterator();
        while (it.hasNext()) {
            ILifecycleObserver observer = it.next();
            observer.onResume(activity);
        }
    }

    public void onStop(Activity activity) {
        Iterator<ILifecycleObserver> it = observers.iterator();
        while (it.hasNext()) {
            ILifecycleObserver observer = it.next();
            observer.onStop(activity);
        }
    }

    public void onDestroy(Activity activity) {
        Iterator<ILifecycleObserver> it = observers.iterator();
        while (it.hasNext()) {
            ILifecycleObserver observer = it.next();
            observer.onDestroy(activity);
        }
    }

    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
        Iterator<ILifecycleObserver> it = observers.iterator();
        while (it.hasNext()) {
            ILifecycleObserver observer = it.next();
            observer.onActivityResult(activity, requestCode, resultCode, data);
        }
    }

    public void onNewIntent(Intent intent) {
        Iterator<ILifecycleObserver> it = observers.iterator();
        while (it.hasNext()) {
            ILifecycleObserver observer = it.next();
            observer.onNewIntent(intent);
        }
    }

    public void onConfigurationChanged(Configuration newConfig) {
        Iterator<ILifecycleObserver> it = observers.iterator();
        while (it.hasNext()) {
            ILifecycleObserver observer = it.next();
            observer.onConfigurationChanged(newConfig);
        }
    }
}
