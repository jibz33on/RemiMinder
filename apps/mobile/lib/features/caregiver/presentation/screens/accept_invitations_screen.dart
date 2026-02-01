import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../care_team/data/models/care_team_invitation.dart';
import '../../../care_team/data/services/care_team_api_service.dart';
import '../../../../l10n/app_localizations.dart';

class AcceptInvitationsScreen extends StatefulWidget {
  const AcceptInvitationsScreen({super.key});

  @override
  State<AcceptInvitationsScreen> createState() =>
      _AcceptInvitationsScreenState();
}

class _AcceptInvitationsScreenState extends State<AcceptInvitationsScreen> {
  List<CareTeamInvitation> _invitations = [];
  bool _isLoading = true;
  String? _error;
  final Set<String> _acceptingIds = {};

  @override
  void initState() {
    super.initState();
    _loadInvitations();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => context.go('/caregiver/home'),
        ),
        title: Text(
          l10n?.caregiverInvitationsTitle ?? 'Caregiver Invitations',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    final l10n = AppLocalizations.of(context);
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                l10n?.caregiverInvitationsEmpty ?? 'No pending invitations',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadInvitations,
                child: Text(
                    l10n?.caregiverInvitationsRetry ?? 'Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_invitations.isEmpty) {
      return Center(
        child: Text(
          l10n?.caregiverInvitationsEmpty ?? 'No pending invitations',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _invitations.length,
      itemBuilder: (context, index) {
        final invitation = _invitations[index];
        final isAccepting = _acceptingIds.contains(invitation.id);
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invitation.patientName ??
                      invitation.patientId ??
                      (l10n?.caregiverInvitationsPatientFallback ?? 'Patient'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n?.caregiverInvitationsRole(invitation.role) ??
                      'Role: ${invitation.role}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n?.caregiverInvitationsPermission(
                          invitation.permission) ??
                      'Permission: ${invitation.permission}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: isAccepting
                        ? null
                        : () => _acceptInvitation(invitation),
                    child: isAccepting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            l10n?.caregiverInvitationsAccept ?? 'Accept'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadInvitations() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final invitations = await CareTeamApiService().getMyInvitations();
      if (!mounted) return;
      setState(() {
        _invitations = invitations;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptInvitation(CareTeamInvitation invitation) async {
    final l10n = AppLocalizations.of(context);
    final token = invitation.token;
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n?.caregiverInvitationsMissingToken ??
                'Invitation token is missing')),
      );
      return;
    }
    setState(() {
      _acceptingIds.add(invitation.id);
    });

    try {
      await CareTeamApiService().acceptInvitation(token: token);
      if (!mounted) return;
      setState(() {
        _invitations.removeWhere((item) => item.id == invitation.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n?.caregiverInvitationsAccepted ??
                'Invitation accepted')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _acceptingIds.remove(invitation.id);
      });
    }
  }
}
