import 'package:flutter/material.dart';
import 'package:gamegrab_pro/pages/grab_config_page.dart';
import 'package:gamegrab_pro/services/grab_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GrabService _grabService = GrabService();
  List<GrabConfig> _configs = [];
  bool _isGrabbing = false;
  int _clickCount = 0;

  @override
  void initState() {
    super.initState();
    _loadConfigs();
  }

  Future<void> _loadConfigs() async {
    final configs = await _grabService.loadConfigs();
    setState(() => _configs = configs);
  }

  void _addConfig() async {
    final result = await Navigator.push<GrabConfig>(
      context,
      MaterialPageRoute(builder: (_) => const GrabConfigPage()),
    );
    if (result != null) {
      await _grabService.saveConfig(result);
      _loadConfigs();
    }
  }

  void _toggleGrab(GrabConfig config) {
    setState(() {
      _isGrabbing = !_isGrabbing;
      if (_isGrabbing) {
        _clickCount = 0;
        _grabService.startForegroundService();
        _startGrab(config);
      } else {
        _grabService.stopForegroundService();
      }
    });
  }

  void _startGrab(GrabConfig config) async {
    while (_isGrabbing) {
      await _grabService.performClick(config);
      setState(() => _clickCount++);
      await Future.delayed(Duration(milliseconds: config.intervalMs));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GameGrab Pro'),
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
        child: _configs.isEmpty ? _buildEmpty() : _buildList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addConfig,
        backgroundColor: const Color(0xFF6C5CE7),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.touch_app, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('暂无抢单配置', style: TextStyle(color: Colors.grey, fontSize: 16)),
          SizedBox(height: 8),
          Text('点击右下角 + 创建配置', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _configs.length,
      itemBuilder: (context, index) {
        final config = _configs[index];
        return Card(
          color: Colors.white.withOpacity(0.1),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const Icon(Icons.gamepad, color: Color(0xFF6C5CE7)),
            title: Text(config.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(
              '点击间隔: ${config.intervalMs}ms | 已点击: $_clickCount',
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: ElevatedButton(
              onPressed: () => _toggleGrab(config),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isGrabbing ? Colors.redAccent : Colors.green,
              ),
              child: Text(_isGrabbing ? '停止' : '开始'),
            ),
          ),
        );
      },
    );
  }
}
