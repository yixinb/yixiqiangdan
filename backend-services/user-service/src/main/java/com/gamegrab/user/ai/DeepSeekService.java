package com.gamegrab.user.ai;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DeepSeekService {

    @Value("${deepseek.api.key:sk-cfb24d90a0a5436082a3f9605fd1f2f3}")
    private String apiKey;

    @Value("${deepseek.api.url:https://api.deepseek.com/v1/chat/completions}")
    private String apiUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    public String chat(String userMessage) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(apiKey);

        Map<String, Object> message = new HashMap<>();
        message.put("role", "user");
        message.put("content", userMessage);

        Map<String, Object> body = new HashMap<>();
        body.put("model", "deepseek-chat");
        body.put("messages", List.of(message));
        body.put("max_tokens", 2048);

        HttpEntity<Map<String, Object>> request = new HttpEntity<>(body, headers);

        try {
            ResponseEntity<Map> response = restTemplate.exchange(
                    apiUrl, HttpMethod.POST, request, Map.class);

            if (response.getBody() != null) {
                List<Map<String, Object>> choices = (List<Map<String, Object>>) response.getBody().get("choices");
                if (choices != null && !choices.isEmpty()) {
                    Map<String, Object> messageResp = (Map<String, Object>) choices.get(0).get("message");
                    return (String) messageResp.get("content");
                }
            }
        } catch (Exception e) {
            return "AI服务暂时不可用: " + e.getMessage();
        }
        return "无响应";
    }

    public String generateGrabRule(String clubDescription) {
        String prompt = "你是一个游戏俱乐部抢单助手。用户描述了一个俱乐部的界面布局，请根据描述生成抢单操作步骤（JSON格式）。" +
                "输出格式：{\"steps\": [{\"action\": \"click\", \"description\": \"点击刷新按钮\"}, ...]}。" +
                "用户描述：" + clubDescription;
        return chat(prompt);
    }
}
