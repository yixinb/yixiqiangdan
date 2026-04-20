import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  static const String _baseUrl = 'http://10.0.2.2:8081';

  Future<String> chat(String message) async {
    final url = Uri.parse('$_baseUrl/api/ai/chat');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}),
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['reply'] ?? '无响应';
      }
      return '请求失败';
    } catch (e) {
      return 'AI服务不可用: $e';
    }
  }

  Future<String> generateRule(String description) async {
    final url = Uri.parse('$_baseUrl/api/ai/generate-rule');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'description': description}),
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return data['result'] ?? '无结果';
      }
      return '生成失败';
    } catch (e) {
      return 'AI服务不可用: $e';
    }
  }
}
