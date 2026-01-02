import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GrabService {
  static const String _configsKey = 'grab_configs';
  static const MethodChannel _channel = MethodChannel('com.gamegrab.automation');

  Future<List<GrabConfig>> loadConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_configsKey);
    if (jsonStr == null) return [];
    final list = jsonDecode(jsonStr) as List;
    return list.map((e) => GrabConfig.fromJson(e)).toList();
  }

  Future<void> saveConfig(GrabConfig config) async {
    final configs = await loadConfigs();
    configs.add(config);
    await _saveConfigs(configs);
  }

  Future<void> deleteConfig(String id) async {
    final configs = await loadConfigs();
    configs.removeWhere((c) => c.id == id);
    await _saveConfigs(configs);
  }

  Future<void> _saveConfigs(List<GrabConfig> configs) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(configs.map((e) => e.toJson()).toList());
    await prefs.setString(_configsKey, jsonStr);
  }

  Future<void> performClick(GrabConfig config) async {
    for (final point in config.clickPoints) {
      try {
        await _channel.invokeMethod('performClick', {
          'x': point.x,
          'y': point.y,
        });
      } catch (e) {
        // 如果原生方法不可用，忽略错误
      }
    }
  }

  Future<void> startForegroundService() async {
    try {
      await _channel.invokeMethod('startForegroundService');
    } catch (e) {
      // ignore
    }
  }

  Future<void> stopForegroundService() async {
    try {
      await _channel.invokeMethod('stopForegroundService');
    } catch (e) {
      // ignore
    }
  }
}

class GrabConfig {
  final String id;
  final String name;
  final int intervalMs;
  final List<ClickPoint> clickPoints;

  GrabConfig({
    required this.id,
    required this.name,
    required this.intervalMs,
    required this.clickPoints,
  });

  factory GrabConfig.fromJson(Map<String, dynamic> json) {
    return GrabConfig(
      id: json['id'],
      name: json['name'],
      intervalMs: json['intervalMs'],
      clickPoints: (json['clickPoints'] as List)
          .map((e) => ClickPoint.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'intervalMs': intervalMs,
        'clickPoints': clickPoints.map((e) => e.toJson()).toList(),
      };
}

class ClickPoint {
  final double x;
  final double y;

  ClickPoint({required this.x, required this.y});

  factory ClickPoint.fromJson(Map<String, dynamic> json) {
    return ClickPoint(
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {'x': x, 'y': y};
}
