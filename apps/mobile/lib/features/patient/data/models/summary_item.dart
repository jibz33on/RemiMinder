class SummaryItem {
  final String summaryId;
  final String visitId;
  final String doctorName;
  final String specialty;
  final String? visitDate;
  final String summaryCreatedAt;
  final String summaryPreview;
  final String modelName;

  SummaryItem({
    required this.summaryId,
    required this.visitId,
    required this.doctorName,
    required this.specialty,
    this.visitDate,
    required this.summaryCreatedAt,
    required this.summaryPreview,
    required this.modelName,
  });

  factory SummaryItem.fromJson(Map<String, dynamic> json) {
    return SummaryItem(
      summaryId: json['summary_id'] as String,
      visitId: json['visit_id'] as String,
      doctorName: json['doctor_name'] as String? ?? 'Unknown Doctor',
      specialty: json['specialty'] as String? ?? 'Unknown Specialty',
      visitDate: json['visit_date'] as String?,
      summaryCreatedAt: json['summary_created_at'] as String,
      summaryPreview: json['summary_preview'] as String,
      modelName: json['model_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visit_id': visitId,
      'doctor_name': doctorName,
      'specialty': specialty,
      'visit_date': visitDate,
      'summary_created_at': summaryCreatedAt,
      'summary_preview': summaryPreview,
      'model_name': modelName,
    };
  }
}
