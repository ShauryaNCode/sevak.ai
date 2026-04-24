// C:\Users\th366\Desktop\sevakai\frontend\lib\features\volunteers\presentation\screens\volunteer_dashboard_screen.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/injection.dart';
import '../../../../features/authentication/domain/entities/auth_user.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _whatsAppController = TextEditingController();
  final TextEditingController _alternateController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _locationLabelController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  bool _loading = true;
  bool _submitting = false;
  String? _error;
  String? _volunteerProfileId;
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
    super.dispose();
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
                if (_volunteerProfileId == null)
                  _buildRegistrationCard()
                else
                  _buildVolunteerStatusCard(),
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
      subtitle: 'Register once so you can accept requests and be mapped to a camp.',
      child: Column(
        children: <Widget>[
          _buildTextField(_nameController, 'Full name'),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(_whatsAppController, 'WhatsApp number'),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(_alternateController, 'Alternate number'),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(_genderController, 'Gender'),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(_qualificationController, 'Qualification'),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(_designationController, 'Designation'),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(_skillsController, 'Skills (comma separated)'),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(_locationLabelController, 'Location / locality'),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(_pincodeController, 'Pincode'),
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
    );
  }

  Widget _buildVolunteerStatusCard() {
    Map<String, dynamic>? profile;
    for (final Map<String, dynamic> volunteer in _volunteers) {
      if ('${volunteer['id']}' == _volunteerProfileId) {
        profile = volunteer;
        break;
      }
    }

    return _SectionCard(
      title: 'Your Volunteer Profile',
      subtitle: 'You can now accept open needs and mark them completed.',
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNeedsSection() {
    return _SectionCard(
      title: 'Live Requests',
      subtitle: 'Accept a need to take ownership, then mark it completed once resolved.',
      child: Column(
        children: _needs.isEmpty
            ? <Widget>[
                Text(
                  'No open requests right now.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral600),
                ),
              ]
            : _needs.map((Map<String, dynamic> need) => _NeedCard(
                  need: need,
                  volunteerProfileId: _volunteerProfileId,
                  onAccept: () => _assignNeed('${need['id']}'),
                  onComplete: () => _completeNeed('${need['id']}'),
                )).toList(),
      ),
    );
  }

  Widget _buildCampsSection() {
    return _SectionCard(
      title: 'Camp Visibility',
      subtitle: 'Mocked live updates for now. This gives volunteers clear camp destinations and location context.',
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
                              '${camp['location']?['label'] ?? 'Unknown location'} · ${camp['zone_id']}',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral600),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Occupancy ${camp['current_occupancy'] ?? 0}/${camp['capacity'] ?? 0} · Assigned volunteers $assignedVolunteers',
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

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
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

      setState(() {
        _needs = List<Map<String, dynamic>>.from(needsResponse.data?['data'] as List<dynamic>? ?? <dynamic>[]);
        _camps = List<Map<String, dynamic>>.from(campsResponse.data?['data'] as List<dynamic>? ?? <dynamic>[]);
        _volunteers = List<Map<String, dynamic>>.from(volunteersResponse.data?['data'] as List<dynamic>? ?? <dynamic>[]);
      });
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
          'gender': _genderController.text.trim().isEmpty ? null : _genderController.text.trim(),
          'qualification': _qualificationController.text.trim().isEmpty ? 'General' : _qualificationController.text.trim(),
          'designation': _designationController.text.trim().isEmpty ? 'Volunteer' : _designationController.text.trim(),
          'zone_id': widget.user.zoneId,
          'skills': _skillsController.text
              .split(',')
              .map((String item) => item.trim())
              .where((String item) => item.isNotEmpty)
              .toList(),
          'notes': 'Registered from field app',
          'location': <String, dynamic>{
            'label': _locationLabelController.text.trim().isEmpty ? widget.user.zoneId : _locationLabelController.text.trim(),
            'pincode': _pincodeController.text.trim().isEmpty ? null : _pincodeController.text.trim(),
          },
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

  Future<void> _assignNeed(String needId) async {
    if (_volunteerProfileId == null) {
      setState(() {
        _error = 'Complete your volunteer profile before accepting needs.';
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
    required this.onAccept,
    required this.onComplete,
  });

  final Map<String, dynamic> need;
  final String? volunteerProfileId;
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
            '${need['location']?['label'] ?? 'Unknown location'} · urgency ${need['urgency'] ?? '-'} · affected ${need['affected_count'] ?? 1}',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral500),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              if (isOpen)
                ElevatedButton.icon(
                  onPressed: onAccept,
                  icon: const Icon(Icons.task_alt_rounded),
                  label: const Text('Accept'),
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
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.dangerRedLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.dangerRed),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.error_outline_rounded, color: AppColors.dangerRed),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.dangerRed),
            ),
          ),
        ],
      ),
    );
  }
}
