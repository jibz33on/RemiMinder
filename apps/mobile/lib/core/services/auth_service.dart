import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/environment.dart';
import '../config/supabase_config.dart';
import '../models/user.dart';
import 'token_manager.dart';
import 'secure_storage.dart';
import 'google_signin_service.dart';

/// Authentication service handling Supabase auth and API integration
class AuthService {
  final supabase.SupabaseClient? _supabase;
  final TokenManager _tokenManager;
  final SecureStorage _secureStorage;

  AuthService({
    supabase.SupabaseClient? supabase,
    TokenManager? tokenManager,
    SecureStorage? secureStorage,
  })  : _supabase = supabase ?? SupabaseConfig.client,
        _tokenManager = tokenManager ?? TokenManager(SecureStorage()),
        _secureStorage = secureStorage ?? SecureStorage() {
    // Check if Supabase is available
    if (_supabase == null) {
      print(
          'AuthService: Supabase not initialized - authentication will not work');
    } else {
      // Initialize auth state change listener for debugging
      _initializeAuthStateListener();
    }
  }

  /// Initialize auth state change listener for debugging
  void _initializeAuthStateListener() {
    print('🔐 AuthService: Initializing auth state change listener...');

    // Add auth state change listener for debugging
    _supabase!.auth.onAuthStateChange.listen((event) {
      print(
          '🔐 AuthService: Auth state change - Event: ${event.event}, Session: ${event.session != null ? 'present' : 'null'}');
      print(
          '🔐 AuthService: Current user: ${_supabase!.auth.currentUser?.email ?? 'null'}');
      print(
          '🔐 AuthService: Current session: ${_supabase!.auth.currentSession != null ? 'present' : 'null'}');

      if (event.session != null) {
        print(
            '🔐 AuthService: Session details - User ID: ${event.session!.user.id}');
        print(
            '🔐 AuthService: Session details - Access token: ${event.session!.accessToken.substring(0, 20)}...');
      }
    });

    print('🔐 AuthService: Auth state change listener initialized');
  }

