package com.gamegrab.user.stats;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface GrabStatisticsRepository extends JpaRepository<GrabStatistics, Long> {

    Optional<GrabStatistics> findByCodeIdAndDeviceIdAndGrabDate(Long codeId, String deviceId, LocalDate grabDate);

    List<GrabStatistics> findByCodeIdOrderByGrabDateDesc(Long codeId);

    List<GrabStatistics> findByDeviceIdOrderByGrabDateDesc(String deviceId);

    @Query("SELECT SUM(g.totalClicks) FROM GrabStatistics g WHERE g.codeId = ?1")
    Long sumTotalClicksByCodeId(Long codeId);

    @Query("SELECT SUM(g.successCount) FROM GrabStatistics g WHERE g.codeId = ?1")
    Long sumSuccessCountByCodeId(Long codeId);
}
