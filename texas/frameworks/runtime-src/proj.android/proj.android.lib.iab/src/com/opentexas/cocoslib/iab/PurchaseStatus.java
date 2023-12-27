package com.opentexas.cocoslib.iab;

public enum PurchaseStatus {
    SUCCESS("success"),
    FAILURE("failure"),
    CANCEL("cancel"),
    UNSUPPORTED("unsupported"),
    ;

    private final String _value;

    PurchaseStatus(String value) {
        this._value = value;
    }

    public final String getValue() {
        return this._value;
    }
}
