import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/screens/welcome_screen.dart';
import '../features/auth/presentation/screens/role_selection_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/forgot_password_confirmation_screen.dart';
import '../features/auth/presentation/screens/verify_email_screen.dart';
import '../features/auth/presentation/screens/context_setup_screen.dart';
import '../features/auth/presentation/screens/onboarding_app_language_screen.dart';
import '../features/auth/presentation/screens/onboarding_country_screen.dart';
import '../features/auth/presentation/screens/onboarding_timezone_screen.dart';
import '../features/auth/presentation/screens/onboarding_visit_language_screen.dart';
import '../features/patient/presentation/screens/patient_home_screen.dart';
import '../features/caregiver/presentation/screens/caregiver_home_screen.dart';
import '../features/caregiver/presentation/screens/patient_list_screen.dart';
import '../features/caregiver/presentation/screens/patient_overview_screen.dart';
import '../features/caregiver/presentation/screens/accept_invitations_screen.dart';
import '../features/caregiver/presentation/screens/caregiver_profile_screen.dart';
import '../features/patient/presentation/screens/visit_recording_screen.dart';
import '../features/patient/presentation/screens/visit_details_screen.dart';
import '../features/patient/presentation/screens/overview_screen.dart';
import '../features/patient/presentation/screens/reminders_screen.dart';
import '../features/patient/presentation/screens/camera_screen.dart';
import '../features/patient/presentation/screens/care_team_screen.dart';
import '../features/patient/presentation/screens/profile_screen.dart';
import '../features/patient/presentation/screens/send_invitations_screen.dart';

import '../features/shared/presentation/screens/loading_screen.dart';
import '../features/patient/presentation/widgets/patient_app_shell.dart';
import '../features/patient/presentation/widgets/rounded_navigation_bar.dart';

// Placeholder screens - we'll implement these one by one
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title Screen\nComing Soon!', textAlign: TextAlign.center),
      ),
    );
  }
}

/// App router configuration using go_router
final appRouterProvider = Provider<GoRouter>((ref) {
  final publicRoutes = <String>{
    '/loading',
    '/welcome',
    '/onboarding/app-language',
    '/onboarding/country',
    '/onboarding/timezone',
    '/login',
    '/register',
    '/forgot-password',
    '/forgot-password/confirmation',
  };
  bool didRerouteForRoleChange = false;
  final router = GoRouter(
    initialLocation: '/loading', // ✅ Changed from '/splash'
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final location = state.uri.path;
      final isPublicRoute = publicRoutes.contains(location);
      if (!authState.isAuthenticated && !isPublicRoute) {
        return '/welcome';
      }

      if (authState.isAuthenticated &&
          isPublicRoute &&
          location != '/loading') {
        return '/loading';
      }

      return null;
    },
    routes: [
      // Loading screen - first screen users see
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingScreen(),
      ),

      // Auth routes
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/onboarding/app-language',
        builder: (context, state) => const OnboardingAppLanguageScreen(),
      ),
      GoRoute(
        path: '/onboarding/country',
        builder: (context, state) => const OnboardingCountryScreen(),
      ),
      GoRoute(
        path: '/onboarding/timezone',
        builder: (context, state) => const OnboardingTimezoneScreen(),
      ),
      GoRoute(
        path: '/onboarding/visit-language',
        builder: (context, state) => const OnboardingVisitLanguageScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/forgot-password/confirmation',
        builder: (context, state) => const ForgotPasswordConfirmationScreen(),
      ),
      GoRoute(
        path: '/context-setup',
        builder: (context, state) => const ContextSetupScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => const VerifyEmailScreen(),
      ),

      // Patient/Caregiver shell route with navigation
      ShellRoute(
        builder: (context, state, child) {
          final location = state.uri.path;
          final currentItem = getCurrentNavigationItem(location);
          final isCaregiver = location.startsWith('/caregiver');
          final caregiverRoutes = isCaregiver
              ? {
                  NavigationItem.home: '/caregiver/home',
                  NavigationItem.visits: '/caregiver/patients',
                  NavigationItem.careTeam: '/caregiver/accept-invitations',
                  NavigationItem.profile: '/caregiver/profile',
                }
              : null;
          return PatientAppShell(
            currentItem: currentItem,
            routes: caregiverRoutes,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/patient/home',
            builder: (context, state) => const PatientHomeScreen(),
          ),
          GoRoute(
            path: '/patient/overview',
            builder: (context, state) => const OverviewScreen(),
          ),
          GoRoute(
            path: '/patient/care-team',
            builder: (context, state) => const CareTeamScreen(),
          ),
          GoRoute(
            path: '/patient/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/caregiver/home',
            builder: (context, state) => const CaregiverHomeScreen(),
          ),
          GoRoute(
            path: '/caregiver/patients',
            builder: (context, state) => const PatientListScreen(),
          ),
          GoRoute(
            path: '/caregiver/patient-overview',
            builder: (context, state) => const PatientOverviewScreen(),
          ),
          GoRoute(
            path: '/caregiver/accept-invitations',
            builder: (context, state) => const AcceptInvitationsScreen(),
          ),
          GoRoute(
            path: '/caregiver/profile',
            builder: (context, state) => const CaregiverProfileScreen(),
          ),
        ],
      ),

      // Patient routes that don't use the navigation shell (modals, full-screen)
      GoRoute(
        path: '/patient/record-visit/:visitId',
        builder: (context, state) {
          final visitId = state.pathParameters['visitId']!;
          return VisitRecordingScreen(visitId: visitId);
        },
      ),
      GoRoute(
        path: '/patient/camera/:visitId',
        builder: (context, state) {
          final visitId = state.pathParameters['visitId']!;
          return CameraScreen(visitId: visitId);
        },
      ),
      GoRoute(
        path: '/patient/scan/:visitId',
        builder: (context, state) {
          final visitId = state.pathParameters['visitId']!;
          return CameraScreen(visitId: visitId);
        },
      ),
      GoRoute(
        path: '/patient/visit-details',
        builder: (context, state) {
          final visitId = state.uri.queryParameters['visitId']!;
          final visitDate = state.uri.queryParameters['visitDate'];
          return VisitDetailsScreen(visitId: visitId, visitDate: visitDate);
        },
      ),
      GoRoute(
        path: '/patient/reminders',
        builder: (context, state) => const RemindersScreen(),
      ),
      GoRoute(
        path: '/patient/invitations',
        builder: (context, state) => const SendInvitationsScreen(),
      ),
    ],
  );
  ref.listen(authNotifierProvider, (previous, next) {
    router.refresh();
    final roleChanged =
        previous?.user?.role != next.user?.role && next.isAuthenticated;
    if (roleChanged && !didRerouteForRoleChange) {
      didRerouteForRoleChange = true;
      router.go('/loading');
      return;
    }
    if (!next.isAuthenticated) {
      didRerouteForRoleChange = false;
    }
  });
  return router;
});
