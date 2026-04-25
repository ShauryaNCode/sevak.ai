// C:\Users\th366\Desktop\sevakai\frontend\lib\features\volunteers\presentation\screens\volunteer_dashboard_screen.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/injection.dart';
import '../../../../features/authentication/domain/entities/auth_user.dart';
import '../../../../services/location_service.dart';
import '../../../../ui/themes/app_colors.dart';
import '../../../../ui/themes/app_spacing.dart';
import '../../../../ui/themes/app_text_styles.dart';

class VolunteerDashboardScreen extends StatefulWidget {
  const VolunteerDashboardScreen({
    required this.user,
    super.key,
  });

  final AuthUser user;

  @override
  State<VolunteerDashboardScreen> createState() => _VolunteerDashboardScreenState();
}

class _VolunteerDashboardScreenState extends State<VolunteerDashboardScreen> {
  static const String _volunteerProfileIdKey = 'volunteer_profile_id';

  final Dio _dio = getIt<Dio>();
  final GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _needFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _whatsAppController = TextEditingController();
  final TextEditingController _alternateController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _locationLabelController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _needTitleController = TextEditingController();
  final TextEditingController _needDescriptionController = TextEditingController();
  final TextEditingController _needLocationController = TextEditingController();
  final TextEditingController _needPincodeController = TextEditingController();
  final TextEditingController _needAffectedController = TextEditingController(text: '1');