  /// Sign up a new user
  Future<User> signUp({
    required String email,
    required String password,
    required UserRole role,
    String? fullName,
  }) async {
    // Check if Supabase is available
    if (_supabase == null) {
      throw Exception(
          'Authentication not available. Please configure Supabase in your .env file.');
    }

    try {
      // Create account in Supabase Auth
      final response = await _supabase!.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign up failed');
      }

      // Create user profile in our backend
      // Convert role to database-compatible format
      final dbRole = role == UserRole.patient ? 'user' : role.name;

      final userData = {
        'auth_uid': response.user!.id,
        'email': email,
        'role': dbRole,
        'full_name': fullName,
      };

      print('Supabase signup successful, creating backend profile...');
      final apiResponse = await _createUserProfile(userData);

      if (apiResponse.statusCode != 200 && apiResponse.statusCode != 201) {
        print(
            'Backend profile creation failed: ${apiResponse.statusCode} - ${apiResponse.body}');
        throw Exception(
            'Failed to create user profile: ${apiResponse.statusCode}');
      }

      print('Backend profile created successfully');

      final userJson = json.decode(apiResponse.body);
      final user = User.fromJson(userJson);

      // Save tokens if available
      if (response.session != null) {
        await _tokenManager.saveTokens(
          response.session!.accessToken,
          response.session!.refreshToken!,
        );
      }

      return user;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Sign in with email and password
  Future<User> signIn(String email, String password,
      {UserRole? selectedRole}) async {
    print(
        '🔐 AuthService: Starting sign in process for $email, selectedRole: $selectedRole');
    print('🔐 AuthService: selectedRole is null: ${selectedRole == null}');

    // Check if Supabase is available
    if (_supabase == null) {
      print('🔐 AuthService: Supabase not available');
      throw Exception(
          'Authentication not available. Please configure Supabase in your .env file.');
    }

    try {
      print('🔐 AuthService: Calling Supabase signInWithPassword...');
      // Sign in with Supabase
      final response = await _supabase!.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print('🔐 AuthService: Supabase response received');
      if (response.session == null) {
        print('🔐 AuthService: No session in response - sign in failed');
        throw Exception('Sign in failed');
      }

      print(
          '🔐 AuthService: Session details - accessToken exists: ${response.session!.accessToken != null}, refreshToken exists: ${response.session!.refreshToken != null}');

      print('🔐 AuthService: Session found, saving tokens...');

      // Save tokens FIRST
      print(
          '🔐 AuthService: Saving tokens - access token length: ${response.session!.accessToken.length}, refresh token length: ${response.session!.refreshToken!.length}');
      await _tokenManager.saveTokens(
        response.session!.accessToken,
        response.session!.refreshToken!,
      );
      print('🔐 AuthService: Tokens saved successfully');

      // Verify tokens were saved
      final savedToken = await _tokenManager.getAccessToken();
      print(
          '🔐 AuthService: Verification - saved token exists: ${savedToken != null}');

      print('🔐 AuthService: Now fetching backend profile...');

      // Get user profile from backend (now has token)
      final user = await _getUserProfile();
      print(
          '🔐 AuthService: Backend profile fetched: ${user.email}, role: ${user.role}');

      // If a role was selected and it differs from the current role, update it
      print(
          '🔐 AuthService: Checking role update - selectedRole: $selectedRole, user.role: ${user.role}');
      if (selectedRole != null && user.role != selectedRole) {
        print(
            '🔐 AuthService: Selected role ($selectedRole) differs from user role (${user.role}), updating...');
        final updatedUser = await _updateUserRole(user.id, selectedRole);
        print('🔐 AuthService: User role updated to: ${updatedUser.role}');
        return updatedUser;
      } else if (selectedRole != null) {
        print(
            '🔐 AuthService: Selected role ($selectedRole) matches user role (${user.role}), no update needed');
      } else {
        print(
            '🔐 AuthService: No selectedRole provided, using stored role (${user.role})');
      }

      return user;
    } catch (e) {
      print('🔐 AuthService: Sign in failed with error: $e');
      throw _handleAuthError(e);
    }
  }

  /// Sign in with Google OAuth
  Future<User> signInWithGoogle() async {
    print('🔐 AuthService: Starting Google Sign-In process...');

    // Check if Supabase is available
    if (_supabase == null) {
      print('🔐 AuthService: Supabase not available');
      throw Exception(
          'Authentication not available. Please configure Supabase in your .env file.');
    }

    try {
      print('🔐 AuthService: Getting Google authentication credentials...');
      // Get Google authentication credentials
      final googleAuth = await GoogleSignInService.signInWithGoogle();

      if (googleAuth == null) {
        print('🔐 AuthService: Google sign in was cancelled by user');
        throw Exception('Google sign in was cancelled');
      }

      print(
          '🔐 AuthService: Got Google credentials, signing in with Supabase...');

      // Sign in with Supabase using Google OAuth
      final response = await _supabase!.auth.signInWithIdToken(
        provider: supabase.OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      print('🔐 AuthService: Supabase response received');

      if (response.session == null) {
        print('🔐 AuthService: No session in Supabase response');
        throw Exception('Google sign in failed');
      }

      print('🔐 AuthService: Supabase session created successfully');
      print(
          '🔐 AuthService: Session details - User: ${response.session!.user.email}, ID: ${response.session!.user.id}');

      // Get user profile from backend
      print(
          '🔐 AuthService: Google signin successful, fetching backend profile...');
      final user = await _getUserProfile();
      print('🔐 AuthService: Backend profile fetched successfully');

      // Save tokens
      print(
          '🔐 AuthService: Saving tokens - access token length: ${response.session!.accessToken.length}, refresh token length: ${response.session!.refreshToken!.length}');
      await _tokenManager.saveTokens(
        response.session!.accessToken,
        response.session!.refreshToken!,
      );
      print('🔐 AuthService: Tokens saved successfully');

      // Verify tokens were saved
      final savedToken = await _tokenManager.getAccessToken();
      print(
          '🔐 AuthService: Verification - saved token exists: ${savedToken != null}');

      return user;
    } catch (e) {
      // Clean up Google sign in on error
      await GoogleSignInService.signOut();
      throw _handleAuthError(e);
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      if (_supabase != null) {
        await _supabase!.auth.signOut();
      }
      // Also sign out from Google
      await GoogleSignInService.signOut();
      await _tokenManager.clearTokens();
    } catch (e) {
      // Clear local tokens even if API call fails
      await _tokenManager.clearTokens();
      rethrow;
    }
  }

  /// Get current authenticated user
  Future<User?> getCurrentUser() async {
    final isValid = await _tokenManager.isTokenValid();
    if (!isValid) return null;

    try {
      return await _getUserProfile();
    } catch (e) {
      // Token might be expired, clear it
      await _tokenManager.clearTokens();
      return null;
    }
  }

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated() async {
    return await _tokenManager.isTokenValid();
  }

  /// Reset password for email
  Future<void> resetPassword(String email) async {
    if (_supabase == null) {
      throw Exception(
          'Authentication not available. Please configure Supabase in your .env file.');
    }
    await _supabase!.auth.resetPasswordForEmail(email);
  }

  /// Update password (requires current session)
  Future<void> updatePassword(String newPassword) async {
    if (_supabase == null) {
      throw Exception(
          'Authentication not available. Please configure Supabase in your .env file.');
    }
    await _supabase!.auth
        .updateUser(supabase.UserAttributes(password: newPassword));
  }

  /// Get access token for API calls
  Future<String?> getAccessToken() async {
    final token = await _tokenManager.getAccessToken();
    print(
        '🔐 AuthService: getAccessToken returned: ${token != null ? "token exists" : "null"}');
    return token;
  }

  /// Refresh token if needed
  Future<String?> refreshToken() async {
    if (_supabase == null) return null;

    try {
      final response = await _supabase!.auth.refreshSession();
      if (response.session == null) return null;

      await _tokenManager.saveTokens(
        response.session!.accessToken,
        response.session!.refreshToken!,
      );

      return response.session!.accessToken;
    } catch (e) {
      await _tokenManager.clearTokens();
      return null;
    }
  }

  /// Get authenticated headers for API calls
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getAccessToken();
    print('🔐 AuthService: getAuthHeaders - token exists: ${token != null}');
    if (token != null) {
      print('🔐 AuthService: Token length: ${token.length}');
    } else {
      print('🔐 AuthService: No token available!');
    }

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    print('🔐 AuthService: Headers: $headers');
    return headers;
  }

  /// Check if authentication services are available
  bool get isAvailable => _supabase != null;

  // Private helper methods

  Future<http.Response> _createUserProfile(
      Map<String, dynamic> userData) async {
    final url = Uri.parse('${Environment.apiBaseUrl}/api/users/');
    print('Creating user profile at: $url');
    print('Request data: $userData');

    final client = http.Client();
    try {
      final response = await client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(userData),
          )
          .timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response;
    } finally {
      client.close();
    }
  }

