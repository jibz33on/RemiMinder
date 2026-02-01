import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/user.dart';
import '../../features/auth/data/models/auth_state.dart';
import 'preferences_service.dart';

enum AuthDestination {
  welcome,
  verifyEmail,
  visitLanguage,
  home,
}

enum HomeDestination {
  patientHome,
  caregiverHome,
}

class AuthFlowDecision {
  final AuthDestination destination;
  final HomeDestination? homeDestination;

  const AuthFlowDecision({
    required this.destination,
    this.homeDestination,
  });
}

/// Centralized auth/onboarding destination resolver.
/// This keeps navigation decisions out of UI widgets and out of router guards.
class AuthFlowResolver {
  final PreferencesService _preferencesService;

  AuthFlowResolver({PreferencesService? preferencesService})
      : _preferencesService = preferencesService ?? PreferencesService();

  Future<AuthFlowDecision> resolve(AuthState authState) async {
    if (!authState.isAuthenticated || authState.user == null) {
      return const AuthFlowDecision(destination: AuthDestination.welcome);
    }

    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
    final isPasswordProvider = firebaseUser?.providerData
            .any((provider) => provider.providerId == 'password') ??
        false;
    if (firebaseUser != null && isPasswordProvider && !firebaseUser.emailVerified) {
      return const AuthFlowDecision(destination: AuthDestination.verifyEmail);
    }

    final lastActiveContext =
        await _preferencesService.getLastActiveContext();
    final activeContext = lastActiveContext ?? ActiveContext.patient;
    final homeDestination = activeContext == ActiveContext.caregiver
        ? HomeDestination.caregiverHome
        : HomeDestination.patientHome;

    final isOnboardingComplete =
        await _preferencesService.isVisitLanguageOnboardingComplete();
    if (!isOnboardingComplete) {
      return AuthFlowDecision(
        destination: AuthDestination.visitLanguage,
        homeDestination: homeDestination,
      );
    }

    return AuthFlowDecision(
      destination: AuthDestination.home,
      homeDestination: homeDestination,
    );
  }
}