  bool _loading = true;
  bool _submitting = false;
  bool _capturingProfileLocation = false;
  bool _capturingNeedLocation = false;
  bool _updatingProfile = false;
  bool _postingNeed = false;
  String? _error;
  String? _volunteerProfileId;
  String _needType = 'medical';
  String _needUrgency = 'medium';
  CapturedLocation? _profileLocation;
  CapturedLocation? _needLocation;
  List<Map<String, dynamic>> _needs = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _camps = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _volunteers = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _whatsAppController.text = widget.user.phone;
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _whatsAppController.dispose();
    _alternateController.dispose();
    _qualificationController.dispose();
    _designationController.dispose();
    _skillsController.dispose();
    _locationLabelController.dispose();
    _pincodeController.dispose();
    _genderController.dispose();
    _needTitleController.dispose();
    _needDescriptionController.dispose();
    _needLocationController.dispose();
    _needPincodeController.dispose();
    _needAffectedController.dispose();
    super.dispose();
  }

  Map<String, dynamic>? get _profile {
    for (final Map<String, dynamic> volunteer in _volunteers) {
      if ('${volunteer['id']}' == _volunteerProfileId) {
        return volunteer;
      }
    }
    return null;
  }

  bool get _hasActiveAssignment {
    final String assignmentId = '${_profile?['current_assignment_need_id'] ?? ''}';
    return assignmentId.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: <Widget>[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: const Icon(Icons.volunteer_activism_rounded, color: AppColors.white, size: 18),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Volunteer Ops',
              style: AppTextStyles.titleLarge.copyWith(color: AppColors.neutral900),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.neutral200),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded, color: AppColors.neutral600),
            tooltip: 'Refresh',
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: _loading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: AppSpacing.md),
                  Text('Loading operations...'),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: <Widget>[
                if (_error != null) _ErrorBanner(message: _error!),
                _SummaryPanel(
                  items: <_StatItem>[
                    _StatItem(
                      label: 'Open Needs',
                      value: '${_needs.where((Map<String, dynamic> item) => '${item['status']}' != 'completed').length}',
                      icon: Icons.campaign_rounded,
                      color: AppColors.dangerRed,
                      bgColor: AppColors.dangerRedLight,
                    ),
                    _StatItem(
                      label: 'Active Camps',
                      value: '${_camps.where((Map<String, dynamic> item) => '${item['status']}' == 'active').length}',
                      icon: Icons.location_city_rounded,
                      color: AppColors.primaryBlue,
                      bgColor: AppColors.primaryBlueLight,
                    ),
                    _StatItem(
                      label: 'Available',
                      value: '${_volunteers.where((Map<String, dynamic> item) => item['availability'] == true).length}',
                      icon: Icons.people_rounded,
                      color: AppColors.successGreen,
                      bgColor: AppColors.successGreenLight,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                if (_volunteerProfileId == null) _buildRegistrationCard() else ...<Widget>[
                  _buildVolunteerStatusCard(),
                  const SizedBox(height: AppSpacing.md),
                  _buildProfileUpdateCard(),
                  const SizedBox(height: AppSpacing.md),
                  _buildNewNeedCard(),
                ],
                const SizedBox(height: AppSpacing.md),
                _buildNeedsSection(),
                const SizedBox(height: AppSpacing.md),
                _buildCampsSection(),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
    );
  }

  Widget _buildRegistrationCard() {
    return _SectionCard(
      title: 'Complete Volunteer Profile',
      subtitle: 'Your location is mandatory so the heat map can place you even when GPS is unavailable.',
      icon: Icons.app_registration_rounded,
      iconColor: AppColors.primaryBlue,
      child: Form(
        key: _registrationFormKey,
        child: Column(
          children: <Widget>[
            _buildFormRow([
              _buildTextField(_nameController, 'Full name', required: true),
              _buildTextField(_whatsAppController, 'WhatsApp number', required: true),
            ]),
            const SizedBox(height: AppSpacing.md),
            _buildFormRow([
              _buildTextField(_alternateController, 'Alternate number'),
              _buildTextField(_genderController, 'Gender', required: true),
            ]),
            const SizedBox(height: AppSpacing.md),
            _buildFormRow([
              _buildTextField(_qualificationController, 'Qualification', required: true),
              _buildTextField(_designationController, 'Designation', required: true),
            ]),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_skillsController, 'Skills (comma separated)'),
            const SizedBox(height: AppSpacing.md),
            _buildFormRow([
              _buildTextField(_locationLabelController, 'Location / locality', required: true),
              _buildTextField(_pincodeController, 'Pincode'),
            ]),
            const SizedBox(height: AppSpacing.md),
            _GpsButton(
              capturing: _capturingProfileLocation,
              captured: _profileLocation != null,
              capturedLabel: _profileLocation != null
                  ? 'GPS ${_profileLocation!.latitude.toStringAsFixed(5)}, ${_profileLocation!.longitude.toStringAsFixed(5)}'
                  : null,
              idleLabel: 'Use GPS Location',
              loadingLabel: 'Fetching GPS...',
              capturedButtonLabel: 'GPS Captured',
              onTap: _captureProfileLocation,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                onPressed: _submitting ? null : _registerVolunteer,
                icon: const Icon(Icons.app_registration_rounded, size: 18),
                label: Text(_submitting ? 'Registering...' : 'Register as Volunteer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolunteerStatusCard() {
    final Map<String, dynamic>? profile = _profile;
    final String campId = '${profile?['camp_id'] ?? ''}';
    Map<String, dynamic>? camp;
    for (final Map<String, dynamic> item in _camps) {
      if ('${item['id'] ?? ''}' == campId) {
        camp = item;
        break;
      }
    }

    final bool onMission = _hasActiveAssignment;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: onMission
              ? <Color>[const Color(0xFF1D4ED8), const Color(0xFF2563EB)]
              : <Color>[const Color(0xFF1E3A5F), const Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: const Icon(Icons.person_rounded, color: AppColors.white, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      profile == null ? widget.user.name : '${profile['name']}',
                      style: AppTextStyles.titleLarge.copyWith(color: AppColors.white),
                    ),
                    Text(
                      '${profile?['designation'] ?? 'Volunteer'} · ID $_volunteerProfileId',
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: onMission ? AppColors.warningAmber : AppColors.successGreen,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  onMission ? 'ON MISSION' : 'AVAILABLE',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.15),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              const Icon(Icons.location_city_rounded, color: Colors.white70, size: 16),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  camp == null ? 'Camp: Unassigned' : 'Camp: ${camp['name']}',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                ),
              ),
              const Icon(Icons.place_rounded, color: Colors.white70, size: 16),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  '${profile?['location']?['label'] ?? widget.user.zoneId}',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              _WhitePill(label: '${profile?['qualification'] ?? 'General'}'),
              if ((profile?['skills'] as List<dynamic>? ?? <dynamic>[]).isNotEmpty)
                ...(profile!['skills'] as List<dynamic>)
                    .take(3)
                    .map((dynamic s) => _WhitePill(label: '$s')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileUpdateCard() {
    return _SectionCard(
      title: 'Update Profile',
      subtitle: 'Keep your location and contact details current so managers can place you correctly.',
      icon: Icons.manage_accounts_rounded,
      iconColor: AppColors.neutral600,
      child: Form(
        key: _profileFormKey,
        child: Column(
          children: <Widget>[
            _buildFormRow([
              _buildTextField(_nameController, 'Full name', required: true),
              _buildTextField(_whatsAppController, 'WhatsApp number', required: true),
            ]),
            const SizedBox(height: AppSpacing.md),
            _buildFormRow([
              _buildTextField(_alternateController, 'Alternate number'),
              _buildTextField(_genderController, 'Gender', required: true),
            ]),
            const SizedBox(height: AppSpacing.md),
            _buildFormRow([
              _buildTextField(_qualificationController, 'Qualification', required: true),
              _buildTextField(_designationController, 'Designation', required: true),
            ]),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_skillsController, 'Skills (comma separated)'),
            const SizedBox(height: AppSpacing.md),
            _buildFormRow([
              _buildTextField(_locationLabelController, 'Fallback location', required: true),
              _buildTextField(_pincodeController, 'Pincode'),
            ]),
            const SizedBox(height: AppSpacing.md),
            _GpsButton(
              capturing: _capturingProfileLocation,
              captured: _profileLocation != null,
              capturedLabel: null,
              idleLabel: 'Update with GPS',
              loadingLabel: 'Refreshing GPS...',
              capturedButtonLabel: 'GPS Updated',
              onTap: _captureProfileLocation,
            ),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                onPressed: _updatingProfile ? null : _updateProfile,
                icon: const Icon(Icons.save_rounded, size: 18),
                label: Text(_updatingProfile ? 'Saving...' : 'Save Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewNeedCard() {
    return _SectionCard(
      title: 'Post New Need',
      subtitle: 'Raise a fresh need from the field. GPS is preferred, manual location is the fallback.',
      icon: Icons.campaign_rounded,
      iconColor: AppColors.dangerRed,
      child: Form(
        key: _needFormKey,
        child: Column(
          children: <Widget>[
            _buildTextField(_needTitleController, 'Need title', required: true),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_needDescriptionController, 'Description', required: true, maxLines: 3),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: <Widget>[
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _needType,
                    decoration: _dropdownDecoration('Need type'),
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem<String>(value: 'food', child: Text('Food')),
                      DropdownMenuItem<String>(value: 'water', child: Text('Water')),
                      DropdownMenuItem<String>(value: 'medical', child: Text('Medical')),
                      DropdownMenuItem<String>(value: 'shelter', child: Text('Shelter')),
                      DropdownMenuItem<String>(value: 'rescue', child: Text('Rescue')),
                    ],
                    onChanged: (String? value) => setState(() => _needType = value ?? 'medical'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _needUrgency,
                    decoration: _dropdownDecoration('Urgency'),
                    items: <DropdownMenuItem<String>>[
                      DropdownMenuItem<String>(
                        value: 'low',
                        child: Row(children: <Widget>[
                          _UrgencyDot(color: AppColors.successGreen),
                          const SizedBox(width: 6),
                          const Text('Low'),
                        ]),
                      ),
                      DropdownMenuItem<String>(
                        value: 'medium',
                        child: Row(children: <Widget>[
                          _UrgencyDot(color: AppColors.warningAmber),
                          const SizedBox(width: 6),
                          const Text('Medium'),
                        ]),
                      ),
                      DropdownMenuItem<String>(
                        value: 'high',
                        child: Row(children: <Widget>[
                          _UrgencyDot(color: AppColors.dangerRed),
                          const SizedBox(width: 6),
                          const Text('High'),
                        ]),
                      ),
                    ],
                    onChanged: (String? value) => setState(() => _needUrgency = value ?? 'medium'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                SizedBox(
                  width: 100,
                  child: _buildTextField(_needAffectedController, 'Affected', required: true),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _buildFormRow([
              _buildTextField(_needLocationController, 'Location / locality', required: true),
              _buildTextField(_needPincodeController, 'Pincode'),
            ]),
            const SizedBox(height: AppSpacing.md),
            _GpsButton(
              capturing: _capturingNeedLocation,
              captured: _needLocation != null,
              capturedLabel: null,
              idleLabel: 'Use GPS For Need',
              loadingLabel: 'Fetching GPS...',
              capturedButtonLabel: 'Need GPS Captured',
              onTap: _captureNeedLocation,
            ),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dangerRed,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                onPressed: _postingNeed ? null : _postNeed,
                icon: const Icon(Icons.campaign_rounded, size: 18),
                label: Text(_postingNeed ? 'Posting...' : 'Post Need'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeedsSection() {
    final List<Map<String, dynamic>> openNeeds = _needs
        .where((Map<String, dynamic> item) => '${item['status']}' != 'completed')
        .toList();
    final List<Map<String, dynamic>> closedNeeds = _needs
        .where((Map<String, dynamic> item) => '${item['status']}' == 'completed')
        .toList();

    return _SectionCard(
      title: 'Live Requests',
      subtitle: 'Accept one open need at a time. Mark it completed once resolved.',
      icon: Icons.assignment_rounded,
      iconColor: AppColors.primaryBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (_needs.isEmpty)
            _EmptyState(
              icon: Icons.check_circle_outline_rounded,
              message: 'No open requests right now.',
            )
          else ...<Widget>[
            if (openNeeds.isNotEmpty) ...<Widget>[
              ...openNeeds.map((Map<String, dynamic> need) => _NeedCard(
                    need: need,
                    volunteerProfileId: _volunteerProfileId,
                    canAccept: !_hasActiveAssignment,
                    onAccept: () => _assignNeed('${need['id']}'),
                    onComplete: () => _completeNeed('${need['id']}'),
                  )),
            ],
            if (closedNeeds.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'COMPLETED',
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.neutral400, letterSpacing: 1.2),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...closedNeeds.map((Map<String, dynamic> need) => _NeedCard(
                    need: need,
                    volunteerProfileId: _volunteerProfileId,
                    canAccept: false,
                    onAccept: () => _assignNeed('${need['id']}'),
                    onComplete: () => _completeNeed('${need['id']}'),
                  )),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildCampsSection() {
    return _SectionCard(
      title: 'Camp Visibility',
      subtitle: 'Managers check you back in, which sets your active location to the camp.',
      icon: Icons.location_city_rounded,
      iconColor: AppColors.primaryBlue,
      child: Column(
        children: _camps.isEmpty
            ? <Widget>[
                _EmptyState(
                  icon: Icons.location_city_outlined,
                  message: 'No camps have been created yet.',
                ),
              ]
            : _camps.map((Map<String, dynamic> camp) {
                final int assignedVolunteers = _volunteers.where(
                  (Map<String, dynamic> volunteer) => volunteer['camp_id'] == camp['id'],
                ).length;
                final bool isActive = '${camp['status']}' == 'active';
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.neutral200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlueLight,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: const Icon(Icons.location_city_rounded, color: AppColors.primaryBlue, size: 20),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text('${camp['name']}', style: AppTextStyles.titleMedium),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isActive ? AppColors.successGreenLight : AppColors.neutral100,
                                    borderRadius: BorderRadius.circular(AppRadius.full),
                                  ),
                                  child: Text(
                                    isActive ? 'ACTIVE' : '${camp['status'] ?? 'UNKNOWN'}'.toUpperCase(),
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: isActive ? AppColors.successGreen : AppColors.neutral500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              '${camp['location']?['label'] ?? 'Unknown location'} · Zone ${camp['zone_id']}',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral500),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Row(
                              children: <Widget>[
                                const Icon(Icons.people_outline_rounded, size: 14, color: AppColors.neutral400),
                                const SizedBox(width: 4),
                                Text(
                                  'Occupancy ${camp['current_occupancy'] ?? 0}/${camp['capacity'] ?? 0}',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral500),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                const Icon(Icons.assignment_ind_outlined, size: 14, color: AppColors.neutral400),
                                const SizedBox(width: 4),
                                Text(
                                  '$assignedVolunteers assigned',
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral500),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
      ),
    );
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.neutral50,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.neutral200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.neutral200),
      ),
    );
  }

  Widget _buildFormRow(List<Widget> children) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .expand((Widget child) sync* {
            yield Expanded(child: child);
            if (child != children.last) {
              yield const SizedBox(width: AppSpacing.md);
            }
          })
          .toList(),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool required = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: required ? (String? value) => _requiredValidator(value, label) : null,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        filled: true,
        fillColor: AppColors.neutral50,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.neutral200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.neutral200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.dangerRed),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }

  List<String> _skillsFromText() {
    return _skillsController.text
        .split(',')
        .map((String item) => item.trim())
        .where((String item) => item.isNotEmpty)
        .toList();
  }

  Map<String, dynamic> _profileLocationPayload() {
    return <String, dynamic>{
      'label': _locationLabelController.text.trim(),
      'pincode': _pincodeController.text.trim().isEmpty ? null : _pincodeController.text.trim(),
      'lat': _profileLocation?.latitude,
      'lng': _profileLocation?.longitude,
    };
  }

  Map<String, dynamic> _needLocationPayload() {
    return <String, dynamic>{
      'label': _needLocationController.text.trim(),
      'pincode': _needPincodeController.text.trim().isEmpty ? null : _needPincodeController.text.trim(),
      'lat': _needLocation?.latitude,
      'lng': _needLocation?.longitude,
    };
  }

  Future<void> _captureProfileLocation() async {
    setState(() => _capturingProfileLocation = true);
    try {
      final CapturedLocation capturedLocation = await LocationService.getCurrentLocation();
      if (!mounted) return;
      setState(() {
        _profileLocation = capturedLocation;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile GPS location captured.')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = '$error');
    } finally {
      if (mounted) setState(() => _capturingProfileLocation = false);
    }
  }

  Future<void> _captureNeedLocation() async {
    setState(() => _capturingNeedLocation = true);
    try {
      final CapturedLocation capturedLocation = await LocationService.getCurrentLocation();
      if (!mounted) return;
      setState(() {
        _needLocation = capturedLocation;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Need GPS location captured.')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = '$error');
    } finally {
      if (mounted) setState(() => _capturingNeedLocation = false);
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _volunteerProfileId = prefs.getString(_volunteerProfileIdKey);

      final Response<Map<String, dynamic>> needsResponse = await _dio.get<Map<String, dynamic>>('/needs');
      final Response<Map<String, dynamic>> campsResponse = await _dio.get<Map<String, dynamic>>('/camps');
      final Response<Map<String, dynamic>> volunteersResponse = await _dio.get<Map<String, dynamic>>('/volunteers');

      final List<Map<String, dynamic>> volunteers =
          List<Map<String, dynamic>>.from(volunteersResponse.data?['data'] as List<dynamic>? ?? <dynamic>[]);
      if (_volunteerProfileId == null) {
        for (final Map<String, dynamic> volunteer in volunteers) {
          final String phone = '${volunteer['phone_number'] ?? ''}';
          final String whatsapp = '${volunteer['whatsapp_number'] ?? ''}';
          if (phone == widget.user.phone || whatsapp == widget.user.phone) {
            _volunteerProfileId = '${volunteer['id']}';
            await prefs.setString(_volunteerProfileIdKey, _volunteerProfileId!);
            break;
          }
        }
      }

      setState(() {
        _needs = List<Map<String, dynamic>>.from(needsResponse.data?['data'] as List<dynamic>? ?? <dynamic>[]);
        _camps = List<Map<String, dynamic>>.from(campsResponse.data?['data'] as List<dynamic>? ?? <dynamic>[]);
        _volunteers = volunteers;
      });

      final Map<String, dynamic>? profile = _profile;
      if (profile != null) {
        _nameController.text = '${profile['name'] ?? widget.user.name}';
        _whatsAppController.text = '${profile['whatsapp_number'] ?? widget.user.phone}';
        _alternateController.text = '${profile['alternate_number'] ?? ''}';
        _genderController.text = '${profile['gender'] ?? ''}';
        _qualificationController.text = '${profile['qualification'] ?? ''}';
        _designationController.text = '${profile['designation'] ?? ''}';
        _skillsController.text = (profile['skills'] as List<dynamic>? ?? <dynamic>[]).join(', ');
        _locationLabelController.text = '${profile['location']?['label'] ?? widget.user.zoneId}';
        _pincodeController.text = '${profile['location']?['pincode'] ?? ''}';
      }
    } on DioException catch (error) {
      setState(() {
        _error = error.message ?? 'Unable to load volunteer operations.';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _registerVolunteer() async {
    if (!_registrationFormKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final Response<Map<String, dynamic>> response = await _dio.post<Map<String, dynamic>>(
        '/volunteers',
        data: <String, dynamic>{
          'name': _nameController.text.trim(),
          'phone_number': widget.user.phone,
          'whatsapp_number': _whatsAppController.text.trim(),
          'alternate_number': _alternateController.text.trim().isEmpty ? null : _alternateController.text.trim(),
          'gender': _genderController.text.trim(),
          'qualification': _qualificationController.text.trim(),
          'designation': _designationController.text.trim(),
          'zone_id': widget.user.zoneId,
          'skills': _skillsFromText(),
          'notes': 'Registered from field app',
          'location': _profileLocationPayload(),
          'availability': true,
          'status': 'available',
        },
      );
      final String volunteerId = '${response.data?['data']?['id'] ?? ''}';
      if (volunteerId.isNotEmpty) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(_volunteerProfileIdKey, volunteerId);
        _volunteerProfileId = volunteerId;
      }
      await _load();
    } on DioException catch (error) {
      setState(() {
        _error = error.response?.data.toString() ?? error.message ?? 'Unable to register volunteer.';
      });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _updateProfile() async {
    if (_volunteerProfileId == null || !_profileFormKey.currentState!.validate()) return;
    setState(() {
      _updatingProfile = true;
      _error = null;
    });
    try {
      await _dio.patch<Map<String, dynamic>>(
        '/volunteers/$_volunteerProfileId',
        data: <String, dynamic>{
          'name': _nameController.text.trim(),
          'whatsapp_number': _whatsAppController.text.trim(),
          'alternate_number': _alternateController.text.trim().isEmpty ? null : _alternateController.text.trim(),
          'gender': _genderController.text.trim(),
          'qualification': _qualificationController.text.trim(),
          'designation': _designationController.text.trim(),
          'skills': _skillsFromText(),
          'location': _profileLocationPayload(),
          'notes': 'Updated from volunteer app',
        },
      );
      await _load();
    } on DioException catch (error) {
      setState(() {
        _error = error.response?.data.toString() ?? error.message ?? 'Unable to update profile.';
      });
    } finally {
      if (mounted) setState(() => _updatingProfile = false);
    }
  }

  Future<void> _postNeed() async {
    if (!_needFormKey.currentState!.validate()) return;
    setState(() {
      _postingNeed = true;
      _error = null;
    });
    try {
      await _dio.post<Map<String, dynamic>>(
        '/needs',
        data: <String, dynamic>{
          'title': _needTitleController.text.trim(),
          'description': _needDescriptionController.text.trim(),
          'need_type': _needType,
          'urgency': _needUrgency,
          'affected_count': int.tryParse(_needAffectedController.text.trim()) ?? 1,
          'source': 'APP',
          'location': _needLocationPayload(),
          'contact_info': <String, dynamic>{
            'name': _nameController.text.trim(),
            'phone': widget.user.phone,
            'notes': 'Raised from volunteer app',
          },
          'vulnerability_score': 0.7,
        },
      );
      _needTitleController.clear();
      _needDescriptionController.clear();
      _needLocationController.clear();
      _needPincodeController.clear();
      _needAffectedController.text = '1';
      _needLocation = null;
      await _load();
    } on DioException catch (error) {
      setState(() {
        _error = error.response?.data.toString() ?? error.message ?? 'Unable to post need.';
      });
    } finally {
      if (mounted) setState(() => _postingNeed = false);
    }
  }

  Future<void> _assignNeed(String needId) async {
    if (_volunteerProfileId == null) {
      setState(() {
        _error = 'Complete your volunteer profile before accepting needs.';
      });
      return;
    }
    if (_hasActiveAssignment) {
      setState(() {
        _error = 'You already have an active job. Complete it before taking another one.';
      });
      return;
    }
    try {
      await _dio.post<Map<String, dynamic>>(
        '/assign',
        data: <String, dynamic>{
          'need_id': needId,
          'volunteer_id': _volunteerProfileId,
        },
      );
      await _load();
    } on DioException catch (error) {
      setState(() {
        _error = error.response?.data.toString() ?? error.message ?? 'Unable to accept need.';
      });
    }
  }

  Future<void> _completeNeed(String needId) async {
    try {
      await _dio.patch<Map<String, dynamic>>(
        '/needs/$needId/status',
        data: <String, dynamic>{'status': 'completed'},
      );
      await _load();
    } on DioException catch (error) {
      setState(() {
        _error = error.response?.data.toString() ?? error.message ?? 'Unable to mark need completed.';
      });
    }
  }
}

// ---------------------------------------------------------------------------
// Supporting widgets
// ---------------------------------------------------------------------------

class _StatItem {
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({required this.items});

  final List<_StatItem> items;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items
          .map(
            (_StatItem item) => Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: item == items.last ? 0 : AppSpacing.sm,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.md,
                  horizontal: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.neutral200),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: item.bgColor,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Icon(item.icon, color: item.color, size: 18),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      item.value,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.neutral900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.neutral200),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(color: AppColors.neutral900),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral500),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(height: 1, color: AppColors.neutral100),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _GpsButton extends StatelessWidget {
  const _GpsButton({
    required this.capturing,
    required this.captured,
    required this.capturedLabel,
    required this.idleLabel,
    required this.loadingLabel,
    required this.capturedButtonLabel,
    required this.onTap,
  });

  final bool capturing;
  final bool captured;
  final String? capturedLabel;
  final String idleLabel;
  final String loadingLabel;
  final String capturedButtonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        OutlinedButton.icon(
          onPressed: capturing ? null : onTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: captured ? AppColors.successGreen : AppColors.primaryBlue,
            side: BorderSide(
              color: captured ? AppColors.successGreen : AppColors.primaryBlue,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
          ),
          icon: Icon(
            capturing
                ? Icons.gps_not_fixed_rounded
                : captured
                    ? Icons.gps_fixed_rounded
                    : Icons.my_location_rounded,
            size: 16,
          ),
          label: Text(
            capturing ? loadingLabel : captured ? capturedButtonLabel : idleLabel,
            style: AppTextStyles.labelMedium,
          ),
        ),
        if (capturedLabel != null) ...<Widget>[
          const SizedBox(height: AppSpacing.xs),
          Text(
            capturedLabel!,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral500),
          ),
        ],
      ],
    );
  }
}

class _NeedCard extends StatelessWidget {
  const _NeedCard({
    required this.need,
    required this.volunteerProfileId,
    required this.canAccept,
    required this.onAccept,
    required this.onComplete,
  });

  final Map<String, dynamic> need;
  final String? volunteerProfileId;
  final bool canAccept;
  final VoidCallback onAccept;
  final VoidCallback onComplete;

  Color _urgencyColor(String urgency) {
    switch (urgency) {
      case 'high':
        return AppColors.dangerRed;
      case 'medium':
        return AppColors.warningAmber;
      case 'low':
      default:
        return AppColors.successGreen;
    }
  }

  Color _urgencyBgColor(String urgency) {
    switch (urgency) {
      case 'high':
        return AppColors.dangerRedLight;
      case 'medium':
        return AppColors.warningAmberLight;
      case 'low':
      default:
        return AppColors.successGreenLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String status = '${need['status'] ?? 'pending'}';
    final String urgency = '${need['urgency'] ?? 'low'}';
    final bool assignedToMe = '${need['assigned_volunteer_id'] ?? ''}' == volunteerProfileId;
    final bool isOpen = status == 'pending';
    final bool isCompleted = status == 'completed';
    final Color urgencyColor = _urgencyColor(urgency);
    final Color urgencyBg = _urgencyBgColor(urgency);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isCompleted
              ? AppColors.neutral200
              : assignedToMe
                  ? AppColors.primaryBlue
                  : urgencyColor.withOpacity(0.4),
        ),
      ),
      child: Column(
        children: <Widget>[
          // Urgency accent bar
          if (!isCompleted)
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: urgencyColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${need['title'] ?? need['need_type'] ?? 'Need'}',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: isCompleted ? AppColors.neutral400 : AppColors.neutral900,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    if (!isCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: urgencyBg,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          urgency.toUpperCase(),
                          style: AppTextStyles.labelSmall.copyWith(color: urgencyColor),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.neutral100,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          'DONE',
                          style: AppTextStyles.labelSmall.copyWith(color: AppColors.neutral400),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${need['description'] ?? need['contact_info']?['notes'] ?? 'Operational request'}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isCompleted ? AppColors.neutral400 : AppColors.neutral600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: <Widget>[
                    const Icon(Icons.place_rounded, size: 12, color: AppColors.neutral400),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        '${need['location']?['label'] ?? 'Unknown'}',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral400),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(Icons.people_outline_rounded, size: 12, color: AppColors.neutral400),
                    const SizedBox(width: 3),
                    Text(
                      '${need['affected_count'] ?? 1} affected',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral400),
                    ),
                  ],
                ),
                if (!isCompleted) ...<Widget>[
                  const SizedBox(height: AppSpacing.md),
                  if (isOpen)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: canAccept ? AppColors.primaryBlue : AppColors.neutral100,
                          foregroundColor: canAccept ? AppColors.white : AppColors.neutral400,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                          elevation: 0,
                        ),
                        onPressed: canAccept ? onAccept : null,
                        icon: const Icon(Icons.task_alt_rounded, size: 16),
                        label: Text(
                          canAccept ? 'Accept This Need' : 'Finish active job first',
                          style: AppTextStyles.labelMedium,
                        ),
                      ),
                    )
                  else if (assignedToMe)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.successGreen,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                          elevation: 0,
                        ),
                        onPressed: onComplete,
                        icon: const Icon(Icons.check_circle_rounded, size: 16),
                        label: Text('Mark Completed', style: AppTextStyles.labelMedium),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.neutral400,
                          side: const BorderSide(color: AppColors.neutral200),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                        ),
                        onPressed: null,
                        icon: const Icon(Icons.assignment_ind_rounded, size: 16),
                        label: const Text('Assigned to another volunteer'),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhitePill extends StatelessWidget {
  const _WhitePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
      ),
    );
  }
}

class _UrgencyDot extends StatelessWidget {
  const _UrgencyDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Center(
        child: Column(
          children: <Widget>[
            Icon(icon, size: 36, color: AppColors.neutral300),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral400),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.primaryBlueLight,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(color: AppColors.primaryBlue),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.dangerRedLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.dangerRed.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(Icons.error_outline_rounded, color: AppColors.dangerRed, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.dangerRed),
            ),
          ),
        ],
      ),
    );
  }
}