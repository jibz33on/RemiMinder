class PatientTask {
  final String id;
  final String title;
  final String type;
  final String status;
  final DateTime? createdAt;

  PatientTask({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.createdAt,
  });

  factory PatientTask.fromJson(Map<String, dynamic> json) {
    return PatientTask(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
    );
  }
}
