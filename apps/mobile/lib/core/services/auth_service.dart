import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../config/environment.dart';
import '../config/supabase_config.dart';
import '../models/user.dart';
import 'token_manager.dart';
import 'secure_storage.dart';
import 'firebase_auth_service.dart';

/// Authentication service supporting multiple authentication providers
/// Handles Supabase and Firebase authentication with API integration
class AuthService {
  final supabase.SupabaseClient? _supabase;
  final FirebaseAuthService _firebaseAuth;
  final TokenManager _tokenManager;
  final SecureStorage _secureStorage;

  AuthService({
    supabase.SupabaseClient? supabase,
    FirebaseAuthService? firebaseAuth,
    TokenManager? tokenManager,
    SecureStorage? secureStorage,
  })  : _supabase = supabase ?? SupabaseConfig.client,
        _firebaseAuth = firebaseAuth ?? FirebaseAuthService(),
        _tokenManager = tokenManager ?? TokenManager(SecureStorage()),
        _secureStorage = secureStorage ?? SecureStorage() {
    // Initialize auth state change listener if Supabase is available
    if (_supabase != null) {
      _initializeAuthStateListener();
    }
  }

  /// Get the current auth provider (supabase or firebase)
  String get _authProvider => Environment.authProvider;

  /// Check if using Supabase auth
  bool get _isSupabaseAuth => _authProvider == 'supabase';

  /// Check if using Firebase auth
  bool get _isFirebaseAuth => _authProvider == 'firebase';

  /// Initialize auth state change listener
  void _initializeAuthStateListener() {
    // Listen for auth state changes to maintain session consistency
    _supabase!.auth.onAuthStateChange.listen((event) {
      // Auth state changes are handled automatically by Supabase
    });
  }

