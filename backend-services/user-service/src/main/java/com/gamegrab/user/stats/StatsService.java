package com.gamegrab.user.stats;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class StatsService {

    private final GrabStatisticsRepository statsRepository;

    public StatsService(GrabStatisticsRepository statsRepository) {
        this.statsRepository = statsRepository;
    }

    @Transactional
    public void recordClick(Long codeId, String deviceId, int clicks, int successCount) {
        LocalDate today = LocalDate.now();
        GrabStatistics stats = statsRepository.findByCodeIdAndDeviceIdAndGrabDate(codeId, deviceId, today)
                .orElseGet(() -> {
                    GrabStatistics newStats = new GrabStatistics();
                    newStats.setCodeId(codeId);
                    newStats.setDeviceId(deviceId);
                    newStats.setGrabDate(today);
                    return newStats;
                });
        stats.setTotalClicks(stats.getTotalClicks() + clicks);
        stats.setSuccessCount(stats.getSuccessCount() + successCount);
        stats.setUpdatedAt(LocalDateTime.now());
        statsRepository.save(stats);
    }

    public Map<String, Object> getStatsByDevice(String deviceId) {
        List<GrabStatistics> list = statsRepository.findByDeviceIdOrderByGrabDateDesc(deviceId);
        long totalClicks = list.stream().mapToInt(GrabStatistics::getTotalClicks).sum();
        long totalSuccess = list.stream().mapToInt(GrabStatistics::getSuccessCount).sum();

        Map<String, Object> result = new HashMap<>();
        result.put("totalClicks", totalClicks);
        result.put("totalSuccess", totalSuccess);
        result.put("dailyStats", list);
        return result;
    }

    public Map<String, Object> getStatsByCode(Long codeId) {
        Long totalClicks = statsRepository.sumTotalClicksByCodeId(codeId);
        Long totalSuccess = statsRepository.sumSuccessCountByCodeId(codeId);
        List<GrabStatistics> list = statsRepository.findByCodeIdOrderByGrabDateDesc(codeId);

        Map<String, Object> result = new HashMap<>();
        result.put("totalClicks", totalClicks != null ? totalClicks : 0);
        result.put("totalSuccess", totalSuccess != null ? totalSuccess : 0);
        result.put("dailyStats", list);
        return result;
    }
}
