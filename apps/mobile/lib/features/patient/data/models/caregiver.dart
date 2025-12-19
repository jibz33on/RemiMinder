import 'package:equatable/equatable.dart';

enum CaregiverRelationship {
  family,
  friend,
  spouse,
  healthcareProfessional,
  other,
}

enum InvitationStatus {
  pending,
  accepted,
  declined,
  cancelled,
}

enum Permission {
  viewMedications,
  viewVisits,
  viewHealthData,
  editMedications,
  manageEmergency,
  receiveAlerts,
}

class Caregiver extends Equatable {
  final String id;
  final String name;
  final String email;
  final CaregiverRelationship relationship;
  final InvitationStatus status;
  final List<Permission> permissions;
  final DateTime invitedDate;
  final DateTime? acceptedDate;
  final DateTime? lastActivity;
  final int activityCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Caregiver({
    required this.id,
    required this.name,
    required this.email,
    required this.relationship,
    this.status = InvitationStatus.pending,
    this.permissions = const [],
    required this.invitedDate,
    this.acceptedDate,
    this.lastActivity,
    this.activityCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Caregiver copyWith({
    String? id,
    String? name,
    String? email,
    CaregiverRelationship? relationship,
    InvitationStatus? status,
    List<Permission>? permissions,
    DateTime? invitedDate,
    DateTime? acceptedDate,
    DateTime? lastActivity,
    int? activityCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Caregiver(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      relationship: relationship ?? this.relationship,
      status: status ?? this.status,
      permissions: permissions ?? this.permissions,
      invitedDate: invitedDate ?? this.invitedDate,
      acceptedDate: acceptedDate ?? this.acceptedDate,
      lastActivity: lastActivity ?? this.lastActivity,
      activityCount: activityCount ?? this.activityCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Caregiver.fromJson(Map<String, dynamic> json) {
    return Caregiver(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      relationship:
          CaregiverRelationship.values[json['relationship'] as int? ?? 0],
      status: InvitationStatus.values[json['status'] as int? ?? 0],
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((p) => Permission.values[p as int])
              .toList() ??
          [],
      invitedDate: DateTime.parse(json['invitedDate'] as String),
      acceptedDate: json['acceptedDate'] != null
          ? DateTime.parse(json['acceptedDate'] as String)
          : null,
      lastActivity: json['lastActivity'] != null
          ? DateTime.parse(json['lastActivity'] as String)
          : null,
      activityCount: json['activityCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'relationship': relationship.index,
      'status': status.index,
      'permissions': permissions.map((p) => p.index).toList(),
      'invitedDate': invitedDate.toIso8601String(),
      'acceptedDate': acceptedDate?.toIso8601String(),
      'lastActivity': lastActivity?.toIso8601String(),
      'activityCount': activityCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  bool hasPermission(Permission permission) {
    return permissions.contains(permission);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        relationship,
        status,
        permissions,
        invitedDate,
        acceptedDate,
        lastActivity,
        activityCount,
        createdAt,
        updatedAt,
      ];
}
