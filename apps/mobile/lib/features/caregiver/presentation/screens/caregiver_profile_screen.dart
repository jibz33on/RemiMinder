import 'package:flutter/material.dart';
import '../../../patient/presentation/screens/profile_screen.dart';

class CaregiverProfileScreen extends StatelessWidget {
  const CaregiverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen(
      forceCaregiver: true,
      headerTitle: 'Caregiver Settings',
    );
  }
}