  /// Sign up a new user
  Future<User> signUp({
    required String email,
    required String password,
    required UserRole role,
    String? fullName,
  }) async {
    if (_isFirebaseAuth) {
      return await _firebaseAuth.signUp(
        email: email,
        password: password,
        role: role,
        fullName: fullName,
      );
    } else {
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

        final apiResponse = await _createUserProfile(userData);

        if (apiResponse.statusCode != 200 && apiResponse.statusCode != 201) {
          throw Exception(
              'Failed to create user profile: ${apiResponse.statusCode}');
        }

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
  }

  /// Sign in with email and password
  Future<User> signIn(String email, String password,
      {UserRole? selectedRole}) async {
    if (_isFirebaseAuth) {
      return await _firebaseAuth.signIn(email, password,
          selectedRole: selectedRole);
    } else {
      // Check if Supabase is available
      if (_supabase == null) {
        throw Exception(
            'Authentication not available. Please configure Supabase in your .env file.');
      }

      try {
        // Sign in with Supabase
        final response = await _supabase!.auth.signInWithPassword(
          email: email,
          password: password,
        );

        if (response.session == null) {
          throw Exception('Sign in failed');
        }

        // Save tokens
        await _tokenManager.saveTokens(
          response.session!.accessToken,
          response.session!.refreshToken!,
        );

        // Get user profile from backend
        final user = await _getUserProfile();

        // If a role was selected and it differs from the current role, update it
        if (selectedRole != null && user.role != selectedRole) {
          final updatedUser = await _updateUserRole(user.id, selectedRole);
          return updatedUser;
        } else {
          // Use stored role
        }

        return user;
      } catch (e) {
        throw _handleAuthError(e);
      }
    }
  }

  // Google Sign-In disabled for Phase 4.x to avoid dependency conflicts
  /*
  Future<User> signInWithGoogle() async {
    print('🔐 AuthService: Starting NATIVE Google Sign-In...');

    // Check if Supabase is available
    if (_supabase == null) {
      print('🔐 AuthService: Supabase not available');
      throw Exception(
          'Authentication not available. Please configure Supabase in your .env file.');
    }

    try {
      print('🔐 AuthService: Opening native Google account picker...');

      // Clear any cached account to ensure account picker appears
      await _googleSignIn.signOut();

      // Step 1: Sign in with Google natively
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print('🔐 AuthService: Google sign-in cancelled by user');
        throw Exception('Google sign-in cancelled');
      }

      print('🔐 AuthService: Google account selected: ${googleUser.email}');

      // Step 2: Get authentication tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.idToken == null || googleAuth.accessToken == null) {
        print('🔐 AuthService: Missing required Google tokens');
        throw Exception('Missing Google authentication tokens');
      }

      print('🔐 AuthService: Google tokens obtained');
      print('🔐 AuthService: Signing in to Supabase...');

      // Step 3: Sign in to Supabase with idToken + accessToken (NO nonce)
      final response = await _supabase!.auth.signInWithIdToken(
        provider: supabase.OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );

      if (response.session == null) {
        print('🔐 AuthService: No session created');
        throw Exception('Failed to create Supabase session');
      }

      final session = response.session!;
      print('🔐 AuthService: Supabase session created successfully!');
      print(
          '🔐 AuthService: User: ${session.user.email}, ID: ${session.user.id}');

      // Save tokens
      print('🔐 AuthService: Saving tokens...');
      await _tokenManager.saveTokens(
        session.accessToken,
        session.refreshToken!,
      );
      print('🔐 AuthService: Tokens saved successfully');

      // Try to get user profile from backend, create if doesn't exist
      print('🔐 AuthService: Fetching backend profile...');
      User user;
      try {
        user = await _getUserProfile();
        print('🔐 AuthService: Backend profile fetched successfully');
      } catch (e) {
        print(
            '🔐 AuthService: User profile not found, creating new profile...');
        // User doesn't exist in backend, create profile
        final userData = {
          'auth_uid': session.user.id,
          'email': session.user.email,
          'role': 'user', // Default role for Google sign-in
          'full_name': session.user.userMetadata?['full_name'] ??
              session.user.userMetadata?['name'] ??
              googleUser.displayName,
        };

        final apiResponse = await _createUserProfile(userData);

        if (apiResponse.statusCode != 200 && apiResponse.statusCode != 201) {
          print(
              '🔐 AuthService: Backend profile creation failed: ${apiResponse.statusCode} - ${apiResponse.body}');
          throw Exception(
              'Failed to create user profile: ${apiResponse.statusCode}');
        }

        print('🔐 AuthService: Backend profile created successfully');
        final userJson = json.decode(apiResponse.body);
        user = User.fromJson(userJson);
      }

      print('🔐 AuthService: Google Sign-In completed successfully!');
      return user;
    } catch (e) {
      print('🔐 AuthService: Error during Google sign-in: $e');
      throw _handleAuthError(e);
    }
  }
  */

  /// Sign out current user
  Future<void> signOut() async {
    try {
      if (_isFirebaseAuth) {
        await _firebaseAuth.signOut();
      } else {
        if (_supabase != null) {
          await _supabase!.auth.signOut();
        }
      }

      await _tokenManager.clearTokens();
    } catch (e) {
      // Clear local tokens even if API call fails
      await _tokenManager.clearTokens();
      rethrow;
    }
  }

  /// Get current authenticated user
  Future<User?> getCurrentUser() async {
    if (_isFirebaseAuth) {
      return await _firebaseAuth.getCurrentUser();
    } else {
      // Supabase auth - check token and fetch from backend
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
  }

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated() async {
    if (_isFirebaseAuth) {
      return await _firebaseAuth.isAuthenticated();
    } else {
      return await _tokenManager.isTokenValid();
    }
  }

  /// Reset password for email
  Future<void> resetPassword(String email) async {
    if (_isFirebaseAuth) {
      await _firebaseAuth.resetPassword(email);
    } else {
      if (_supabase == null) {
        throw Exception(
            'Authentication not available. Please configure Supabase in your .env file.');
      }
      await _supabase!.auth.resetPasswordForEmail(email);
    }
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
    if (_isFirebaseAuth) {
      // Phase 4.3: Firebase tokens now sent to backend
      final token = await _firebaseAuth.getIdToken();
      print(
          '🔐 AuthService: Firebase getAccessToken returned: ${token != null ? "token exists (length: ${token!.length})" : "null"}');
      return token;
    } else {
      final token = await _tokenManager.getAccessToken();
      print(
          '🔐 AuthService: Supabase getAccessToken returned: ${token != null ? "token exists" : "null"}');
      return token;
    }
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
    print(
        '🔐 AuthService: getAuthHeaders - token exists: ${token != null} (provider: $_authProvider)');

    if (token != null) {
      print(
          '🔐 AuthService: Token length: ${token.length} (source: ${_isFirebaseAuth ? "firebase" : "supabase"})');
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
