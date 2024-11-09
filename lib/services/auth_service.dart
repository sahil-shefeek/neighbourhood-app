import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:neighbourhood/constants.dart';

class AuthError implements Exception {
  final String message;
  final int? statusCode;
  AuthError(this.message, [this.statusCode]);
}

class AuthService {
  final storage = const FlutterSecureStorage();

  Future<bool> refreshToken() async {
    try {
      final refreshToken = await storage.read(key: 'refresh_token');
      if (refreshToken == null) throw AuthError('No refresh token found', 401);

      final response = await http.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: {
          'set-cookie': 'refresh=$refreshToken',
        },
      );

      switch (response.statusCode) {
        case 200:
          final jwt = json.decode(response.body)['access'];
          await storage.write(key: 'jwt', value: jwt);
          return true;
        case 401:
          throw AuthError('Session expired. Please login again.', 401);
        case 403:
          throw AuthError('Invalid session. Please login again.', 403);
        default:
          throw AuthError('Failed to refresh session. Please try again.',
              response.statusCode);
      }
    } catch (e) {
      if (e is AuthError) rethrow;
      throw AuthError('Network error. Please check your connection.');
    }
  }

  Future<void> clearTokens() async {
    await storage.delete(key: 'jwt');
    await storage.delete(key: 'refresh_token');
  }
}
