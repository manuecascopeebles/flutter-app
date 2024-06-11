package com.incode.onboarding_flutter_wrapper;

import android.app.Activity;

import com.incode.welcome_sdk.listeners.OnboardingSessionListener;

import java.util.HashMap;

import io.flutter.plugin.common.MethodChannel;

public class FlutterOnboardingSessionListener implements OnboardingSessionListener {
    private final Activity activity;
    private final MethodChannel.Result result;

    public FlutterOnboardingSessionListener(Activity activity, MethodChannel.Result result) {
        this.activity = activity;
        this.result = result;
    }

    @Override
    public void onOnboardingSessionCreated(String token, String interviewId, String regionId) {
        final HashMap<String, Object> response = new HashMap<>();
        final HashMap<String, Object> data = new HashMap<>();

        data.put("token", token);
        data.put("interviewId", interviewId);
        data.put("regionCode", regionId);

        response.put("success", true);
        response.put("data", data);
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                result.success(response);
            }
        });
    }

    @Override
    public void onError(Throwable throwable) {
        final HashMap<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("error", throwable.getMessage());
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                result.success(response);
            }
        });
    }

    @Override
    public void onUserCancelled() {
        final HashMap<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("error", "UserCancelled");
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                result.success(response);
            }
        });
    }
}
