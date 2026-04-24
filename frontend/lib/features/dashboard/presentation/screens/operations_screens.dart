// C:\Users\th366\Desktop\sevakai\frontend\lib\features\dashboard\presentation\screens\operations_screens.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/route_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/authentication/domain/entities/auth_user.dart';
import '../../../../features/authentication/domain/entities/user_role.dart';
import '../../../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../services/location_service.dart';
import '../../../../sync/sync_bloc.dart';
import '../../../../ui/themes/app_colors.dart';
import '../../../../ui/themes/app_spacing.dart';
import '../../../../ui/themes/app_text_styles.dart';
import '../../../../ui/widgets/responsive_layout.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/top_header.dart';

class CoordinatorNeedsScreen extends StatelessWidget {
  const CoordinatorNeedsScreen({required this.user, super.key});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return _CoordinatorShell(
      user: user,
      title: 'Needs Management',
      child: _NeedsManagementBody(user: user),
    );
  }
}

class CoordinatorVolunteersScreen extends StatelessWidget {
  const CoordinatorVolunteersScreen({required this.user, super.key});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return _CoordinatorShell(
      user: user,
      title: 'Volunteer Management',
      child: _VolunteersManagementBody(user: user),
    );
  }
}

class CoordinatorResourcesScreen extends StatelessWidget {
  const CoordinatorResourcesScreen({required this.user, super.key});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return _CoordinatorShell(
      user: user,
      title: 'Camps & Capacity',
      child: _CampsManagementBody(user: user),
    );
  }
}

class CoordinatorMapScreen extends StatelessWidget {
  const CoordinatorMapScreen({required this.user, super.key});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return _CoordinatorShell(
      user: user,
      title: 'Map View',
      child: _MapOverviewBody(user: user),
    );
  }
}

class CoordinatorSettingsScreen extends StatelessWidget {
  const CoordinatorSettingsScreen({required this.user, super.key});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return _CoordinatorShell(
      user: user,
      title: 'Settings',
      child: _SettingsBody(user: user),
    );
  }
}

class _CoordinatorShell extends StatelessWidget {
  const _CoordinatorShell({
    required this.user,
    required this.title,
    required this.child,
  });

  final AuthUser user;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SyncBloc>(
      create: (_) => getIt<SyncBloc>()..add(const SyncEvent.started()),
      child: ResponsiveLayout(
        mobile: _MobileCoordinatorScaffold(title: title, child: child),
        tablet: _DesktopCoordinatorScaffold(
          user: user,
          title: title,
          child: child,
          tabletSidebar: true,
        ),
        desktop: _DesktopCoordinatorScaffold(
          user: user,
          title: title,
          child: child,
        ),
      ),
    );
  }
}

class _DesktopCoordinatorScaffold extends StatelessWidget {
  const _DesktopCoordinatorScaffold({
    required this.user,
    required this.title,
    required this.child,
    this.tabletSidebar = false,
  });

  final AuthUser user;
  final String title;
  final Widget child;
  final bool tabletSidebar;

