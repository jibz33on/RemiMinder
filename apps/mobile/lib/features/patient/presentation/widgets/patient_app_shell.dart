import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/data/models/auth_state.dart';
import 'rounded_navigation_bar.dart';

/// App shell that wraps all patient screens with a floating bottom navigation bar
class PatientAppShell extends ConsumerStatefulWidget {
  final Widget child;
  final NavigationItem currentItem;
  final Map<NavigationItem, String>? routes;

  const PatientAppShell({
    super.key,
    required this.child,
    required this.currentItem,
    this.routes,
  });

  @override
  ConsumerState<PatientAppShell> createState() => _PatientAppShellState();
}

class _PatientAppShellState extends ConsumerState<PatientAppShell> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Screen content
          widget.child,
          if (authState.status == AuthStatus.authenticatedWithoutProfile)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color:
                      Theme.of(context).colorScheme.surface.withOpacity(0.95),
                  child: Text(
                    'Finishing setup…',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

          // Floating navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: RoundedNavigationBar(
              currentItem: widget.currentItem,
              routes: widget.routes,
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper function to determine current navigation item based on route
NavigationItem getCurrentNavigationItem(String location) {
  if (location.startsWith('/patient/home')) {
    return NavigationItem.home;
  } else if (location.startsWith('/patient/overview')) {
    return NavigationItem.overview;
  } else if (location.startsWith('/patient/care-team')) {
    return NavigationItem.careTeam;
  } else if (location.startsWith('/patient/profile')) {
    return NavigationItem.profile;
  } else if (location.startsWith('/profile')) {
    return NavigationItem.profile;
  } else if (location.startsWith('/caregiver/home')) {
    return NavigationItem.home;
  } else if (location.startsWith('/caregiver/patients')) {
    return NavigationItem.visits;
  } else if (location.startsWith('/caregiver/alerts')) {
    return NavigationItem.overview;
  } else if (location.startsWith('/caregiver/accept-invitations')) {
    return NavigationItem.careTeam;
  } else {
    // Default to home for unknown routes
    return NavigationItem.home;
  }
}
