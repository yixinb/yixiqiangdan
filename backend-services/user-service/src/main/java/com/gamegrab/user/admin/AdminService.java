package com.gamegrab.user.admin;

import com.gamegrab.user.activation.ActivationCode;
import com.gamegrab.user.activation.ActivationCodeRepository;
import com.gamegrab.user.activation.ActivationCodeStatus;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.Key;
import java.time.Instant;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

@Service
public class AdminService {

    private static final String SECRET = "bXktdmVyeS1zZWNyZXQta2V5LXNob3VsZC1iZS1sb25nLWVub3VnaA==";
    private static final String CODE_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";

    private final AdminRepository adminRepository;
    private final ActivationCodeRepository codeRepository;

    public AdminService(AdminRepository adminRepository, ActivationCodeRepository codeRepository) {
        this.adminRepository = adminRepository;
        this.codeRepository = codeRepository;
    }

    public AdminLoginResult login(String username, String password) {
        Admin admin = adminRepository.findByUsername(username)
                .orElseThrow(() -> new IllegalArgumentException("用户名或密码错误"));
        if (!admin.getPassword().equals(password)) {
            throw new IllegalArgumentException("用户名或密码错误");
        }
        String token = generateAdminToken(admin.getId());
        return new AdminLoginResult(true, "登录成功", token);
    }

    @Transactional
    public List<String> generateCodes(int count, int durationDays) {
        List<String> codes = new ArrayList<>();
        Random random = new Random();
        for (int i = 0; i < count; i++) {
            String code = generateRandomCode(random);
            ActivationCode activationCode = new ActivationCode();
            activationCode.setCode(code);
            activationCode.setStatus(ActivationCodeStatus.UNSOLD);
            activationCode.setDurationDays(durationDays);
            codeRepository.save(activationCode);
            codes.add(code);
        }
        return codes;
    }

    public List<ActivationCode> listCodes() {
        return codeRepository.findAll();
    }

    @Transactional
    public void disableCode(String code) {
        ActivationCode activationCode = codeRepository.findByCode(code)
                .orElseThrow(() -> new IllegalArgumentException("卡密不存在"));
        activationCode.setStatus(ActivationCodeStatus.DISABLED);
        codeRepository.save(activationCode);
    }

    private String generateRandomCode(Random random) {
        StringBuilder sb = new StringBuilder(12);
        for (int i = 0; i < 12; i++) {
            sb.append(CODE_CHARS.charAt(random.nextInt(CODE_CHARS.length())));
        }
        return sb.toString();
    }

    private Key getSigningKey() {
        byte[] keyBytes = Decoders.BASE64.decode(SECRET);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    private String generateAdminToken(Long adminId) {
        Instant now = Instant.now();
        Instant exp = now.plusSeconds(3600 * 24);
        return Jwts.builder()
                .setSubject("admin:" + adminId)
                .setIssuedAt(Date.from(now))
                .setExpiration(Date.from(exp))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    @Bean
    public CommandLineRunner initDefaultAdmin() {
        return args -> {
            if (adminRepository.findByUsername("yixinb").isEmpty()) {
                Admin admin = new Admin();
                admin.setUsername("yixinb");
                admin.setPassword("20240610");
                adminRepository.save(admin);
            }
        };
    }
}
