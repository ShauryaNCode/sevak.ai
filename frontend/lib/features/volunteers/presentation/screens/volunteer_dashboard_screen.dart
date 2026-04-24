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
      backgroundColor: AppColors.neutral50,
      appBar: AppBar(
        title: const Text('Volunteer Operations'),
        actions: <Widget>[
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: <Widget>[
                if (_error != null) _ErrorBanner(message: _error!),
                _SummaryPanel(
                  title: 'Today',
                  items: <String, String>{
                    'Open needs': '${_needs.where((Map<String, dynamic> item) => '${item['status']}' != 'completed').length}',
                    'Active camps': '${_camps.where((Map<String, dynamic> item) => '${item['status']}' == 'active').length}',
                    'Available volunteers': '${_volunteers.where((Map<String, dynamic> item) => item['availability'] == true).length}',
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                if (_volunteerProfileId == null) _buildRegistrationCard() else ...<Widget>[
                  _buildVolunteerStatusCard(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildProfileUpdateCard(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildNewNeedCard(),
                ],
                const SizedBox(height: AppSpacing.lg),
                _buildNeedsSection(),
                const SizedBox(height: AppSpacing.lg),
                _buildCampsSection(),
              ],
            ),
    );
  }

  Widget _buildRegistrationCard() {
    return _SectionCard(
      title: 'Complete Your Volunteer Profile',
      subtitle: 'Your location is mandatory so the future heat map can still place you even when GPS is unavailable.',
      child: Form(
        key: _registrationFormKey,
        child: Column(
          children: <Widget>[
            _buildTextField(_nameController, 'Full name', required: true),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_whatsAppController, 'WhatsApp number', required: true),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_alternateController, 'Alternate number'),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_genderController, 'Gender', required: true),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_qualificationController, 'Qualification', required: true),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_designationController, 'Designation', required: true),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_skillsController, 'Skills (comma separated)'),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_locationLabelController, 'Location / locality', required: true),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_pincodeController, 'Pincode'),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: _capturingProfileLocation ? null : _captureProfileLocation,
                icon: const Icon(Icons.my_location_rounded),
                label: Text(
                  _capturingProfileLocation
                      ? 'Fetching GPS...'
                      : _profileLocation == null
                          ? 'Use GPS Location'
                          : 'GPS captured',
                ),
              ),
            ),
            if (_profileLocation != null) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'GPS ${_profileLocation!.latitude.toStringAsFixed(5)}, ${_profileLocation!.longitude.toStringAsFixed(5)}',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral600),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitting ? null : _registerVolunteer,
                icon: const Icon(Icons.app_registration_rounded),
                label: Text(_submitting ? 'Registering...' : 'Register Volunteer'),
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

    return _SectionCard(
      title: 'Your Volunteer Profile',
      subtitle: 'You can accept only one live need at a time. Completing a need updates your map position to the need location and removes your camp assignment until a manager checks you back in.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            profile == null ? widget.user.name : '${profile['name']}',
            style: AppTextStyles.titleLarge.copyWith(color: AppColors.neutral900),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              _Pill(label: 'ID ${_volunteerProfileId ?? '-'}'),
              _Pill(label: '${profile?['designation'] ?? 'Volunteer'}'),
              _Pill(label: '${profile?['qualification'] ?? 'General'}'),
              _Pill(label: _hasActiveAssignment ? 'On mission' : 'Available'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            camp == null ? 'Camp: Unassigned' : 'Camp: ${camp['name']}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral600),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Current location: ${profile?['location']?['label'] ?? widget.user.zoneId}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral600),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileUpdateCard() {
    return _SectionCard(
      title: 'Update Profile',
      subtitle: 'Keep your fallback location and contact details current so managers can place you correctly even when GPS fails.',
      child: Form(
        key: _profileFormKey,
        child: Column(
          children: <Widget>[
            _buildTextField(_nameController, 'Full name', required: true),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_whatsAppController, 'WhatsApp number', required: true),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_alternateController, 'Alternate number'),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_genderController, 'Gender', required: true),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_qualificationController, 'Qualification', required: true),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_designationController, 'Designation', required: true),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_skillsController, 'Skills (comma separated)'),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_locationLabelController, 'Fallback location', required: true),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_pincodeController, 'Pincode'),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: _capturingProfileLocation ? null : _captureProfileLocation,
                icon: const Icon(Icons.gps_fixed_rounded),
                label: Text(_capturingProfileLocation ? 'Refreshing GPS...' : 'Update with GPS'),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: _updatingProfile ? null : _updateProfile,
                icon: const Icon(Icons.save_rounded),
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
      subtitle: 'Volunteers can raise fresh needs from the field. GPS is preferred, but manual location remains the fallback.',
      child: Form(
        key: _needFormKey,
        child: Column(
          children: <Widget>[
            _buildTextField(_needTitleController, 'Need title', required: true),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_needDescriptionController, 'Description', required: true, maxLines: 3),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: <Widget>[
                SizedBox(
                  width: 180,
                  child: DropdownButtonFormField<String>(
                    value: _needType,
                    decoration: const InputDecoration(labelText: 'Need type'),
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
                SizedBox(
                  width: 180,
                  child: DropdownButtonFormField<String>(
                    value: _needUrgency,
                    decoration: const InputDecoration(labelText: 'Urgency'),
                    items: const <DropdownMenuItem<String>>[
                      DropdownMenuItem<String>(value: 'low', child: Text('Low')),
                      DropdownMenuItem<String>(value: 'medium', child: Text('Medium')),
                      DropdownMenuItem<String>(value: 'high', child: Text('High')),
                    ],
                    onChanged: (String? value) => setState(() => _needUrgency = value ?? 'medium'),
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: _buildTextField(_needAffectedController, 'Affected count', required: true),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_needLocationController, 'Location / locality', required: true),
            const SizedBox(height: AppSpacing.md),
            _buildTextField(_needPincodeController, 'Pincode'),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: _capturingNeedLocation ? null : _captureNeedLocation,
                icon: const Icon(Icons.location_searching_rounded),
                label: Text(
                  _capturingNeedLocation
                      ? 'Fetching GPS...'
                      : _needLocation == null
                          ? 'Use GPS For Need'
                          : 'Need GPS captured',
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: _postingNeed ? null : _postNeed,
                icon: const Icon(Icons.campaign_rounded),
                label: Text(_postingNeed ? 'Posting...' : 'Post Need'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeedsSection() {
    return _SectionCard(
      title: 'Live Requests',
      subtitle: 'Accept one open need at a time, then mark it completed once resolved.',
      child: Column(
        children: _needs.isEmpty
            ? <Widget>[
                Text(
                  'No open requests right now.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral600),
                ),
              ]
            : _needs.map((Map<String, dynamic> need) {
                final bool canAccept = !_hasActiveAssignment;
                return _NeedCard(
                  need: need,
                  volunteerProfileId: _volunteerProfileId,
                  canAccept: canAccept,
                  onAccept: () => _assignNeed('${need['id']}'),
                  onComplete: () => _completeNeed('${need['id']}'),
                );
              }).toList(),
      ),
    );
  }

  Widget _buildCampsSection() {
    return _SectionCard(
      title: 'Camp Visibility',
      subtitle: 'Camps remain your return points. Managers can check you back in, which sets your active location to the camp for the future map view.',
      child: Column(
        children: _camps.isEmpty
            ? <Widget>[
                Text(
                  'No camps have been created yet.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral600),
                ),
              ]
            : _camps.map((Map<String, dynamic> camp) {
                final int assignedVolunteers = _volunteers.where(
                  (Map<String, dynamic> volunteer) => volunteer['camp_id'] == camp['id'],
                ).length;
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.neutral50,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.neutral200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlueLight,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: const Icon(Icons.location_city_rounded, color: AppColors.primaryBlue),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('${camp['name']}', style: AppTextStyles.titleMedium),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              '${camp['location']?['label'] ?? 'Unknown location'} | ${camp['zone_id']}',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral600),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Occupancy ${camp['current_occupancy'] ?? 0}/${camp['capacity'] ?? 0} | Assigned volunteers $assignedVolunteers',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral500),
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
      decoration: InputDecoration(labelText: required ? '$label *' : label),
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
      if (!mounted) {
        return;
      }
      setState(() {
        _profileLocation = capturedLocation;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile GPS location captured.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _error = '$error');
    } finally {
      if (mounted) {
        setState(() => _capturingProfileLocation = false);
      }
    }
  }

  Future<void> _captureNeedLocation() async {
    setState(() => _capturingNeedLocation = true);
    try {
      final CapturedLocation capturedLocation = await LocationService.getCurrentLocation();
      if (!mounted) {
        return;
      }
      setState(() {
        _needLocation = capturedLocation;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Need GPS location captured.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _error = '$error');
    } finally {
      if (mounted) {
        setState(() => _capturingNeedLocation = false);
      }
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
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _registerVolunteer() async {
    if (!_registrationFormKey.currentState!.validate()) {
      return;
    }
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
      if (mounted) {
        setState(() {
          _submitting = false;
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_volunteerProfileId == null || !_profileFormKey.currentState!.validate()) {
      return;
    }
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
      if (mounted) {
        setState(() => _updatingProfile = false);
      }
    }
  }

  Future<void> _postNeed() async {
    if (!_needFormKey.currentState!.validate()) {
      return;
    }
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
      if (mounted) {
        setState(() => _postingNeed = false);
      }
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

  @override
  Widget build(BuildContext context) {
    final String status = '${need['status'] ?? 'pending'}';
    final bool assignedToMe = '${need['assigned_volunteer_id'] ?? ''}' == volunteerProfileId;
    final bool isOpen = status == 'pending';
    final bool isCompleted = status == 'completed';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${need['title'] ?? need['need_type'] ?? 'Need'}',
                  style: AppTextStyles.titleMedium.copyWith(color: AppColors.neutral900),
                ),
              ),
              _Pill(label: status.toUpperCase()),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${need['description'] ?? need['contact_info']?['notes'] ?? 'Operational request'}',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral600),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${need['location']?['label'] ?? 'Unknown location'} | urgency ${need['urgency'] ?? '-'} | affected ${need['affected_count'] ?? 1}',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral500),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              if (isOpen)
                ElevatedButton.icon(
                  onPressed: canAccept ? onAccept : null,
                  icon: const Icon(Icons.task_alt_rounded),
                  label: Text(canAccept ? 'Accept' : 'Finish active job first'),
                )
              else if (assignedToMe && !isCompleted)
                ElevatedButton.icon(
                  onPressed: onComplete,
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text('Mark Completed'),
                )
              else
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.visibility_rounded),
                  label: Text(isCompleted ? 'Completed' : 'Assigned'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: AppTextStyles.titleLarge.copyWith(color: AppColors.neutral900)),
            const SizedBox(height: AppSpacing.xs),
            Text(subtitle, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral600)),
            const SizedBox(height: AppSpacing.lg),
            child,
          ],
        ),
      ),
    );
  }
}

class _SummaryPanel extends StatelessWidget {
  const _SummaryPanel({
    required this.title,
    required this.items,
  });

  final String title;
  final Map<String, String> items;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: AppTextStyles.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: items.entries
                  .map(
                    (MapEntry<String, String> entry) => Container(
                      width: 180,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.neutral50,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.neutral200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(entry.value, style: AppTextStyles.displayMedium.copyWith(fontSize: 24)),
                          const SizedBox(height: AppSpacing.xs),
                          Text(entry.key, style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral500)),
                        ],
                      ),
                    ),
                  )
                  .toList(),
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
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.dangerRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.dangerRed.withOpacity(0.25)),
      ),
      child: Text(
        message,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.dangerRed),
      ),
    );
  }
}
