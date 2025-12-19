import '../../models/models.dart';

abstract class AppointmentRepository {
  Future<List<Appointment>> getAppointments();
  Future<Appointment?> getAppointment(String id);
  Future<Appointment> createAppointment(Appointment appointment);
  Future<Appointment> updateAppointment(Appointment appointment);
  Future<void> deleteAppointment(String id);
  Future<List<Appointment>> getUpcomingAppointments();
  Future<List<Appointment>> getPastAppointments();
  Future<List<Appointment>> getAppointmentsForDate(DateTime date);
  Future<List<Appointment>> getAppointmentsForDateRange(DateTime start, DateTime end);
  Stream<List<Appointment>> watchAppointments();
  Stream<List<Appointment>> watchUpcomingAppointments();
}
