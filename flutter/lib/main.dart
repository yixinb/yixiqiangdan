import 'package:flutter/material.dart';
import 'package:gamegrab_pro/services/auth_service.dart';
import 'package:gamegrab_pro/pages/activation_page.dart';
import 'package:gamegrab_pro/pages/home_page.dart';

void main() {
  runApp(const GameGrabApp());
}

class GameGrabApp extends StatelessWidget {
  const GameGrabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameGrab Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C5CE7),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isActivated = false;

  @override
  void initState() {
    super.initState();
    _checkActivation();
  }

  Future<void> _checkActivation() async {
    final authService = AuthService();
    final activated = await authService.isActivated();
    setState(() {
      _isActivated = activated;
      _isLoading = false;
    });
  }

  void _onActivated() {
    setState(() {
      _isActivated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_isActivated) {
      return const HomePage();
    }
    return ActivationPage(onActivated: _onActivated);
  }
}
