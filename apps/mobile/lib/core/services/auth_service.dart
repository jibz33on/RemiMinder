import '../models/user.dart';
import 'token_manager.dart';
import 'secure_storage.dart';
import 'firebase_auth_service.dart';

/// Authentication service supporting multiple authentication providers
/// Handles Supabase and Firebase authentication with API integration
class AuthService {
  final FirebaseAuthService _firebaseAuth;
  final TokenManager _tokenManager;

  AuthService({
    FirebaseAuthService? firebaseAuth,
    TokenManager? tokenManager,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuthService(),
        _tokenManager = tokenManager ?? TokenManager(SecureStorage());

  /// Sign up a new user
  Future<User> signUp({
    required String email,
    required String password,
    required UserRole role,
    String? fullName,
  }) async {
    // Only Firebase signup is supported
    return await _firebaseAuth.signUp(
      email: email,
      password: password,
      role: role,
      fullName: fullName,
    );
  }

  /// Sign in with email and password
  Future<User> signIn(String email, String password,
      {UserRole? selectedRole}) async {
    // Only Firebase signin is supported for new flows
    return await _firebaseAuth.signIn(email, password,
        selectedRole: selectedRole);
  }

  /// Sign in with Google OAuth using Firebase
  Future<User> signInWithGoogle() async {
    return await _firebaseAuth.signInWithGoogle();
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _tokenManager.clearTokens();
  }

  /// Get current authenticated user
  /// Get current authenticated user
  Future<User?> getCurrentUser() async {
    return await _firebaseAuth.getCurrentUser();
  }

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated() async {
    return await _firebaseAuth.isAuthenticated();
  }

  /// Reset password for email
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.resetPassword(email);
  }

  /// Update password (requires recent authentication)
  Future<void> updatePassword(String newPassword) async {
    await _firebaseAuth.updatePassword(newPassword);
  }

  /// Get access token for API calls
  Future<String?> getAccessToken() async {
    return await _firebaseAuth.getIdToken();
  }

  /// Get authenticated headers for API calls
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getAccessToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return headers;
  }

  /// Check if authentication services are available
  bool get isAvailable => true; // Firebase auth is always available

  // Private helper methods
}
