package com.incode.onboarding_flutter_wrapper;

public enum IncodeSdkInitError {
    SIMULATOR_DETECTED("simulatorDetected"),
    TEST_MODE_ENABLED("testModeEnabled"),
    ROOT_DETECTED("rootDetected"),
    HOOK_DETECTED("hookDetected"),
    UNKNOWN("unknown");

    private final String value;

    IncodeSdkInitError(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
