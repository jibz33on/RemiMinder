import 'package:equatable/equatable.dart';

enum AppointmentType {
  cardiology,
  primaryCare,
  specialist,
  labWork,
  imaging,
  therapy,
  other,
}

enum AppointmentStatus {
  scheduled,
  confirmed,
  completed,
  cancelled,
  rescheduled,
}

class Appointment extends Equatable {
  final String id;
  final String doctorName;
  final String specialty;
  final AppointmentType type;
  final DateTime scheduledDateTime;
  final Duration duration;
  final String location;
  final String address;
  final String? phoneNumber;
  final String? notes;
  final AppointmentStatus status;
  final String? reason;
  final List<String>? preparationInstructions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Appointment({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.type,
    required this.scheduledDateTime,
    required this.duration,
    required this.location,
    required this.address,
    this.phoneNumber,
    this.notes,
    this.status = AppointmentStatus.scheduled,
    this.reason,
    this.preparationInstructions,
    required this.createdAt,
    required this.updatedAt,
  });

  Appointment copyWith({
    String? id,
    String? doctorName,
    String? specialty,
    AppointmentType? type,
    DateTime? scheduledDateTime,
    Duration? duration,
    String? location,
    String? address,
    String? phoneNumber,
    String? notes,
    AppointmentStatus? status,
    String? reason,
    List<String>? preparationInstructions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      type: type ?? this.type,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      duration: duration ?? this.duration,
      location: location ?? this.location,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      preparationInstructions:
          preparationInstructions ?? this.preparationInstructions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      doctorName: json['doctorName'] as String,
      specialty: json['specialty'] as String,
      type: AppointmentType.values[json['type'] as int? ?? 0],
      scheduledDateTime: DateTime.parse(json['scheduledDateTime'] as String),
      duration: Duration(minutes: json['durationMinutes'] as int? ?? 30),
      location: json['location'] as String,
      address: json['address'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      notes: json['notes'] as String?,
      status: AppointmentStatus.values[json['status'] as int? ?? 0],
      reason: json['reason'] as String?,
      preparationInstructions:
          (json['preparationInstructions'] as List<dynamic>?)?.cast<String>(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorName': doctorName,
      'specialty': specialty,
      'type': type.index,
      'scheduledDateTime': scheduledDateTime.toIso8601String(),
      'durationMinutes': duration.inMinutes,
      'location': location,
      'address': address,
      'phoneNumber': phoneNumber,
      'notes': notes,
      'status': status.index,
      'reason': reason,
      'preparationInstructions': preparationInstructions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        doctorName,
        specialty,
        type,
        scheduledDateTime,
        duration,
        location,
        address,
        phoneNumber,
        notes,
        status,
        reason,
        preparationInstructions,
        createdAt,
        updatedAt,
      ];
}
