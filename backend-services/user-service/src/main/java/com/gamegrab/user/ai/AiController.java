package com.gamegrab.user.ai;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/ai")
public class AiController {

    private final DeepSeekService deepSeekService;

    public AiController(DeepSeekService deepSeekService) {
        this.deepSeekService = deepSeekService;
    }

    @PostMapping("/chat")
    public ResponseEntity<Map<String, Object>> chat(@RequestBody Map<String, String> request) {
        String message = request.get("message");
        String reply = deepSeekService.chat(message);
        return ResponseEntity.ok(Map.of("success", true, "reply", reply));
    }

    @PostMapping("/generate-rule")
    public ResponseEntity<Map<String, Object>> generateRule(@RequestBody Map<String, String> request) {
        String description = request.get("description");
        String result = deepSeekService.generateGrabRule(description);
        return ResponseEntity.ok(Map.of("success", true, "result", result));
    }
}
