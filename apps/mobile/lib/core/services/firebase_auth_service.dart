import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../config/environment.dart';
import '../models/user.dart';
import 'token_manager.dart';
import 'secure_storage.dart';

/// Firebase Authentication service for Email/Password authentication
/// Supports Firebase Auth as one of multiple authentication providers
class FirebaseAuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final TokenManager _tokenManager;
  final SecureStorage _secureStorage;

  FirebaseAuthService({
    firebase_auth.FirebaseAuth? firebaseAuth,
    TokenManager? tokenManager,
    SecureStorage? secureStorage,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _tokenManager = tokenManager ?? TokenManager(SecureStorage()),
        _secureStorage = secureStorage ?? SecureStorage();

  /// Sign up a new user with Firebase Email/Password
  Future<User> signUp({
    required String email,
    required String password,
    required UserRole role,
    String? fullName,
  }) async {
    try {
      // Create Firebase account
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Firebase sign up failed - no user returned');
      }

      // Get Firebase ID token
      final idToken = await userCredential.user!.getIdToken();
      if (idToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }

      // Store Firebase token securely
      await _tokenManager.saveTokens(
          idToken, ''); // Firebase doesn't provide refresh tokens
      await _secureStorage.write('firebase_uid', userCredential.user!.uid);
      await _secureStorage.write('auth_provider', 'firebase');

      // Create User object
      final user = User(
        id: userCredential.user!.uid, // Firebase UID
        email: email,
        role: role,
        fullName: fullName,
        authUid: userCredential.user!.uid,
      );

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw Exception('Firebase sign up failed: $e');
    }
  }

  /// Sign in with Firebase Email/Password
  Future<User> signIn(String email, String password,
      {UserRole? selectedRole}) async {
    try {
      // Sign in with Firebase
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Firebase sign in failed - no user returned');
      }

      // Get Firebase ID token
      final idToken = await userCredential.user!.getIdToken();
      if (idToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }

      // Store Firebase token securely
      await _tokenManager.saveTokens(
          idToken, ''); // Firebase doesn't provide refresh tokens
      await _secureStorage.write('firebase_uid', userCredential.user!.uid);
      await _secureStorage.write('auth_provider', 'firebase');

      // Create User object
      final user = User(
        id: userCredential.user!.uid, // Firebase UID
        email: email,
        role: selectedRole ?? UserRole.patient, // Default role
        fullName: userCredential.user!.displayName,
        authUid: userCredential.user!.uid,
      );

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw Exception('Firebase sign in failed: $e');
    }
  }

  /// Sign out from Firebase
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _tokenManager.clearTokens();
      await _secureStorage.delete('firebase_uid');
      await _secureStorage.delete('auth_provider');
    } catch (e) {
      // Clear local tokens even if Firebase sign out fails
      await _tokenManager.clearTokens();
      await _secureStorage.delete('firebase_uid');
      await _secureStorage.delete('auth_provider');
      rethrow;
    }
  }

  /// Get current Firebase user
  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        return null;
      }

      // Check if we have stored tokens
      final hasToken = await _tokenManager.isTokenValid();
      if (!hasToken) {
        return null;
      }

      return User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        role: UserRole.patient, // Default role
        fullName: firebaseUser.displayName,
        authUid: firebaseUser.uid,
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if user is authenticated with Firebase
  Future<bool> isAuthenticated() async {
    try {
      final user = await getCurrentUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }

  /// Get Firebase ID token
  Future<String?> getIdToken() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      final token = await firebaseUser.getIdToken();
      return token;
    } catch (e) {
      return null;
    }
  }

  /// Reset password via Firebase
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Exception _handleFirebaseAuthError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return Exception('An account with this email already exists');
      case 'weak-password':
        return Exception('Password is too weak');
      case 'invalid-email':
        return Exception('Invalid email address');
      case 'user-not-found':
        return Exception('No account found with this email');
      case 'wrong-password':
        return Exception('Incorrect password');
      case 'user-disabled':
        return Exception('This account has been disabled');
      case 'too-many-requests':
        return Exception('Too many failed attempts. Please try again later');
      default:
        return Exception('Authentication failed: ${e.message}');
    }
  }
}
