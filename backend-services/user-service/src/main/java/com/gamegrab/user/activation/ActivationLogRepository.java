package com.gamegrab.user.activation;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ActivationLogRepository extends JpaRepository<ActivationLog, Long> {

    List<ActivationLog> findByCodeIdOrderByCreatedAtDesc(Long codeId);

    List<ActivationLog> findByDeviceIdOrderByCreatedAtDesc(String deviceId);
}
