import 'package:uuid/uuid.dart';

/// Service to manage the current visit context across the app.
/// Ensures one visitId per visit session, shared by audio and camera actions.
///
/// This is an app-lifecycle singleton scoped to the UI isolate.
/// VisitId represents a medical encounter context, not a UI convenience value.
class VisitContext {
  static final VisitContext _instance = VisitContext._internal();
  factory VisitContext() => _instance;
  VisitContext._internal();

  String? _currentVisitId;

  /// Starts a new visit session and returns the generated visitId.
  ///
  /// Call this when a user begins a new medical visit (e.g., tapping "Record Visit").
  /// This establishes the visit context for subsequent actions like camera capture.
  String startNewVisit() {
    _currentVisitId = const Uuid().v4();
    return _currentVisitId!;
  }

  /// Sets a specific visitId as the current visit context.
  ///
  /// Use this when a visitId has already been generated elsewhere
  /// (e.g., in VisitRecordingScreen when receiving a visitId from navigation).
  void setCurrentVisit(String visitId) {
    _currentVisitId = visitId;
  }

  /// Returns the current visitId, or null if no visit is active.
  ///
  /// Use this to check if there's an ongoing visit session before
  /// performing visit-related actions (e.g., camera capture).
  String? getCurrentVisitId() {
    return _currentVisitId;
  }

  /// Clears the current visit context.
  ///
  /// Call this when a visit session ends or should be reset.
  /// Currently called during user logout to prevent stale visit state.
  /// Should also be called when a user explicitly finishes a visit
  /// or when app session resets.
  void clearVisit() {
    _currentVisitId = null;
  }
}
