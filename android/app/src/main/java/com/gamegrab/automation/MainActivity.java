package com.gamegrab.automation;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.gamegrab.automation";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "performClick":
                            Double x = call.argument("x");
                            Double y = call.argument("y");
                            if (x != null && y != null) {
                                performClick(x.floatValue(), y.floatValue());
                                result.success(true);
                            } else {
                                result.error("INVALID_ARGS", "x and y required", null);
                            }
                            break;
                        case "openAccessibilitySettings":
                            openAccessibilitySettings();
                            result.success(true);
                            break;
                        case "isAccessibilityEnabled":
                            result.success(isAccessibilityEnabled());
                            break;
                        case "startForegroundService":
                            startGrabService();
                            result.success(true);
                            break;
                        case "stopForegroundService":
                            stopGrabService();
                            result.success(true);
                            break;
                        default:
                            result.notImplemented();
                    }
                });
    }

    private void performClick(float x, float y) {
        AutoClickService service = AutoClickService.getInstance();
        if (service != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            service.performClick(x, y);
        }
    }

    private void openAccessibilitySettings() {
        Intent intent = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }

    private boolean isAccessibilityEnabled() {
        return AutoClickService.getInstance() != null;
    }

    private void startGrabService() {
        Intent intent = new Intent(this, GrabForegroundService.class);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent);
        } else {
            startService(intent);
        }
    }

    private void stopGrabService() {
        Intent intent = new Intent(this, GrabForegroundService.class);
        intent.setAction("STOP");
        startService(intent);
    }
}
