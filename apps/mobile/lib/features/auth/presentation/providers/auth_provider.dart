import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/auth_state.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../core/models/user.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/token_manager.dart';
import '../../../../core/services/secure_storage.dart';

// =============================================================================
// PROVIDERS
// =============================================================================

// Service providers
final _secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

final _tokenManagerProvider = Provider<TokenManager>((ref) {
  final storage = ref.watch(_secureStorageProvider);
  return TokenManager(storage);
});

final _authServiceProvider = Provider<AuthService>((ref) {
  final tokenManager = ref.watch(_tokenManagerProvider);
  return AuthService(tokenManager: tokenManager);
});

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authService = ref.watch(_authServiceProvider);
  return AuthRepository(authService);
});

// =============================================================================
// STATE NOTIFIER PROVIDER
// =============================================================================

/// Authentication state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthState.initial()) {
    _checkAuthStatus();
  }

  /// Check authentication status on app start
  Future<void> _checkAuthStatus() async {
    state = AuthState.loading();

    try {
      // Check if authentication services are available
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      // If auth services are not available (e.g., Supabase not configured),
      // treat as unauthenticated rather than error
      if (e.toString().contains('Supabase') ||
          e.toString().contains('not available')) {
        print(
            'AuthNotifier: Authentication not configured - treating as unauthenticated');
        state = AuthState.unauthenticated();
      } else {
        state = AuthState.error(e.toString());
      }
    }
  }

  /// Sign up a new user
  Future<void> signUp({
    required String email,
    required String password,
    required UserRole role,
    String? fullName,
  }) async {
    state = AuthState.loading();

    try {
      final user = await _authRepository.signUp(
        email: email,
        password: password,
        role: role,
        fullName: fullName,
      );
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    print('🔐 AuthProvider: Starting sign in for email: $email');
    state = AuthState.loading();

    try {
      print('🔐 AuthProvider: Calling auth repository signIn...');
      final user = await _authRepository.signIn(email, password);
      print(
          '🔐 AuthProvider: Sign in successful, user: ${user.email}, role: ${user.role}');
      state = AuthState.authenticated(user);
      print('🔐 AuthProvider: Auth state set to authenticated');
    } catch (e) {
      print('🔐 AuthProvider: Sign in failed with error: $e');
      state = AuthState.error(e.toString());
      print('🔐 AuthProvider: Auth state set to error');
    }
  }

  /// Sign in with Google OAuth
  Future<void> signInWithGoogle() async {
    state = AuthState.loading();

    try {
      final user = await _authRepository.signInWithGoogle();
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    state = AuthState.loading();

    try {
      await _authRepository.signOut();
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Reset password for email
  Future<void> resetPassword(String email) async {
    state = AuthState.loading();

    try {
      await _authRepository.resetPassword(email);
      state = AuthState.unauthenticated(); // Go back to login
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Update user password
  Future<void> updatePassword(String newPassword) async {
    if (!state.isAuthenticated) return;

    state = AuthState.loading();

    try {
      await _authRepository.updatePassword(newPassword);
      // Stay authenticated with same user
      state = AuthState.authenticated(state.user!);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Clear any error messages
  void clearError() {
    if (state.hasError) {
      state = state.copyWith(errorMessage: null);
    }
  }

  /// Retry authentication check
  Future<void> retryAuthCheck() async {
    await _checkAuthStatus();
  }
}

// =============================================================================
// MAIN AUTH PROVIDER
// =============================================================================

/// Main authentication provider
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

// =============================================================================
// CONVENIENCE PROVIDERS
// =============================================================================

/// Current authenticated user (null if not authenticated)
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.user;
});

/// Authentication status
final authStatusProvider = Provider<AuthStatus>((ref) {
  return ref.watch(authNotifierProvider).status;
});

/// Whether user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isAuthenticated;
});

/// Whether authentication operation is loading
final isAuthLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isLoading;
});

/// Current authentication error message
final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.errorMessage;
});

/// Whether user is a patient
final isPatientProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isPatient ?? false;
});

/// Whether user is a caregiver
final isCaregiverProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.isCaregiver ?? false;
});

// =============================================================================
// ROLE SELECTION PROVIDER
// =============================================================================

/// Selected user role during onboarding
final selectedRoleProvider =
    StateNotifierProvider<SelectedRoleNotifier, UserRole?>((ref) {
  return SelectedRoleNotifier();
});

class SelectedRoleNotifier extends StateNotifier<UserRole?> {
  SelectedRoleNotifier() : super(null);

  void selectRole(UserRole role) {
    state = role;
  }

  void clearRole() {
    state = null;
  }
}
