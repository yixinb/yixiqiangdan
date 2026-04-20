package com.gamegrab.user.activation;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.stereotype.Service;

import java.security.Key;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.Date;

@Service
public class JwtService {

    // 示例用固定密钥，正式环境请放到配置中
    private static final String SECRET = "bXktdmVyeS1zZWNyZXQta2V5LXNob3VsZC1iZS1sb25nLWVub3VnaA==";

    private Key getSigningKey() {
        byte[] keyBytes = Decoders.BASE64.decode(SECRET);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    public String generateToken(String userId, LocalDateTime expiresAt) {
        Instant now = Instant.now();
        Instant exp = expiresAt.toInstant(ZoneOffset.UTC);
        return Jwts.builder()
                .setSubject(userId)
                .setIssuedAt(Date.from(now))
                .setExpiration(Date.from(exp))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
    }
}
