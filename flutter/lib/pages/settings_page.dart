import 'package:flutter/material.dart';
import 'package:gamegrab_pro/services/auth_service.dart';

class SettingsPage extends StatelessWidget {
  final VoidCallback onLogout;

  const SettingsPage({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: const Color(0xFF6C5CE7),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2D3436), Color(0xFF000000)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection('账号信息', [
              _buildItem(
                icon: Icons.credit_card,
                title: '卡密状态',
                trailing: const Text('已激活', style: TextStyle(color: Colors.green)),
              ),
              _buildItem(
                icon: Icons.timer,
                title: '剩余时间',
                trailing: const Text('29天', style: TextStyle(color: Colors.white70)),
              ),
            ]),
            const SizedBox(height: 16),
            _buildSection('权限管理', [
              _buildItem(
                icon: Icons.accessibility_new,
                title: '无障碍服务',
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {},
              ),
              _buildItem(
                icon: Icons.layers,
                title: '悬浮窗权限',
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 16),
            _buildSection('其他', [
              _buildItem(
                icon: Icons.info_outline,
                title: '关于我们',
                trailing: const Text('v1.0.0', style: TextStyle(color: Colors.grey)),
              ),
              _buildItem(
                icon: Icons.logout,
                title: '退出登录',
                titleColor: Colors.redAccent,
                onTap: () async {
                  await AuthService().logout();
                  onLogout();
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6C5CE7)),
      title: Text(title, style: TextStyle(color: titleColor ?? Colors.white)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
