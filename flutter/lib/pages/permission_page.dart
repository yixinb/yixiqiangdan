import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionPage extends StatefulWidget {
  final VoidCallback onAllGranted;

  const PermissionPage({super.key, required this.onAllGranted});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  static const MethodChannel _channel = MethodChannel('com.yixi.automation');

  bool _accessibilityEnabled = false;
  bool _overlayEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    try {
      final accessibility =
          await _channel.invokeMethod('isAccessibilityEnabled') as bool;
      final overlay = await Permission.systemAlertWindow.isGranted;
      setState(() {
        _accessibilityEnabled = accessibility;
        _overlayEnabled = overlay;
      });
      if (_accessibilityEnabled && _overlayEnabled) {
        widget.onAllGranted();
      }
    } catch (e) {
      // ignore
    }
  }

  Future<void> _openAccessibilitySettings() async {
    try {
      await _channel.invokeMethod('openAccessibilitySettings');
    } catch (e) {
      // ignore
    }
  }

  Future<void> _requestOverlayPermission() async {
    await Permission.systemAlertWindow.request();
    _checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2D3436), Color(0xFF000000)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Text(
                  '权限设置',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '自动抢单需要以下权限才能正常工作',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),
                _buildPermissionCard(
                  icon: Icons.accessibility_new,
                  title: '无障碍服务',
                  description: '用于模拟点击操作',
                  enabled: _accessibilityEnabled,
                  onTap: _openAccessibilitySettings,
                ),
                const SizedBox(height: 16),
                _buildPermissionCard(
                  icon: Icons.layers,
                  title: '悬浮窗权限',
                  description: '用于显示抢单状态悬浮窗',
                  enabled: _overlayEnabled,
                  onTap: _requestOverlayPermission,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _checkPermissions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C5CE7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '刷新权限状态',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required String title,
    required String description,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled ? Colors.green : Colors.orange,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color:
                    (enabled ? Colors.green : Colors.orange).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: enabled ? Colors.green : Colors.orange),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              enabled ? Icons.check_circle : Icons.arrow_forward_ios,
              color: enabled ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
