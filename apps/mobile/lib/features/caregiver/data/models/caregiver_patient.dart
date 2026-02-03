class CaregiverPatient {
  final String patientId;
  final String? fullName;
  final String? email;
  final String membershipRole;
  final String permission;

  const CaregiverPatient({
    required this.patientId,
    required this.fullName,
    required this.email,
    required this.membershipRole,
    required this.permission,
  });

  factory CaregiverPatient.fromJson(Map<String, dynamic> json) {
    return CaregiverPatient(
      patientId: json['patient_id'] as String,
      fullName: json['full_name'] as String?,
      email: json['email'] as String?,
      membershipRole: json['membership_role'] as String? ?? '',
      permission: json['permission'] as String? ?? 'view',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'full_name': fullName,
      'email': email,
      'membership_role': membershipRole,
      'permission': permission,
    };
  }
}
