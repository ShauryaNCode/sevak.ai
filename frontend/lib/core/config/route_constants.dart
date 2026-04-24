// lib/core/config/route_constants.dart

/// Centralized application route paths.
class AppRoutes {
  /// Prevents instantiation.
  const AppRoutes._();

  /// Login screen route.
  static const String login = '/login';

  /// OTP verification route prefix.
  static const String otpVerification = '/login/verify';

  /// Volunteer dashboard route.
  static const String volunteerDashboard = '/volunteer/dashboard';

  /// Coordinator and admin dashboard route.
  static const String coordinatorDashboard = '/coordinator/dashboard';

  /// Coordinator needs management route.
  static const String coordinatorNeeds = '/coordinator/needs';

  /// Coordinator volunteers management route.
  static const String coordinatorVolunteers = '/coordinator/volunteers';

  /// Coordinator resources management route.
  static const String coordinatorResources = '/coordinator/resources';

  /// Coordinator map route.
  static const String coordinatorMap = '/coordinator/map';

  /// Coordinator settings route.
  static const String coordinatorSettings = '/coordinator/settings';

  /// Shared error route.
  static const String error = '/error';
}
