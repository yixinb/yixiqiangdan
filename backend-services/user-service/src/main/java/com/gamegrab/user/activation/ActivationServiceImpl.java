package com.gamegrab.user.activation;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

@Service
public class ActivationServiceImpl implements ActivationService {

    private final ActivationCodeRepository codeRepository;
    private final JwtService jwtService;

    public ActivationServiceImpl(ActivationCodeRepository codeRepository, JwtService jwtService) {
        this.codeRepository = codeRepository;
        this.jwtService = jwtService;
    }

    @Override
    @Transactional
    public ActivationResult activateCode(String code, String deviceId) {
        validateCodeFormat(code);

        ActivationCode activationCode = codeRepository.findByCode(code)
                .orElseThrow(() -> new IllegalArgumentException("卡密不存在"));

        validateCodeStatus(activationCode);

        checkDeviceBindLimit(activationCode, deviceId);

        LocalDateTime now = LocalDateTime.now();
        if (activationCode.getActivatedAt() == null) {
            activationCode.setActivatedAt(now);
        }
        if (activationCode.getExpiresAt() == null && activationCode.getDurationDays() != null) {
            activationCode.setExpiresAt(now.plusDays(activationCode.getDurationDays()));
        }
        activationCode.setStatus(ActivationCodeStatus.ACTIVATED);
        codeRepository.save(activationCode);

        long remainingSeconds = activationCode.getExpiresAt() != null
                ? ChronoUnit.SECONDS.between(now, activationCode.getExpiresAt())
                : 0L;

        String token = jwtService.generateToken(String.valueOf(activationCode.getId()), activationCode.getExpiresAt());

        return new ActivationResult(true, "激活成功", token, remainingSeconds);
    }

    private void validateCodeFormat(String code) {
        if (code == null || code.length() != 12) {
            throw new IllegalArgumentException("卡密格式不正确，必须为12位");
        }
    }

    private void validateCodeStatus(ActivationCode activationCode) {
        if (activationCode.getStatus() == ActivationCodeStatus.DISABLED) {
            throw new IllegalStateException("卡密已被禁用");
        }
        if (activationCode.getStatus() == ActivationCodeStatus.EXPIRED) {
            throw new IllegalStateException("卡密已过期");
        }
    }

    private void checkDeviceBindLimit(ActivationCode activationCode, String deviceId) {
        String bindDeviceId = activationCode.getBindDeviceId();
        if (bindDeviceId == null) {
            activationCode.setBindDeviceId(deviceId);
            activationCode.setBindCount(1);
            return;
        }
        if (!bindDeviceId.equals(deviceId)) {
            throw new IllegalStateException("该卡密已绑定其他设备");
        }
    }
}
