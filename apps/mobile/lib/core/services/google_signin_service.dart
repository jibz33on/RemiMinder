import 'dart:io' show Platform;
import 'package:google_sign_in/google_sign_in.dart';

/// Service for handling Google Sign In authentication
class GoogleSignInService {
  // Google Cloud Project: 575820802106
  // All OAuth clients are from the SAME project for proper authentication

  // iOS OAuth Client (for native iOS sign-in)
  static const String _iosClientId =
      '575820802106-p4hqriibug69du59bh2i42e7g91i8fhd.apps.googleusercontent.com';

  // Android OAuth Client (for native Android sign-in)
  static const String _androidClientId =
      '575820802106-576cjelarpplv12in62su54frlt7lkop.apps.googleusercontent.com';

  // Web OAuth Client (for Supabase server-side authentication)
  static const String _webClientId =
      '575820802106-akqd9u3ksb51fqi7ibojbgkgsjjobm7g.apps.googleusercontent.com';

  static GoogleSignIn get _googleSignIn {
    // Use platform-specific client ID for native sign-in
    final String clientId = Platform.isIOS
        ? _iosClientId
        : (Platform.isAndroid ? _androidClientId : _webClientId);

    return GoogleSignIn(
      // Platform-specific client for native OAuth
      clientId: clientId,
      // Web client for Supabase backend authentication
      serverClientId: _webClientId,
      scopes: [
        'email',
        'profile',
      ],
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
