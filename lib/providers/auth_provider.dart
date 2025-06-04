import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/report_model.dart';
import '../services/api_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;
  late ApiService _apiService;

  AuthNotifier(this._ref) : super(const AsyncValue.data(null)) {
    _apiService = ApiService();
  }

  Future<bool> login(String username, String password) async {
    state = const AsyncValue.loading();
    
    try {
      final response = await _apiService.login(username, password);
      
      if (response['success'] == true) {
        final user = User.fromJson(response['user']);
        final token = response['token'];
        
        // Save credentials for auto-login
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('username', username);
        
        state = AsyncValue.data(user.copyWith(token: token));
        return true;
      } else {
        state = AsyncValue.error(response['error'] ?? 'Login failed', StackTrace.current);
        return false;
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return false;
    }
  }

  Future<void> autoLogin(String username, String token) async {
    state = const AsyncValue.loading();
    
    try {
      // For now, we'll create a basic user object
      // In a full implementation, you'd validate the token with the server
      final user = User(
        username: username,
        role: 'technician',
        firstName: '',
        lastName: '',
        email: '',
        token: token,
      );
      
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('username');
    
    state = const AsyncValue.data(null);
  }
}

extension UserCopyWith on User {
  User copyWith({
    String? username,
    String? role,
    String? firstName,
    String? lastName,
    String? email,
    String? token,
  }) {
    return User(
      username: username ?? this.username,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }
} 