  Future<User> _getUserProfile() async {
    final headers = await getAuthHeaders();
    final url = Uri.parse('${Environment.apiBaseUrl}/api/users/profile');

    final response = await http.get(url, headers: headers);

    if (response.statusCode != 200) {
      switch (response.statusCode) {
        case 401:
          throw Exception(
              'Invalid email or password. Please check your credentials.');
        case 404:
          throw Exception(
              'Account not found. Please check your email or register first.');
        case 500:
          throw Exception('Server error. Please try again later.');
        default:
          throw Exception('Authentication failed. Please try again.');
      }
    }

    final userJson = json.decode(response.body);
    return User.fromJson(userJson);
  }

  Future<User> _updateUserRole(String userId, UserRole newRole) async {
    print('🔐 AuthService: Updating user role for $userId to $newRole');
    final headers = await getAuthHeaders();
    final url = Uri.parse('${Environment.apiBaseUrl}/api/users/$userId/role');
    print('🔐 AuthService: Role update URL: $url');

    final response = await http.put(
      url,
      headers: {
        ...headers,
        'Content-Type': 'application/json',
      },
      body: json.encode({'role': newRole.name}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user role');
    }

    final userJson = json.decode(response.body);
    return User.fromJson(userJson);
  }

  Exception _handleAuthError(dynamic error) {
    if (error is supabase.AuthException) {
      switch (error.message) {
        case 'Invalid login credentials':
          return Exception('Invalid email or password');
        case 'User already registered':
          return Exception('An account with this email already exists');
        case 'Email not confirmed':
          return Exception('Please check your email and confirm your account');
        default:
          return Exception(error.message);
      }
    }
    return Exception('Authentication failed: ${error.toString()}');
  }
}
