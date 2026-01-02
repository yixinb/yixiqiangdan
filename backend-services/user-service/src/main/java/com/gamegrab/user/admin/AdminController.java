package com.gamegrab.user.admin;

import com.gamegrab.user.activation.ActivationCode;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    private final AdminService adminService;

    public AdminController(AdminService adminService) {
        this.adminService = adminService;
    }

    @PostMapping("/login")
    public ResponseEntity<AdminLoginResult> login(@Valid @RequestBody AdminLoginRequest request) {
        AdminLoginResult result = adminService.login(request.getUsername(), request.getPassword());
        return ResponseEntity.ok(result);
    }

    @PostMapping("/codes/generate")
    public ResponseEntity<Map<String, Object>> generateCodes(@RequestBody Map<String, Integer> request) {
        int count = request.getOrDefault("count", 1);
        int durationDays = request.getOrDefault("durationDays", 30);
        List<String> codes = adminService.generateCodes(count, durationDays);
        return ResponseEntity.ok(Map.of("success", true, "codes", codes));
    }

    @GetMapping("/codes")
    public ResponseEntity<List<ActivationCode>> listCodes() {
        return ResponseEntity.ok(adminService.listCodes());
    }

    @PostMapping("/codes/disable")
    public ResponseEntity<Map<String, Object>> disableCode(@RequestBody Map<String, String> request) {
        String code = request.get("code");
        adminService.disableCode(code);
        return ResponseEntity.ok(Map.of("success", true, "message", "卡密已禁用"));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<AdminLoginResult> handleException(IllegalArgumentException ex) {
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(new AdminLoginResult(false, ex.getMessage(), null));
    }
}
