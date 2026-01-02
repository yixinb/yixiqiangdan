package com.gamegrab.user.activation;

import jakarta.validation.constraints.NotBlank;

public class ActivationRequest {

    @NotBlank
    private String code;

    @NotBlank
    private String deviceId;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }
}
