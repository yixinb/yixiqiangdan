package com.gamegrab.user.activation;

public interface ActivationService {

    ActivationResult activateCode(String code, String deviceId);
}
