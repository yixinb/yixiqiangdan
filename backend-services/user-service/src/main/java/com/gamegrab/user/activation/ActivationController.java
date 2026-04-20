package com.gamegrab.user.activation;

import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/activation")
public class ActivationController {

    private final ActivationService activationService;

    public ActivationController(ActivationService activationService) {
        this.activationService = activationService;
    }

    @PostMapping("/activate")
    public ResponseEntity<ActivationResult> activate(@Valid @RequestBody ActivationRequest request) {
        ActivationResult result = activationService.activateCode(request.getCode(), request.getDeviceId());
        return ResponseEntity.ok(result);
    }

    @ExceptionHandler({IllegalArgumentException.class, IllegalStateException.class})
    public ResponseEntity<ActivationResult> handleBusinessException(RuntimeException ex) {
        ActivationResult result = new ActivationResult(false, ex.getMessage(), null, 0L);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(result);
    }
}
