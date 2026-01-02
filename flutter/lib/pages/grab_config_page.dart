import 'package:flutter/material.dart';
import 'package:gamegrab_pro/services/grab_service.dart';

class GrabConfigPage extends StatefulWidget {
  const GrabConfigPage({super.key});

  @override
  State<GrabConfigPage> createState() => _GrabConfigPageState();
}

class _GrabConfigPageState extends State<GrabConfigPage> {
  final _nameController = TextEditingController();
  int _intervalMs = 200;
  List<ClickPoint> _clickPoints = [];
  bool _isRecording = false;

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _clickPoints = [];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('请点击屏幕录制抢单位置，完成后点击"结束录制"')),
    );
  }

  void _stopRecording() {
    setState(() => _isRecording = false);
    if (_clickPoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('未录制到任何点击位置')),
      );
    }
  }

  void _onTapDown(TapDownDetails details) {
    if (!_isRecording) return;
    setState(() {
      _clickPoints.add(ClickPoint(
        x: details.globalPosition.dx,
        y: details.globalPosition.dy,
      ));
    });
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入配置名称')),
      );
      return;
    }
    if (_clickPoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先录制点击位置')),
      );
      return;
    }
    final config = GrabConfig(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      intervalMs: _intervalMs,
      clickPoints: _clickPoints,
    );
    Navigator.pop(context, config);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('新建抢单配置'),
          backgroundColor: const Color(0xFF6C5CE7),
          actions: [
            TextButton(
              onPressed: _save,
              child: const Text('保存', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2D3436), Color(0xFF000000)],
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: '配置名称',
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('点击间隔 (ms)', style: TextStyle(color: Colors.grey)),
                    Slider(
                      value: _intervalMs.toDouble(),
                      min: 50,
                      max: 1000,
                      divisions: 19,
                      label: '${_intervalMs}ms',
                      activeColor: const Color(0xFF6C5CE7),
                      onChanged: (v) => setState(() => _intervalMs = v.toInt()),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isRecording ? null : _startRecording,
                            icon: const Icon(Icons.fiber_manual_record),
                            label: const Text('开始录制'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isRecording ? _stopRecording : null,
                            icon: const Icon(Icons.stop),
                            label: const Text('结束录制'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '已录制 ${_clickPoints.length} 个点击位置',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _clickPoints.length,
                        itemBuilder: (context, index) {
                          final point = _clickPoints[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF6C5CE7),
                              child: Text('${index + 1}'),
                            ),
                            title: Text(
                              '位置: (${point.x.toInt()}, ${point.y.toInt()})',
                              style: const TextStyle(color: Colors.white),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                setState(() => _clickPoints.removeAt(index));
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              ..._clickPoints.asMap().entries.map((entry) {
                return Positioned(
                  left: entry.value.x - 15,
                  top: entry.value.y - 15 - MediaQuery.of(context).padding.top - kToolbarHeight,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C5CE7).withOpacity(0.7),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
