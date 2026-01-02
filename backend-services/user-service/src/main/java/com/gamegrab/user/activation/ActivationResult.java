package com.gamegrab.user.activation;

public class ActivationResult {

    private boolean success;
    private String message;
    private String token;
    private Long remainingSeconds;

    public ActivationResult() {
    }

    public ActivationResult(boolean success, String message, String token, Long remainingSeconds) {
        this.success = success;
        this.message = message;
        this.token = token;
        this.remainingSeconds = remainingSeconds;
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Long getRemainingSeconds() {
        return remainingSeconds;
    }

    public void setRemainingSeconds(Long remainingSeconds) {
        this.remainingSeconds = remainingSeconds;
    }
}
