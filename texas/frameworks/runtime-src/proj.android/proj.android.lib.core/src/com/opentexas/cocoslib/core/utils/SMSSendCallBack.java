package com.opentexas.cocoslib.core.utils;

public interface SMSSendCallBack {
    public void onSuccess(int code);

    public void onFailed(int code);
}
