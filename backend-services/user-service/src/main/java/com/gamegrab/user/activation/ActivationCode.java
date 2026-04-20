package com.gamegrab.user.activation;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "activation_codes")
public class ActivationCode {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 32)
    private String code;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ActivationCodeStatus status = ActivationCodeStatus.UNSOLD;

    @Column(name = "duration_days")
    private Integer durationDays;

    @Column(name = "bind_device_id", length = 128)
    private String bindDeviceId;

    @Column(name = "bind_count")
    private Integer bindCount = 0;

    @Column(name = "activated_at")
    private LocalDateTime activatedAt;

    @Column(name = "expires_at")
    private LocalDateTime expiresAt;

    @Column(name = "created_at", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public ActivationCodeStatus getStatus() {
        return status;
    }

    public void setStatus(ActivationCodeStatus status) {
        this.status = status;
    }

    public Integer getDurationDays() {
        return durationDays;
    }

    public void setDurationDays(Integer durationDays) {
        this.durationDays = durationDays;
    }

    public String getBindDeviceId() {
        return bindDeviceId;
    }

    public void setBindDeviceId(String bindDeviceId) {
        this.bindDeviceId = bindDeviceId;
    }

    public Integer getBindCount() {
        return bindCount;
    }

    public void setBindCount(Integer bindCount) {
        this.bindCount = bindCount;
    }

    public LocalDateTime getActivatedAt() {
        return activatedAt;
    }

    public void setActivatedAt(LocalDateTime activatedAt) {
        this.activatedAt = activatedAt;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
