import 'package:flutter/material.dart';
import 'rounded_navigation_bar.dart';

/// App shell that wraps all patient screens with a floating bottom navigation bar
class PatientAppShell extends StatefulWidget {
  final Widget child;
  final NavigationItem currentItem;

  const PatientAppShell({
    super.key,
    required this.child,
    required this.currentItem,
  });

  @override
  State<PatientAppShell> createState() => _PatientAppShellState();
}

class _PatientAppShellState extends State<PatientAppShell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Screen content
          widget.child,

          // Floating navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: RoundedNavigationBar(currentItem: widget.currentItem),
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
  } else {
    // Default to home for unknown routes
    return NavigationItem.home;
  }
}
