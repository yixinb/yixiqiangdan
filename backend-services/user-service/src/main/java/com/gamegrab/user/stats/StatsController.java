package com.gamegrab.user.stats;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/stats")
public class StatsController {

    private final StatsService statsService;

    public StatsController(StatsService statsService) {
        this.statsService = statsService;
    }

    @PostMapping("/record")
    public ResponseEntity<Map<String, Object>> recordClick(@RequestBody Map<String, Object> request) {
        Long codeId = Long.valueOf(request.get("codeId").toString());
        String deviceId = request.get("deviceId").toString();
        int clicks = Integer.parseInt(request.getOrDefault("clicks", 1).toString());
        int successCount = Integer.parseInt(request.getOrDefault("successCount", 0).toString());

        statsService.recordClick(codeId, deviceId, clicks, successCount);
        return ResponseEntity.ok(Map.of("success", true));
    }

    @GetMapping("/device/{deviceId}")
    public ResponseEntity<Map<String, Object>> getStatsByDevice(@PathVariable String deviceId) {
        return ResponseEntity.ok(statsService.getStatsByDevice(deviceId));
    }

    @GetMapping("/code/{codeId}")
    public ResponseEntity<Map<String, Object>> getStatsByCode(@PathVariable Long codeId) {
        return ResponseEntity.ok(statsService.getStatsByCode(codeId));
    }
}
