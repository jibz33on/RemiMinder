import 'package:google_sign_in/google_sign_in.dart';
import '../config/environment.dart';

/// Service for handling Google Sign In authentication
class GoogleSignInService {
  static GoogleSignIn get _googleSignIn {
    final clientId = Environment.supabaseUrl.isNotEmpty
        ? null
        : null; // Will be configured per platform

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
      print('🔐 GoogleSignInService: Starting Google Sign-In process...');

      // Sign out first to ensure clean state
      print('🔐 GoogleSignInService: Signing out previous sessions...');
      await _googleSignIn.signOut();

      // Start the sign-in process
      print('🔐 GoogleSignInService: Showing Google Sign-In prompt...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        print('🔐 GoogleSignInService: User cancelled Google Sign-In');
        return null;
      }

      print(
          '🔐 GoogleSignInService: Google user selected: ${googleUser.email}');

      // Get authentication credentials
      print('🔐 GoogleSignInService: Getting authentication credentials...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print(
          '🔐 GoogleSignInService: Got credentials - idToken: ${googleAuth.idToken != null ? "present" : "null"}, accessToken: ${googleAuth.accessToken != null ? "present" : "null"}');

      return googleAuth;
    } catch (error) {
      print('🔐 GoogleSignInService: Google Sign In error: $error');
      print('🔐 GoogleSignInService: Error type: ${error.runtimeType}');
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
