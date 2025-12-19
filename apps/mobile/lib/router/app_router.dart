import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/welcome_screen.dart';
import '../features/auth/presentation/screens/role_selection_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/patient/presentation/screens/patient_home_screen.dart';
import '../features/caregiver/presentation/screens/caregiver_home_screen.dart';
import '../features/caregiver/presentation/screens/patient_list_screen.dart';
import '../features/caregiver/presentation/screens/patient_overview_screen.dart';
import '../features/caregiver/presentation/screens/alert_list_screen.dart';
import '../features/caregiver/presentation/screens/accept_invitations_screen.dart';
import '../features/patient/presentation/screens/visit_recording_screen.dart';
import '../features/patient/presentation/screens/visit_details_screen.dart';
import '../features/patient/presentation/screens/reminders_screen.dart';
import '../features/patient/presentation/screens/scan_screen.dart';
import '../features/patient/presentation/screens/capture_screen.dart';
import '../features/patient/presentation/screens/history_list_screen.dart';
import '../features/patient/presentation/screens/care_team_screen.dart';
import '../features/patient/presentation/screens/profile_screen.dart';
import '../features/patient/presentation/screens/send_invitations_screen.dart';

import '../features/shared/presentation/screens/loading_screen.dart';

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
  return GoRouter(
    initialLocation: '/loading', // ✅ Changed from '/splash'
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

      // Patient routes
      GoRoute(
        path: '/patient/home',
        builder: (context, state) => const PatientHomeScreen(),
      ),
      GoRoute(
        path: '/patient/record-visit',
        builder: (context, state) => const VisitRecordingScreen(),
      ),
      GoRoute(
        path: '/patient/capture',
        builder: (context, state) => const CaptureScreen(),
      ),
      GoRoute(
        path: '/patient/history-list',
        builder: (context, state) => const HistoryListScreen(),
      ),
      GoRoute(
        path: '/patient/visit-details',
        builder: (context, state) => const VisitDetailsScreen(),
      ),
      GoRoute(
        path: '/patient/reminders',
        builder: (context, state) => const RemindersScreen(),
      ),
      GoRoute(
        path: '/patient/scan',
        builder: (context, state) => const ScanScreen(),
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
        path: '/patient/invitations',
        builder: (context, state) => const SendInvitationsScreen(),
      ),

      // Caregiver routes
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
        path: '/caregiver/alerts',
        builder: (context, state) => const AlertListScreen(),
      ),
      GoRoute(
        path: '/caregiver/accept-invitations',
        builder: (context, state) => const AcceptInvitationsScreen(),
      ),
    ],
  );
});
