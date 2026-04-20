import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'http://10.0.2.2:8081'; // Android 模拟器访问本机
  static const String _tokenKey = 'auth_token';
  static const String _expiresKey = 'auth_expires';

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    }
    return 'unknown_device';
  }

  Future<bool> isActivated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final expiresAt = prefs.getInt(_expiresKey);
    if (token == null || expiresAt == null) return false;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now < expiresAt;
  }

  Future<ActivationResult> activate(String code) async {
    final deviceId = await getDeviceId();
    final url = Uri.parse('$_baseUrl/api/activation/activate');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'code': code, 'deviceId': deviceId}),
    );
    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, data['token']);
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final expires = now + (data['remainingSeconds'] as int);
      await prefs.setInt(_expiresKey, expires);
    }
    return ActivationResult(
      success: data['success'] ?? false,
      message: data['message'] ?? '激活失败',
      remainingSeconds: data['remainingSeconds'] ?? 0,
    );
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_expiresKey);
  }
}

class ActivationResult {
  final bool success;
  final String message;
  final int remainingSeconds;

  ActivationResult({
    required this.success,
    required this.message,
    required this.remainingSeconds,
  });
}
