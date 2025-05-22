import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final ApiService _apiService;
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';

  AuthRepository({required ApiService apiService}) : _apiService = apiService;

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _saveTokens(data['accessToken'], data['refreshToken']);
        await _saveUserData(data);
        return data;
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }

  Future<void> refreshToken() async {
    try {
      final refreshToken = await _getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await _apiService.post(
        '/auth/refresh',
        data: {
          'refreshToken': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await _saveTokens(data['token'], data['refreshToken']);
      } else {
        throw Exception(response.data['message'] ?? 'Token refresh failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Token refresh failed');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No token available');
      }

      final response = await _apiService.get(
        '/auth/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get user data');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to get user data');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userDataKey);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  Future<void> _saveTokens(String token, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, userData.toString());
  }

  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null;
  }
} 