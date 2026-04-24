// C:\Users\th366\Desktop\sevakai\frontend\lib\features\authentication\domain\entities\user_role.dart

/// Supported authenticated user roles in SevakAI.
enum UserRole {
  /// Field volunteer role with limited operational access.
  volunteer,

  /// Zone-level coordination role.
  zoneCoordinator,

  /// District-level administrative role.
  districtAdmin,

  /// National-level administrative role.
  nationalAdmin,

  /// Internal AI system role reserved for automation.
  aiSystem;

  /// Parses a backend role string into a [UserRole].
  static UserRole fromString(String value) {
    switch (value) {
      case 'VOLUNTEER':
        return UserRole.volunteer;
      case 'ZONE_COORDINATOR':
        return UserRole.zoneCoordinator;
      case 'DISTRICT_ADMIN':
        return UserRole.districtAdmin;
      case 'NATIONAL_ADMIN':
        return UserRole.nationalAdmin;
      case 'AI_SYSTEM':
        return UserRole.aiSystem;
      default:
        throw ArgumentError('Unknown user role: $value');
    }
  }
}

/// Convenience capabilities for [UserRole].
extension UserRoleX on UserRole {
  /// Human-readable name for the role.
  String get displayName {
    switch (this) {
      case UserRole.volunteer:
        return 'Volunteer';
      case UserRole.zoneCoordinator:
        return 'Zone Coordinator';
      case UserRole.districtAdmin:
        return 'District Admin';
      case UserRole.nationalAdmin:
        return 'National Admin';
      case UserRole.aiSystem:
        return 'AI System';
    }
  }

  /// Whether the role can manage volunteers.
  bool get canManageVolunteers =>
      this == UserRole.zoneCoordinator ||
      this == UserRole.districtAdmin ||
      this == UserRole.nationalAdmin ||
      this == UserRole.aiSystem;

  /// Whether the role can view all zones.
  bool get canViewAllZones =>
      this == UserRole.districtAdmin ||
      this == UserRole.nationalAdmin ||
      this == UserRole.aiSystem;

  /// Whether the role can declare incidents.
  bool get canDeclareIncident =>
      this == UserRole.districtAdmin ||
      this == UserRole.nationalAdmin ||
      this == UserRole.aiSystem;

  /// Whether the role can broadcast alerts.
  bool get canBroadcastAlerts =>
      this == UserRole.zoneCoordinator ||
      this == UserRole.districtAdmin ||
      this == UserRole.nationalAdmin ||
      this == UserRole.aiSystem;
}
