import 'package:equatable/equatable.dart';

enum VisitType {
  inPerson,
  telehealth,
  emergency,
  followUp,
  consultation,
  procedure,
}

class Visit extends Equatable {
  final String id;
  final String doctorName;
  final String specialty;
  final VisitType type;
  final DateTime visitDateTime;
  final Duration duration;
  final String location;
  final String? summary;
  final String? transcript;
  final List<String>? keyTakeaways;
  final List<String>? instructions;
  final List<String>? medicationsPrescribed;
  final List<String>? testsOrdered;
  final String? followUpNotes;
  final DateTime? nextAppointmentDate;
  final bool hasRecording;
  final String? recordingUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Visit({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.type,
    required this.visitDateTime,
    required this.duration,
    required this.location,
    this.summary,
    this.transcript,
    this.keyTakeaways,
    this.instructions,
    this.medicationsPrescribed,
    this.testsOrdered,
    this.followUpNotes,
    this.nextAppointmentDate,
    this.hasRecording = false,
    this.recordingUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Visit copyWith({
    String? id,
    String? doctorName,
    String? specialty,
    VisitType? type,
    DateTime? visitDateTime,
    Duration? duration,
    String? location,
    String? summary,
    String? transcript,
    List<String>? keyTakeaways,
    List<String>? instructions,
    List<String>? medicationsPrescribed,
    List<String>? testsOrdered,
    String? followUpNotes,
    DateTime? nextAppointmentDate,
    bool? hasRecording,
    String? recordingUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Visit(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      type: type ?? this.type,
      visitDateTime: visitDateTime ?? this.visitDateTime,
      duration: duration ?? this.duration,
      location: location ?? this.location,
      summary: summary ?? this.summary,
      transcript: transcript ?? this.transcript,
      keyTakeaways: keyTakeaways ?? this.keyTakeaways,
      instructions: instructions ?? this.instructions,
      medicationsPrescribed:
          medicationsPrescribed ?? this.medicationsPrescribed,
      testsOrdered: testsOrdered ?? this.testsOrdered,
      followUpNotes: followUpNotes ?? this.followUpNotes,
      nextAppointmentDate: nextAppointmentDate ?? this.nextAppointmentDate,
      hasRecording: hasRecording ?? this.hasRecording,
      recordingUrl: recordingUrl ?? this.recordingUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      id: json['id'] as String,
      doctorName: json['doctorName'] as String,
      specialty: json['specialty'] as String,
      type: VisitType.values[json['type'] as int? ?? 0],
      visitDateTime: DateTime.parse(json['visitDateTime'] as String),
      duration: Duration(minutes: json['durationMinutes'] as int? ?? 30),
      location: json['location'] as String,
      summary: json['summary'] as String?,
      transcript: json['transcript'] as String?,
      keyTakeaways: (json['keyTakeaways'] as List<dynamic>?)?.cast<String>(),
      instructions: (json['instructions'] as List<dynamic>?)?.cast<String>(),
      medicationsPrescribed:
          (json['medicationsPrescribed'] as List<dynamic>?)?.cast<String>(),
      testsOrdered: (json['testsOrdered'] as List<dynamic>?)?.cast<String>(),
      followUpNotes: json['followUpNotes'] as String?,
      nextAppointmentDate: json['nextAppointmentDate'] != null
          ? DateTime.parse(json['nextAppointmentDate'] as String)
          : null,
      hasRecording: json['hasRecording'] as bool? ?? false,
      recordingUrl: json['recordingUrl'] as String?,
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
      'visitDateTime': visitDateTime.toIso8601String(),
      'durationMinutes': duration.inMinutes,
      'location': location,
      'summary': summary,
      'transcript': transcript,
      'keyTakeaways': keyTakeaways,
      'instructions': instructions,
      'medicationsPrescribed': medicationsPrescribed,
      'testsOrdered': testsOrdered,
      'followUpNotes': followUpNotes,
      'nextAppointmentDate': nextAppointmentDate?.toIso8601String(),
      'hasRecording': hasRecording,
      'recordingUrl': recordingUrl,
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
        visitDateTime,
        duration,
        location,
        summary,
        transcript,
        keyTakeaways,
        instructions,
        medicationsPrescribed,
        testsOrdered,
        followUpNotes,
        nextAppointmentDate,
        hasRecording,
        recordingUrl,
        createdAt,
        updatedAt,
      ];
}
