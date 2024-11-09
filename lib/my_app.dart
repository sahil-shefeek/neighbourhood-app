import 'package:flutter/material.dart';
import 'package:neighbourhood/navigation/app_navigation.dart';
import 'package:neighbourhood/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _authService = AuthService();
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      final jwt = await _storage.read(key: 'jwt');
      if (jwt == null) {
        final refreshSuccess = await _authService.refreshToken();
        if (!refreshSuccess) {
          await _authService.clearTokens();
          AppNavigation.router.go('/login');
        }
      }
    } catch (e) {
      await _authService.clearTokens();
      AppNavigation.router.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Neighbourhood',
      debugShowCheckedModeBanner: false,
      routerConfig: AppNavigation.router,
    );
  }
}
