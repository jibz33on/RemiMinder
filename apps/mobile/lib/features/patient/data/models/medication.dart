import 'package:equatable/equatable.dart';

enum MedicationStatus {
  active,
  completed,
  paused,
  discontinued,
}

class Medication extends Equatable {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final String instructions;
  final MedicationStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? prescribedBy;
  final String? pharmacy;
  final List<String>? sideEffects;
  final List<String>? interactions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.instructions,
    this.status = MedicationStatus.active,
    this.startDate,
    this.endDate,
    this.prescribedBy,
    this.pharmacy,
    this.sideEffects,
    this.interactions,
    required this.createdAt,
    required this.updatedAt,
  });

  Medication copyWith({
    String? id,
    String? name,
    String? dosage,
    String? frequency,
    String? instructions,
    MedicationStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    String? prescribedBy,
    String? pharmacy,
    List<String>? sideEffects,
    List<String>? interactions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      instructions: instructions ?? this.instructions,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      prescribedBy: prescribedBy ?? this.prescribedBy,
      pharmacy: pharmacy ?? this.pharmacy,
      sideEffects: sideEffects ?? this.sideEffects,
      interactions: interactions ?? this.interactions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      instructions: json['instructions'] as String,
      status: MedicationStatus.values[json['status'] as int? ?? 0],
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      prescribedBy: json['prescribedBy'] as String?,
      pharmacy: json['pharmacy'] as String?,
      sideEffects: (json['sideEffects'] as List<dynamic>?)?.cast<String>(),
      interactions: (json['interactions'] as List<dynamic>?)?.cast<String>(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'instructions': instructions,
      'status': status.index,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'prescribedBy': prescribedBy,
      'pharmacy': pharmacy,
      'sideEffects': sideEffects,
      'interactions': interactions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        dosage,
        frequency,
        instructions,
        status,
        startDate,
        endDate,
        prescribedBy,
        pharmacy,
        sideEffects,
        interactions,
        createdAt,
        updatedAt,
      ];
}
