import 'package:google_sign_in/google_sign_in.dart';
import '../config/environment.dart';

/// Service for handling Google Sign In authentication
class GoogleSignInService {
  static GoogleSignIn get _googleSignIn {
    final clientId = Environment.supabaseUrl.isNotEmpty ? null : null; // Will be configured per platform

    return GoogleSignIn(
      scopes: [
        'email',
        'profile',
      ],
      // Note: clientId is typically configured in platform-specific files
      // For iOS: ios/Runner/Info.plist
      // For Android: android/app/build.gradle
    );
  }

  /// Sign in with Google and return authentication credentials
  static Future<GoogleSignInAuthentication?> signInWithGoogle() async {
    try {
      // Sign out first to ensure clean state
      await _googleSignIn.signOut();

      // Start the sign-in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      // Get authentication credentials
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      return googleAuth;
    } catch (error) {
      print('Google Sign In error: $error');
      rethrow;
    }
  }

  /// Sign out from Google
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (error) {
      print('Google Sign Out error: $error');
      rethrow;
    }
  }

  /// Check if user is currently signed in with Google
  static Future<bool> isSignedIn() async {
    try {
      return await _googleSignIn.isSignedIn();
    } catch (error) {
      print('Google Sign In check error: $error');
      return false;
    }
  }

  /// Get current Google user
  static Future<GoogleSignInAccount?> getCurrentUser() async {
    try {
      return _googleSignIn.currentUser;
    } catch (error) {
      print('Get current Google user error: $error');
      return null;
    }
  }
}