  @override
  Widget build(BuildContext context) {
    final String currentRoute = GoRouterState.of(context).uri.path;
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      body: Row(
        children: <Widget>[
          SidebarNavigation(
            user: user,
            currentRoute: currentRoute,
            isTablet: tabletSidebar,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                TopHeader(
                  title: title,
                  user: user,
                  activeIncidentCount: 0,
                  isRefreshing: false,
                  onMenuPressed: tabletSidebar ? () {} : null,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileCoordinatorScaffold extends StatelessWidget {
  const _MobileCoordinatorScaffold({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      appBar: AppBar(title: Text(title)),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _mobileIndex(GoRouterState.of(context).uri.path),
        onTap: (int index) {
          const List<String> routes = <String>[
            AppRoutes.coordinatorDashboard,
            AppRoutes.coordinatorNeeds,
            AppRoutes.coordinatorVolunteers,
            AppRoutes.coordinatorResources,
          ];
          context.go(routes[index]);
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Overview'),
          BottomNavigationBarItem(icon: Icon(Icons.warning_amber_rounded), label: 'Needs'),
          BottomNavigationBarItem(icon: Icon(Icons.people_rounded), label: 'Volunteers'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_rounded), label: 'Camps'),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: child,
      ),
    );
  }

  int _mobileIndex(String route) {
    switch (route) {
      case AppRoutes.coordinatorNeeds:
        return 1;
      case AppRoutes.coordinatorVolunteers:
        return 2;
      case AppRoutes.coordinatorResources:
        return 3;
      case AppRoutes.coordinatorDashboard:
      default:
        return 0;
    }
  }
}

class _OperationsApi {
  _OperationsApi() : _dio = getIt<Dio>();

  final Dio _dio;

  Future<List<Map<String, dynamic>>> listNeeds() async {
    final Response<Map<String, dynamic>> response = await _dio.get<Map<String, dynamic>>('/needs');
    return List<Map<String, dynamic>>.from(response.data?['data'] as List<dynamic>? ?? <dynamic>[]);
  }

  Future<List<Map<String, dynamic>>> listVolunteers() async {
    final Response<Map<String, dynamic>> response = await _dio.get<Map<String, dynamic>>('/volunteers');
    return List<Map<String, dynamic>>.from(response.data?['data'] as List<dynamic>? ?? <dynamic>[]);
  }

  Future<List<Map<String, dynamic>>> listCamps() async {
    final Response<Map<String, dynamic>> response = await _dio.get<Map<String, dynamic>>('/camps');
    return List<Map<String, dynamic>>.from(response.data?['data'] as List<dynamic>? ?? <dynamic>[]);
  }

  Future<void> createVolunteer(Map<String, dynamic> payload) async {
    await _dio.post<Map<String, dynamic>>('/volunteers', data: payload);
  }

  Future<void> updateVolunteerRole(String volunteerId, String authRole) async {
    await _dio.patch<Map<String, dynamic>>(
      '/volunteers/$volunteerId/role',
      data: <String, dynamic>{'auth_role': authRole},
    );
  }

  Future<void> updateVolunteerCamp(String volunteerId, String? campId) async {
    await _dio.patch<Map<String, dynamic>>(
      '/volunteers/$volunteerId/camp',
      data: <String, dynamic>{'camp_id': campId},
    );
  }

  Future<void> createCamp(Map<String, dynamic> payload) async {
    await _dio.post<Map<String, dynamic>>('/camps', data: payload);
  }

  Future<void> updateCampManagers(String campId, List<Map<String, dynamic>> managers) async {
    await _dio.patch<Map<String, dynamic>>(
      '/camps/$campId/managers',
      data: <String, dynamic>{'managers': managers},
    );
  }

  Future<void> createNeed(Map<String, dynamic> payload) async {
    await _dio.post<Map<String, dynamic>>('/needs', data: payload);
  }

  Future<void> completeNeed(String needId) async {
    await _dio.patch<Map<String, dynamic>>(
      '/needs/$needId/status',
      data: <String, dynamic>{'status': 'completed'},
    );
  }
}

class _NeedsManagementBody extends StatefulWidget {
  const _NeedsManagementBody({required this.user});

  final AuthUser user;

  @override
  State<_NeedsManagementBody> createState() => _NeedsManagementBodyState();
}

class _NeedsManagementBodyState extends State<_NeedsManagementBody> {
  final _OperationsApi _api = _OperationsApi();
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _needs = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _camps = <Map<String, dynamic>>[];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _affectedController = TextEditingController(text: '1');
  String _needType = 'food';
  String _urgency = 'medium';
  String? _campId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _pincodeController.dispose();
    _affectedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (_error != null) _OperationsError(message: _error!),
        _SectionSurface(
          title: 'Create Need',
          subtitle: 'Coordinators can generate or log needs directly from camps and close them when resolved.',
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title'))),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: TextField(controller: _locationController, decoration: const InputDecoration(labelText: 'Location label'))),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  Expanded(child: TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description'))),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: TextField(controller: _pincodeController, decoration: const InputDecoration(labelText: 'Pincode'))),
                ],
              ),
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
                        DropdownMenuItem(value: 'food', child: Text('Food')),
                        DropdownMenuItem(value: 'water', child: Text('Water')),
                        DropdownMenuItem(value: 'medical', child: Text('Medical')),
                        DropdownMenuItem(value: 'shelter', child: Text('Shelter')),
                        DropdownMenuItem(value: 'rescue', child: Text('Rescue')),
                      ],
                      onChanged: (String? value) => setState(() => _needType = value ?? 'food'),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: DropdownButtonFormField<String>(
                      value: _urgency,
                      decoration: const InputDecoration(labelText: 'Urgency'),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(value: 'low', child: Text('Low')),
                        DropdownMenuItem(value: 'medium', child: Text('Medium')),
                        DropdownMenuItem(value: 'high', child: Text('High')),
                      ],
                      onChanged: (String? value) => setState(() => _urgency = value ?? 'medium'),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: DropdownButtonFormField<String?>(
                      value: _campId,
                      decoration: const InputDecoration(labelText: 'Camp'),
                      items: <DropdownMenuItem<String?>>[
                        const DropdownMenuItem<String?>(value: null, child: Text('None')),
                        ..._camps.map(
                          (Map<String, dynamic> camp) => DropdownMenuItem<String?>(
                            value: '${camp['id']}',
                            child: Text('${camp['name']}'),
                          ),
                        ),
                      ],
                      onChanged: (String? value) => setState(() => _campId = value),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: TextField(controller: _affectedController, decoration: const InputDecoration(labelText: 'Affected count')),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: _createNeed,
                  icon: const Icon(Icons.add_circle_rounded),
                  label: const Text('Create Need'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _SectionSurface(
          title: 'Open & Active Needs',
          subtitle: 'Mark requests completed as field teams resolve them.',
          child: _loading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Column(
                  children: _needs
                      .map(
                        (Map<String, dynamic> need) => _ManagementTile(
                          icon: Icons.warning_amber_rounded,
                          title: '${need['title'] ?? need['need_type']}',
                          subtitle:
                              '${need['location']?['label'] ?? 'Unknown location'} · ${need['urgency']} · ${need['status']}',
                          trailing: '${need['affected_count'] ?? 1} affected',
                          actionLabel: '${need['status']}' == 'completed' ? 'Completed' : 'Mark Done',
                          onAction: '${need['status']}' == 'completed' ? null : () => _completeNeed('${need['id']}'),
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final List<Map<String, dynamic>> needs = await _api.listNeeds();
      final List<Map<String, dynamic>> camps = await _api.listCamps();
      setState(() {
        _needs = needs;
        _camps = camps;
      });
    } on DioException catch (error) {
      setState(() => _error = error.message ?? 'Unable to load needs.');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _createNeed() async {
    try {
      await _api.createNeed(
        <String, dynamic>{
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'need_type': _needType,
          'urgency': _urgency,
          'camp_id': _campId,
          'affected_count': int.tryParse(_affectedController.text.trim()) ?? 1,
          'source': 'ADMIN',
          'location': <String, dynamic>{
            'label': _locationController.text.trim(),
            'pincode': _pincodeController.text.trim().isEmpty ? null : _pincodeController.text.trim(),
          },
          'contact_info': <String, dynamic>{
            'name': widget.user.name,
            'phone': widget.user.phone,
            'notes': _descriptionController.text.trim(),
          },
          'vulnerability_score': 0.6,
        },
      );
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _pincodeController.clear();
      _affectedController.text = '1';
      await _load();
    } on DioException catch (error) {
      setState(() => _error = error.response?.data.toString() ?? error.message ?? 'Unable to create need.');
    }
  }

  Future<void> _completeNeed(String needId) async {
    try {
      await _api.completeNeed(needId);
      await _load();
    } on DioException catch (error) {
      setState(() => _error = error.response?.data.toString() ?? error.message ?? 'Unable to complete need.');
    }
  }
}

class _VolunteersManagementBody extends StatefulWidget {
  const _VolunteersManagementBody({required this.user});

  final AuthUser user;

  @override
  State<_VolunteersManagementBody> createState() => _VolunteersManagementBodyState();
}

class _VolunteersManagementBodyState extends State<_VolunteersManagementBody> {
  final _OperationsApi _api = _OperationsApi();
  bool _loading = true;
  bool _updatingRole = false;
  String? _error;
  List<Map<String, dynamic>> _volunteers = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _camps = <Map<String, dynamic>>[];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _qualificationController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  String? _campId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _designationController.dispose();
    _qualificationController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (_error != null) _OperationsError(message: _error!),
        _SectionSurface(
          title: 'Add Volunteer Manually',
          subtitle: 'Admins can register volunteers directly without waiting for the volunteer-side flow.',
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full name'))),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone / WhatsApp'))),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  Expanded(child: TextField(controller: _designationController, decoration: const InputDecoration(labelText: 'Designation'))),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: TextField(controller: _qualificationController, decoration: const InputDecoration(labelText: 'Qualification'))),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  Expanded(child: TextField(controller: _skillsController, decoration: const InputDecoration(labelText: 'Skills (comma separated)'))),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DropdownButtonFormField<String?>(
                      value: _campId,
                      decoration: const InputDecoration(labelText: 'Camp'),
                      items: <DropdownMenuItem<String?>>[
                        const DropdownMenuItem<String?>(value: null, child: Text('Unassigned')),
                        ..._camps.map(
                          (Map<String, dynamic> camp) => DropdownMenuItem<String?>(
                            value: '${camp['id']}',
                            child: Text('${camp['name']}'),
                          ),
                        ),
                      ],
                      onChanged: (String? value) => setState(() => _campId = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: _createVolunteer,
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                  label: const Text('Add Volunteer'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _SectionSurface(
          title: 'Volunteer Roster',
          subtitle: 'Live roster across camps and designations.',
          child: _loading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Column(
                  children: _volunteers
                      .map(
                        (Map<String, dynamic> volunteer) => _ManagementTile(
                          icon: Icons.people_rounded,
                          title: '${volunteer['name']}',
                          subtitle:
                              '${volunteer['designation'] ?? 'Volunteer'} · ${volunteer['qualification'] ?? 'General'} · ${volunteer['camp_id'] ?? 'Unassigned'}',
                          trailing: '${volunteer['status'] ?? 'available'} | ${volunteer['auth_role'] ?? 'VOLUNTEER'}',
                          actionLabel: _updatingRole ? 'Updating...' : 'Manage',
                          onAction: _updatingRole ? null : () => _showRoleDialog(volunteer),
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final List<Map<String, dynamic>> volunteers = await _api.listVolunteers();
      final List<Map<String, dynamic>> camps = await _api.listCamps();
      setState(() {
        _volunteers = volunteers;
        _camps = camps;
      });
    } on DioException catch (error) {
      setState(() => _error = error.message ?? 'Unable to load volunteers.');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Map<String, dynamic>? get _selectedCamp {
    for (final Map<String, dynamic> camp in _camps) {
      if ('${camp['id']}' == _campId) {
        return camp;
      }
    }
    return null;
  }

  Future<void> _createVolunteer() async {
    try {
      final Map<String, dynamic>? selectedCamp = _selectedCamp;
      await _api.createVolunteer(
        <String, dynamic>{
          'name': _nameController.text.trim(),
          'phone_number': _phoneController.text.trim(),
          'whatsapp_number': _phoneController.text.trim(),
          'qualification': _qualificationController.text.trim().isEmpty ? 'General' : _qualificationController.text.trim(),
          'designation': _designationController.text.trim().isEmpty ? 'Volunteer' : _designationController.text.trim(),
          'zone_id': widget.user.zoneId,
          'camp_id': _campId,
          'auth_role': 'VOLUNTEER',
          'skills': _skillsController.text
              .split(',')
              .map((String item) => item.trim())
              .where((String item) => item.isNotEmpty)
              .toList(),
          'location': selectedCamp == null
              ? <String, dynamic>{'label': widget.user.zoneId}
              : <String, dynamic>{
                  'label': '${selectedCamp['location']?['label'] ?? widget.user.zoneId}',
                  'pincode': selectedCamp['location']?['pincode'],
                  'lat': selectedCamp['location']?['lat'],
                  'lng': selectedCamp['location']?['lng'],
                },
          'availability': true,
          'status': 'available',
        },
      );
      _nameController.clear();
      _phoneController.clear();
      _designationController.clear();
      _qualificationController.clear();
      _skillsController.clear();
      _campId = null;
      await _load();
    } on DioException catch (error) {
      setState(() => _error = error.response?.data.toString() ?? error.message ?? 'Unable to create volunteer.');
    }
  }

  Future<void> _showRoleDialog(Map<String, dynamic> volunteer) async {
    final String currentRole = '${volunteer['auth_role'] ?? 'VOLUNTEER'}';
    final String? currentCampId = volunteer['camp_id'] == null ? null : '${volunteer['camp_id']}';
    final Map<String, String>? result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        String selectedRole = currentRole;
        String? selectedCampId = currentCampId;
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setModalState) {
            return AlertDialog(
              title: Text('Manage ${volunteer['name']}'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: const InputDecoration(labelText: 'Access role'),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(value: 'VOLUNTEER', child: Text('Volunteer')),
                        DropdownMenuItem<String>(value: 'ZONE_COORDINATOR', child: Text('Zone Coordinator')),
                        DropdownMenuItem<String>(value: 'DISTRICT_ADMIN', child: Text('District Admin')),
                        DropdownMenuItem<String>(value: 'NATIONAL_ADMIN', child: Text('National Admin')),
                      ],
                      onChanged: (String? value) {
                        if (value != null) {
                          setModalState(() => selectedRole = value);
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DropdownButtonFormField<String?>(
                      value: selectedCampId,
                      decoration: const InputDecoration(labelText: 'Camp assignment'),
                      items: <DropdownMenuItem<String?>>[
                        const DropdownMenuItem<String?>(value: null, child: Text('Unassigned')),
                        ..._camps.map(
                          (Map<String, dynamic> camp) => DropdownMenuItem<String?>(
                            value: '${camp['id']}',
                            child: Text('${camp['name']}'),
                          ),
                        ),
                      ],
                      onChanged: (String? value) => setModalState(() => selectedCampId = value),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Camp assignment sets the volunteer default location to the camp. Volunteers with an active assigned need cannot be moved until that need is completed.',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral600),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(
                    <String, String>{
                      'role': selectedRole,
                      'campId': selectedCampId ?? '',
                    },
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null) {
      return;
    }
    final String nextRole = result['role'] ?? currentRole;
    final String? nextCampId = (result['campId'] ?? '').isEmpty ? null : result['campId'];
    if (nextRole == currentRole && nextCampId == currentCampId) {
      return;
    }

    setState(() {
      _updatingRole = true;
      _error = null;
    });
    try {
      if (nextRole != currentRole) {
        await _api.updateVolunteerRole('${volunteer['id']}', nextRole);
      }
      if (nextCampId != currentCampId) {
        await _api.updateVolunteerCamp('${volunteer['id']}', nextCampId);
      }
      await _load();
    } on DioException catch (error) {
      setState(() {
        _error = error.response?.data.toString() ?? error.message ?? 'Unable to update volunteer assignment.';
      });
    } finally {
      if (mounted) {
        setState(() => _updatingRole = false);
      }
    }
  }
}

class _CampsManagementBody extends StatefulWidget {
  const _CampsManagementBody({required this.user});

  final AuthUser user;

  @override
  State<_CampsManagementBody> createState() => _CampsManagementBodyState();
}

class _CampsManagementBodyState extends State<_CampsManagementBody> {
  final _OperationsApi _api = _OperationsApi();
  bool _loading = true;
  bool _capturingLocation = false;
  String? _error;
  List<Map<String, dynamic>> _camps = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _volunteers = <Map<String, dynamic>>[];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController(text: '100');
  final Set<String> _selectedManagerIds = <String>{};
  bool _includeSelfAsManager = true;
  CapturedLocation? _campLocation;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _pincodeController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (_error != null) _OperationsError(message: _error!),
        _SectionSurface(
          title: 'Create Camp',
          subtitle: 'Set up camps that volunteers can be mapped to, choose multiple camp managers, and capture GPS for future map accuracy.',
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Camp name'))),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: TextField(controller: _locationController, decoration: const InputDecoration(labelText: 'Location label'))),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  Expanded(child: TextField(controller: _pincodeController, decoration: const InputDecoration(labelText: 'Pincode'))),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: TextField(controller: _capacityController, decoration: const InputDecoration(labelText: 'Capacity'))),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerLeft,
                child: OutlinedButton.icon(
                  onPressed: _capturingLocation ? null : _captureCampLocation,
                  icon: const Icon(Icons.my_location_rounded),
                  label: Text(
                    _capturingLocation
                        ? 'Fetching GPS...'
                        : _campLocation == null
                            ? 'Use GPS Location'
                            : 'GPS captured',
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              CheckboxListTile(
                value: _includeSelfAsManager,
                contentPadding: EdgeInsets.zero,
                title: const Text('Add me as camp manager'),
                subtitle: Text('${widget.user.name} | ${widget.user.role.displayName}'),
                onChanged: (bool? value) => setState(() => _includeSelfAsManager = value ?? false),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Volunteer managers',
                  style: AppTextStyles.labelLarge.copyWith(color: AppColors.neutral600),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _volunteers.map((Map<String, dynamic> volunteer) {
                  final String volunteerId = '${volunteer['id']}';
                  return FilterChip(
                    selected: _selectedManagerIds.contains(volunteerId),
                    label: Text('${volunteer['name']}'),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedManagerIds.add(volunteerId);
                        } else {
                          _selectedManagerIds.remove(volunteerId);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.lg),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton.icon(
                  onPressed: _createCamp,
                  icon: const Icon(Icons.add_business_rounded),
                  label: const Text('Create Camp'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _SectionSurface(
          title: 'Camp Directory',
          subtitle: 'Operational camp view for occupancy, managers, and zone coverage.',
          child: _loading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Column(
                  children: _camps
                      .map(
                        (Map<String, dynamic> camp) => _ManagementTile(
                          icon: Icons.location_city_rounded,
                          title: '${camp['name']}',
                          subtitle:
                              '${camp['location']?['label'] ?? 'Unknown location'} · ${camp['zone_id']} · ${camp['status']}',
                          trailing: '${camp['current_occupancy'] ?? 0}/${camp['capacity'] ?? 0}',
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final List<Map<String, dynamic>> camps = await _api.listCamps();
      final List<Map<String, dynamic>> volunteers = await _api.listVolunteers();
      setState(() {
        _camps = camps;
        _volunteers = volunteers;
      });
    } on DioException catch (error) {
      setState(() => _error = error.message ?? 'Unable to load camps.');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _captureCampLocation() async {
    setState(() => _capturingLocation = true);
    try {
      final CapturedLocation capturedLocation = await LocationService.getCurrentLocation();
      if (!mounted) {
        return;
      }
      setState(() => _campLocation = capturedLocation);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camp GPS location captured.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _error = '$error');
    } finally {
      if (mounted) {
        setState(() => _capturingLocation = false);
      }
    }
  }

  List<Map<String, dynamic>> _selectedManagers() {
    return _selectedManagerIds.map((String managerId) {
      final Map<String, dynamic> volunteer = _volunteers.firstWhere(
        (Map<String, dynamic> item) => '${item['id']}' == managerId,
      );
      return <String, dynamic>{
        'volunteer_id': managerId,
        'name': '${volunteer['name']}',
        'phone': volunteer['phone_number'] ?? volunteer['whatsapp_number'],
        'role_label': '${volunteer['designation'] ?? 'Volunteer'}',
      };
    }).toList();
  }

  Future<void> _createCamp() async {
    try {
      final List<Map<String, dynamic>> managers = <Map<String, dynamic>>[
        if (_includeSelfAsManager)
          <String, dynamic>{
            'name': widget.user.name,
            'phone': widget.user.phone,
            'role_label': widget.user.role.displayName,
          },
        ..._selectedManagers(),
      ];
      await _api.createCamp(
        <String, dynamic>{
          'name': _nameController.text.trim(),
          'zone_id': widget.user.zoneId,
          'location': <String, dynamic>{
            'label': _locationController.text.trim(),
            'pincode': _pincodeController.text.trim().isEmpty ? null : _pincodeController.text.trim(),
            'lat': _campLocation?.latitude,
            'lng': _campLocation?.longitude,
          },
          'capacity': int.tryParse(_capacityController.text.trim()) ?? 0,
          'current_occupancy': 0,
          'status': 'active',
          'manager_name': managers.isEmpty ? null : managers.first['name'],
          'manager_phone': managers.isEmpty ? null : managers.first['phone'],
          'managers': managers,
        },
      );
      _nameController.clear();
      _locationController.clear();
      _pincodeController.clear();
      _capacityController.text = '100';
      _selectedManagerIds.clear();
      _includeSelfAsManager = true;
      _campLocation = null;
      await _load();
    } on DioException catch (error) {
      setState(() => _error = error.response?.data.toString() ?? error.message ?? 'Unable to create camp.');
    }
  }
}

class _MapOverviewBody extends StatefulWidget {
  const _MapOverviewBody({required this.user});

  final AuthUser user;

  @override
  State<_MapOverviewBody> createState() => _MapOverviewBodyState();
}

class _MapOverviewBodyState extends State<_MapOverviewBody> {
  final _OperationsApi _api = _OperationsApi();
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _camps = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> _volunteers = <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (_error != null) _OperationsError(message: _error!),
        _SectionSurface(
          title: 'Operational Map Snapshot',
          subtitle: 'A simple location board for now. We can swap this for a real map widget once the data model stabilizes.',
          child: _loading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Column(
                  children: _camps.map((Map<String, dynamic> camp) {
                    final List<Map<String, dynamic>> campVolunteers = _volunteers
                        .where((Map<String, dynamic> volunteer) => volunteer['camp_id'] == camp['id'])
                        .toList();
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
                              const Icon(Icons.map_rounded, color: AppColors.primaryBlue),
                              const SizedBox(width: AppSpacing.sm),
                              Text('${camp['name']}', style: AppTextStyles.titleMedium),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '${camp['location']?['label'] ?? 'Unknown location'} · lat ${camp['location']?['lat'] ?? '-'} · lng ${camp['location']?['lng'] ?? '-'}',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral600),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Volunteers routed here: ${campVolunteers.length}',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral500),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final List<Map<String, dynamic>> camps = await _api.listCamps();
      final List<Map<String, dynamic>> volunteers = await _api.listVolunteers();
      setState(() {
        _camps = camps;
        _volunteers = volunteers;
      });
    } on DioException catch (error) {
      setState(() => _error = error.message ?? 'Unable to load map overview.');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    return _SectionSurface(
      title: 'Operational Context',
      subtitle: 'Simple control panel for the current hackathon build.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Signed in as ${user.name}', style: AppTextStyles.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text('Role: ${user.role.displayName}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral600)),
          const SizedBox(height: AppSpacing.sm),
          Text('Zone: ${user.zoneId}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral600)),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: () => context.read<AuthBloc>().add(const AuthEvent.logoutRequested()),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _SectionSurface extends StatelessWidget {
  const _SectionSurface({
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

class _ManagementTile extends StatelessWidget {
  const _ManagementTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryBlueLight,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: AppColors.primaryBlue),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: AppTextStyles.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(subtitle, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.neutral600)),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(trailing, style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutral500)),
              if (actionLabel != null) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
                ElevatedButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _OperationsError extends StatelessWidget {
  const _OperationsError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.dangerRedLight,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.dangerRed),
      ),
      child: Text(
        message,
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.dangerRed),
      ),
    );
  }
}
