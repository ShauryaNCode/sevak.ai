// C:\Users\th366\Desktop\sevakai\frontend\lib\features\dashboard\presentation\screens\operations_screens.dart
import 'dart:math' as math;

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
  const _MobileCoordinatorScaffold({required this.title, required this.child});

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
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_rounded),
            label: 'Needs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded),
            label: 'Volunteers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_rounded),
            label: 'Camps',
          ),
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
    final Response<Map<String, dynamic>> response =
        await _dio.get<Map<String, dynamic>>('/needs');
    return List<Map<String, dynamic>>.from(
      response.data?['data'] as List<dynamic>? ?? <dynamic>[],
    );
  }

  Future<List<Map<String, dynamic>>> listVolunteers() async {
    final Response<Map<String, dynamic>> response =
        await _dio.get<Map<String, dynamic>>('/volunteers');
    return List<Map<String, dynamic>>.from(
      response.data?['data'] as List<dynamic>? ?? <dynamic>[],
    );
  }

  Future<List<Map<String, dynamic>>> listCamps() async {
    final Response<Map<String, dynamic>> response =
        await _dio.get<Map<String, dynamic>>('/camps');
    return List<Map<String, dynamic>>.from(
      response.data?['data'] as List<dynamic>? ?? <dynamic>[],
    );
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

  Future<void> updateCampManagers(
    String campId,
    List<Map<String, dynamic>> managers,
  ) async {
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
  final TextEditingController _affectedController = TextEditingController(
    text: '1',
  );
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
          subtitle:
              'Coordinators can generate or log needs directly from camps and close them when resolved.',
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location label',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: _pincodeController,
                      decoration: const InputDecoration(labelText: 'Pincode'),
                    ),
                  ),
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
                        DropdownMenuItem(
                          value: 'medical',
                          child: Text('Medical'),
                        ),
                        DropdownMenuItem(
                          value: 'shelter',
                          child: Text('Shelter'),
                        ),
                        DropdownMenuItem(
                          value: 'rescue',
                          child: Text('Rescue'),
                        ),
                      ],
                      onChanged: (String? value) =>
                          setState(() => _needType = value ?? 'food'),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: DropdownButtonFormField<String>(
                      value: _urgency,
                      decoration: const InputDecoration(labelText: 'Urgency'),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(value: 'low', child: Text('Low')),
                        DropdownMenuItem(
                          value: 'medium',
                          child: Text('Medium'),
                        ),
                        DropdownMenuItem(value: 'high', child: Text('High')),
                      ],
                      onChanged: (String? value) =>
                          setState(() => _urgency = value ?? 'medium'),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: DropdownButtonFormField<String?>(
                      value: _campId,
                      decoration: const InputDecoration(labelText: 'Camp'),
                      items: <DropdownMenuItem<String?>>[
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('None'),
                        ),
                        ..._camps.map(
                          (Map<String, dynamic> camp) =>
                              DropdownMenuItem<String?>(
                            value: '${camp['id']}',
                            child: Text('${camp['name']}'),
                          ),
                        ),
                      ],
                      onChanged: (String? value) =>
                          setState(() => _campId = value),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: TextField(
                      controller: _affectedController,
                      decoration: const InputDecoration(
                        labelText: 'Affected count',
                      ),
                    ),
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
                          actionLabel: '${need['status']}' == 'completed'
                              ? 'Completed'
                              : 'Mark Done',
                          onAction: '${need['status']}' == 'completed'
                              ? null
                              : () => _completeNeed('${need['id']}'),
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
      await _api.createNeed(<String, dynamic>{
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'need_type': _needType,
        'urgency': _urgency,
        'camp_id': _campId,
        'affected_count': int.tryParse(_affectedController.text.trim()) ?? 1,
        'source': 'ADMIN',
        'location': <String, dynamic>{
          'label': _locationController.text.trim(),
          'pincode': _pincodeController.text.trim().isEmpty
              ? null
              : _pincodeController.text.trim(),
        },
        'contact_info': <String, dynamic>{
          'name': widget.user.name,
          'phone': widget.user.phone,
          'notes': _descriptionController.text.trim(),
        },
        'vulnerability_score': 0.6,
      });
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _pincodeController.clear();
      _affectedController.text = '1';
      await _load();
    } on DioException catch (error) {
      setState(
        () => _error = error.response?.data.toString() ??
            error.message ??
            'Unable to create need.',
      );
    }
  }

  Future<void> _completeNeed(String needId) async {
    try {
      await _api.completeNeed(needId);
      await _load();
    } on DioException catch (error) {
      setState(
        () => _error = error.response?.data.toString() ??
            error.message ??
            'Unable to complete need.',
      );
    }
  }
}

class _VolunteersManagementBody extends StatefulWidget {
  const _VolunteersManagementBody({required this.user});

  final AuthUser user;

  @override
  State<_VolunteersManagementBody> createState() =>
      _VolunteersManagementBodyState();
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
  final TextEditingController _qualificationController =
      TextEditingController();
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
          subtitle:
              'Admins can register volunteers directly without waiting for the volunteer-side flow.',
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full name'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone / WhatsApp',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _designationController,
                      decoration: const InputDecoration(
                        labelText: 'Designation',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: _qualificationController,
                      decoration: const InputDecoration(
                        labelText: 'Qualification',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _skillsController,
                      decoration: const InputDecoration(
                        labelText: 'Skills (comma separated)',
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: DropdownButtonFormField<String?>(
                      value: _campId,
                      decoration: const InputDecoration(labelText: 'Camp'),
                      items: <DropdownMenuItem<String?>>[
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Unassigned'),
                        ),
                        ..._camps.map(
                          (Map<String, dynamic> camp) =>
                              DropdownMenuItem<String?>(
                            value: '${camp['id']}',
                            child: Text('${camp['name']}'),
                          ),
                        ),
                      ],
                      onChanged: (String? value) =>
                          setState(() => _campId = value),
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
                          trailing:
                              '${volunteer['status'] ?? 'available'} | ${volunteer['auth_role'] ?? 'VOLUNTEER'}',
                          actionLabel: _updatingRole ? 'Updating...' : 'Manage',
                          onAction: _updatingRole
                              ? null
                              : () => _showRoleDialog(volunteer),
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
      await _api.createVolunteer(<String, dynamic>{
        'name': _nameController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'whatsapp_number': _phoneController.text.trim(),
        'qualification': _qualificationController.text.trim().isEmpty
            ? 'General'
            : _qualificationController.text.trim(),
        'designation': _designationController.text.trim().isEmpty
            ? 'Volunteer'
            : _designationController.text.trim(),
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
                'label':
                    '${selectedCamp['location']?['label'] ?? widget.user.zoneId}',
                'pincode': selectedCamp['location']?['pincode'],
                'lat': selectedCamp['location']?['lat'],
                'lng': selectedCamp['location']?['lng'],
              },
        'availability': true,
        'status': 'available',
      });
      _nameController.clear();
      _phoneController.clear();
      _designationController.clear();
      _qualificationController.clear();
      _skillsController.clear();
      _campId = null;
      await _load();
    } on DioException catch (error) {
      setState(
        () => _error = error.response?.data.toString() ??
            error.message ??
            'Unable to create volunteer.',
      );
    }
  }

  Future<void> _showRoleDialog(Map<String, dynamic> volunteer) async {
    final String currentRole = '${volunteer['auth_role'] ?? 'VOLUNTEER'}';
    final String? currentCampId =
        volunteer['camp_id'] == null ? null : '${volunteer['camp_id']}';
    final Map<String, String>? result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        String selectedRole = currentRole;
        String? selectedCampId = currentCampId;
        return StatefulBuilder(
          builder: (
            BuildContext context,
            void Function(void Function()) setModalState,
          ) {
            return AlertDialog(
              title: Text('Manage ${volunteer['name']}'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: const InputDecoration(
                        labelText: 'Access role',
                      ),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          value: 'VOLUNTEER',
                          child: Text('Volunteer'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'ZONE_COORDINATOR',
                          child: Text('Zone Coordinator'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'DISTRICT_ADMIN',
                          child: Text('District Admin'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'NATIONAL_ADMIN',
                          child: Text('National Admin'),
                        ),
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
                      decoration: const InputDecoration(
                        labelText: 'Camp assignment',
                      ),
                      items: <DropdownMenuItem<String?>>[
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Unassigned'),
                        ),
                        ..._camps.map(
                          (Map<String, dynamic> camp) =>
                              DropdownMenuItem<String?>(
                            value: '${camp['id']}',
                            child: Text('${camp['name']}'),
                          ),
                        ),
                      ],
                      onChanged: (String? value) =>
                          setModalState(() => selectedCampId = value),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Camp assignment sets the volunteer default location to the camp. Volunteers with an active assigned need cannot be moved until that need is completed.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutral600,
                      ),
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
                  onPressed: () => Navigator.of(context).pop(<String, String>{
                    'role': selectedRole,
                    'campId': selectedCampId ?? '',
                  }),
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
    final String? nextCampId =
        (result['campId'] ?? '').isEmpty ? null : result['campId'];
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
        _error = error.response?.data.toString() ??
            error.message ??
            'Unable to update volunteer assignment.';
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
  final TextEditingController _capacityController = TextEditingController(
    text: '100',
  );
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
          subtitle:
              'Set up camps that volunteers can be mapped to, choose multiple camp managers, and capture GPS for future map accuracy.',
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Camp name'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location label',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _pincodeController,
                      decoration: const InputDecoration(labelText: 'Pincode'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextField(
                      controller: _capacityController,
                      decoration: const InputDecoration(labelText: 'Capacity'),
                    ),
                  ),
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
                subtitle: Text(
                  '${widget.user.name} | ${widget.user.role.displayName}',
                ),
                onChanged: (bool? value) =>
                    setState(() => _includeSelfAsManager = value ?? false),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Volunteer managers',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.neutral600,
                  ),
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
          subtitle:
              'Operational camp view for occupancy, managers, and zone coverage.',
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
                          trailing:
                              '${camp['current_occupancy'] ?? 0}/${camp['capacity'] ?? 0}',
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
      final CapturedLocation capturedLocation =
          await LocationService.getCurrentLocation();
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
      await _api.createCamp(<String, dynamic>{
        'name': _nameController.text.trim(),
        'zone_id': widget.user.zoneId,
        'location': <String, dynamic>{
          'label': _locationController.text.trim(),
          'pincode': _pincodeController.text.trim().isEmpty
              ? null
              : _pincodeController.text.trim(),
          'lat': _campLocation?.latitude,
          'lng': _campLocation?.longitude,
        },
        'capacity': int.tryParse(_capacityController.text.trim()) ?? 0,
        'current_occupancy': 0,
        'status': 'active',
        'manager_name': managers.isEmpty ? null : managers.first['name'],
        'manager_phone': managers.isEmpty ? null : managers.first['phone'],
        'managers': managers,
      });
      _nameController.clear();
      _locationController.clear();
      _pincodeController.clear();
      _capacityController.text = '100';
      _selectedManagerIds.clear();
      _includeSelfAsManager = true;
      _campLocation = null;
      await _load();
    } on DioException catch (error) {
      setState(
        () => _error = error.response?.data.toString() ??
            error.message ??
            'Unable to create camp.',
      );
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
          title: 'Volunteer Heat Map',
          subtitle:
              'Live volunteer coverage built from stored volunteer location, camp assignment, manager access, and active need status.',
          child: _loading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : _VolunteerHeatMapBoard(camps: _camps, volunteers: _volunteers),
        ),
      ],
    );

    /* return Column(
      children: <Widget>[
        if (_error != null) _OperationsError(message: _error!),
        _SectionSurface(
          title: 'Operational Map Snapshot',
          subtitle:
              'A simple location board for now. We can swap this for a real map widget once the data model stabilizes.',
          child: _loading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Column(
                  children: _camps.map((Map<String, dynamic> camp) {
                    final List<Map<String, dynamic>> campVolunteers =
                        _volunteers
                            .where(
                              (Map<String, dynamic> volunteer) =>
                                  volunteer['camp_id'] == camp['id'],
                            )
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
                              const Icon(
                                Icons.map_rounded,
                                color: AppColors.primaryBlue,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                '${camp['name']}',
                                style: AppTextStyles.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '${camp['location']?['label'] ?? 'Unknown location'} · lat ${camp['location']?['lat'] ?? '-'} · lng ${camp['location']?['lng'] ?? '-'}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.neutral600,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Volunteers routed here: ${campVolunteers.length}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.neutral500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    ); */
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

class _VolunteerHeatMapBoard extends StatelessWidget {
  const _VolunteerHeatMapBoard({required this.camps, required this.volunteers});

  final List<Map<String, dynamic>> camps;
  final List<Map<String, dynamic>> volunteers;

  @override
  Widget build(BuildContext context) {
    final List<_VolunteerMapPoint> volunteerPoints = _buildVolunteerPoints();
    final List<_CampMapPin> campPins = _buildCampPins();
    final _MapViewport viewport = _MapViewport.fromData(
      volunteerPoints,
      campPins,
    );
    final List<_VolunteerHeatCluster> clusters = _buildClusters(
      volunteerPoints,
      viewport,
    );
    final int missingCoordinates = volunteers.length - volunteerPoints.length;
    final int activeAssignments =
        volunteerPoints.where((point) => point.hasActiveAssignment).length;
    final int managersVisible =
        volunteerPoints.where((point) => point.isManager).length;
    final int campAnchored = volunteerPoints
        .where((point) => point.campName != null && point.campName!.isNotEmpty)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: <Widget>[
            _MapMetricChip(
              label: 'Mapped volunteers',
              value: '${volunteerPoints.length}',
              icon: Icons.people_alt_rounded,
              color: AppColors.successGreen,
            ),
            _MapMetricChip(
              label: 'Active assignments',
              value: '$activeAssignments',
              icon: Icons.assignment_turned_in_rounded,
              color: AppColors.warningAmber,
            ),
            _MapMetricChip(
              label: 'Managers visible',
              value: '$managersVisible',
              icon: Icons.admin_panel_settings_rounded,
              color: AppColors.primaryBlue,
            ),
            _MapMetricChip(
              label: 'Camp anchored',
              value: '$campAnchored',
              icon: Icons.cabin_rounded,
              color: AppColors.neutral600,
            ),
            _MapMetricChip(
              label: 'Missing coordinates',
              value: '$missingCoordinates',
              icon: Icons.location_off_rounded,
              color: missingCoordinates == 0
                  ? AppColors.successGreen
                  : AppColors.dangerRed,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildHeatSurface(
          viewport: viewport,
          clusters: clusters,
          campPins: campPins,
          volunteerCount: volunteerPoints.length,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: const <Widget>[
            _MapLegendChip(
              color: AppColors.successGreen,
              label: 'Available volunteers',
            ),
            _MapLegendChip(
              color: AppColors.warningAmber,
              label: 'Volunteers on active needs',
            ),
            _MapLegendChip(
              color: AppColors.primaryBlue,
              label: 'Camp managers',
            ),
            _MapLegendChip(color: AppColors.neutral400, label: 'Camp pins'),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth < 980) {
              return Column(
                children: <Widget>[
                  _buildHotspotsPanel(clusters: clusters, viewport: viewport),
                  const SizedBox(height: AppSpacing.md),
                  _buildCoveragePanel(
                    campPins: campPins,
                    missingCoordinates: missingCoordinates,
                  ),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: _buildHotspotsPanel(
                    clusters: clusters,
                    viewport: viewport,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildCoveragePanel(
                    campPins: campPins,
                    missingCoordinates: missingCoordinates,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeatSurface({
    required _MapViewport viewport,
    required List<_VolunteerHeatCluster> clusters,
    required List<_CampMapPin> campPins,
    required int volunteerCount,
  }) {
    if (volunteerCount == 0 && campPins.isEmpty) {
      return const _MapEmptyPanel(
        icon: Icons.location_searching_rounded,
        title: 'No mappable operations yet',
        message:
            'Volunteer fallback locations or camp coordinates need latitude and longitude before this view can render.',
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double height = math.max(
          280,
          math.min(420, constraints.maxWidth * 0.52),
        );
        return Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xFF0F172A), Color(0xFF1D4ED8)],
            ),
            boxShadow: AppShadows.md,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CustomPaint(
                    painter: _VolunteerHeatMapPainter(
                      viewport: viewport,
                      clusters: clusters,
                      campPins: campPins,
                    ),
                  ),
                ),
                Positioned(
                  left: AppSpacing.md,
                  top: AppSpacing.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.22),
                      ),
                    ),
                    child: Text(
                      '${clusters.length} hotspot${clusters.length == 1 ? '' : 's'} · ${campPins.length} camp${campPins.length == 1 ? '' : 's'}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHotspotsPanel({
    required List<_VolunteerHeatCluster> clusters,
    required _MapViewport viewport,
  }) {
    if (clusters.isEmpty) {
      return const _MapInfoPanel(
        title: 'Volunteer hotspots',
        subtitle: 'No volunteers have usable coordinates yet.',
        child: _MapEmptyPanel(
          icon: Icons.people_outline_rounded,
          title: 'Waiting for volunteer coordinates',
          message:
              'As volunteers register or get placed into camps, their latest stored coordinates will appear here.',
        ),
      );
    }

    return _MapInfoPanel(
      title: 'Volunteer hotspots',
      subtitle:
          'Largest clusters are grouped from the current volunteer coordinates.',
      child: Column(
        children: clusters.take(5).map((_VolunteerHeatCluster cluster) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.neutral50,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.neutral200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: cluster.displayColor.withOpacity(0.14),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${cluster.count}',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: cluster.displayColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(cluster.title, style: AppTextStyles.titleMedium),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${cluster.count} volunteer${cluster.count == 1 ? '' : 's'} · ${cluster.activeCount} active · ${cluster.managerCount} manager${cluster.managerCount == 1 ? '' : 's'}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.neutral600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Lat ${cluster.latitude.toStringAsFixed(4)} · Lng ${cluster.longitude.toStringAsFixed(4)} · Zone ${viewport.zoneLabel(cluster.latitude, cluster.longitude)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.neutral500,
                        ),
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

  Widget _buildCoveragePanel({
    required List<_CampMapPin> campPins,
    required int missingCoordinates,
  }) {
    return _MapInfoPanel(
      title: 'Camp coverage',
      subtitle: 'Camp coordinates anchor volunteer routing and manager access.',
      child: Column(
        children: <Widget>[
          if (campPins.isEmpty)
            const _MapEmptyPanel(
              icon: Icons.cabin_outlined,
              title: 'No camps are pinned yet',
              message:
                  'Create camps with coordinates to see how volunteers spread around each operational base.',
            )
          else
            ...campPins.map((_CampMapPin campPin) {
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.neutral50,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.neutral200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.cabin_rounded,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            campPin.name,
                            style: AppTextStyles.titleMedium,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlueLight,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            '${campPin.memberCount} routed',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primaryBlueDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      campPin.locationLabel,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutral600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: <Widget>[
                        _MapLegendChip(
                          color: AppColors.primaryBlue,
                          label:
                              '${campPin.managerCount} manager${campPin.managerCount == 1 ? '' : 's'}',
                        ),
                        _MapLegendChip(
                          color: AppColors.warningAmber,
                          label:
                              '${campPin.activeAssignments} active task${campPin.activeAssignments == 1 ? '' : 's'}',
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          if (missingCoordinates > 0) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.warningAmberLight,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(
                  color: AppColors.warningAmber.withOpacity(0.32),
                ),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.location_off_rounded,
                    color: AppColors.warningAmber,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      '$missingCoordinates volunteer${missingCoordinates == 1 ? '' : 's'} still have no map coordinates. They will stay off the heat map until their fallback location or GPS point includes lat/lng.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutral800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<_VolunteerMapPoint> _buildVolunteerPoints() {
    final Map<String, Map<String, dynamic>> campsById =
        <String, Map<String, dynamic>>{
      for (final Map<String, dynamic> camp in camps)
        if ('${camp['id'] ?? ''}'.trim().isNotEmpty) '${camp['id']}': camp,
    };
    final Set<String> managerVolunteerIds = <String>{};
    final Set<String> managerPhones = <String>{};

    for (final Map<String, dynamic> camp in camps) {
      final Iterable<dynamic> managers = camp['managers'] is Iterable
          ? camp['managers'] as Iterable<dynamic>
          : const <dynamic>[];
      for (final dynamic manager in managers) {
        if (manager is! Map) {
          continue;
        }
        final String volunteerId = '${manager['volunteer_id'] ?? ''}'.trim();
        if (volunteerId.isNotEmpty) {
          managerVolunteerIds.add(volunteerId);
        }
        final String? phone = _normalizePhone(manager['phone']);
        if (phone != null) {
          managerPhones.add(phone);
        }
      }
    }

    final List<_VolunteerMapPoint> points = <_VolunteerMapPoint>[];
    for (final Map<String, dynamic> volunteer in volunteers) {
      final dynamic locationRaw = volunteer['location'];
      if (locationRaw is! Map) {
        continue;
      }
      final double? latitude = _toDouble(locationRaw['lat']);
      final double? longitude = _toDouble(locationRaw['lng']);
      if (latitude == null || longitude == null) {
        continue;
      }

      final String id = '${volunteer['id'] ?? ''}'.trim();
      final String? normalizedPhone = _normalizePhone(
        volunteer['phone_number'] ?? volunteer['whatsapp_number'],
      );
      final String locationLabel = '${locationRaw['label'] ?? ''}'.trim();
      final String? campName = _campNameForVolunteer(volunteer, campsById);

      points.add(
        _VolunteerMapPoint(
          latitude: latitude,
          longitude: longitude,
          locationLabel: locationLabel.isEmpty
              ? 'Pinned volunteer location'
              : locationLabel,
          campName: campName,
          isManager: (id.isNotEmpty && managerVolunteerIds.contains(id)) ||
              (normalizedPhone != null &&
                  managerPhones.contains(normalizedPhone)),
          hasActiveAssignment:
              '${volunteer['current_assignment_need_id'] ?? ''}'
                  .trim()
                  .isNotEmpty,
        ),
      );
    }
    return points;
  }

  List<_CampMapPin> _buildCampPins() {
    final Map<String, int> volunteerCounts = <String, int>{};
    final Map<String, int> activeCounts = <String, int>{};
    for (final Map<String, dynamic> volunteer in volunteers) {
      final String campId = '${volunteer['camp_id'] ?? ''}'.trim();
      if (campId.isEmpty) {
        continue;
      }
      volunteerCounts[campId] = (volunteerCounts[campId] ?? 0) + 1;
      if ('${volunteer['current_assignment_need_id'] ?? ''}'
          .trim()
          .isNotEmpty) {
        activeCounts[campId] = (activeCounts[campId] ?? 0) + 1;
      }
    }

    final List<_CampMapPin> pins = <_CampMapPin>[];
    for (final Map<String, dynamic> camp in camps) {
      final dynamic locationRaw = camp['location'];
      if (locationRaw is! Map) {
        continue;
      }
      final double? latitude = _toDouble(locationRaw['lat']);
      final double? longitude = _toDouble(locationRaw['lng']);
      if (latitude == null || longitude == null) {
        continue;
      }
      final Iterable<dynamic> managers = camp['managers'] is Iterable
          ? camp['managers'] as Iterable<dynamic>
          : const <dynamic>[];
      final String campId = '${camp['id'] ?? ''}'.trim();
      pins.add(
        _CampMapPin(
          name: '${camp['name'] ?? 'Camp'}'.trim(),
          locationLabel:
              '${locationRaw['label'] ?? 'Pinned camp location'}'.trim(),
          latitude: latitude,
          longitude: longitude,
          memberCount: volunteerCounts[campId] ?? 0,
          managerCount: managers.length,
          activeAssignments: activeCounts[campId] ?? 0,
        ),
      );
    }
    pins.sort((a, b) => b.memberCount.compareTo(a.memberCount));
    return pins;
  }

  List<_VolunteerHeatCluster> _buildClusters(
    List<_VolunteerMapPoint> points,
    _MapViewport viewport,
  ) {
    if (points.isEmpty) {
      return <_VolunteerHeatCluster>[];
    }

    final Map<String, List<_VolunteerMapPoint>> buckets =
        <String, List<_VolunteerMapPoint>>{};
    for (final _VolunteerMapPoint point in points) {
      final int bucketX = (viewport.x(point.longitude) * 7).floor().clamp(0, 7);
      final int bucketY = (viewport.y(point.latitude) * 4).floor().clamp(0, 4);
      final String key = '$bucketX:$bucketY';
      buckets.putIfAbsent(key, () => <_VolunteerMapPoint>[]).add(point);
    }

    final List<_VolunteerHeatCluster> clusters = buckets.values.map((
      List<_VolunteerMapPoint> members,
    ) {
      final double latitude =
          members.map((point) => point.latitude).reduce((a, b) => a + b) /
              members.length;
      final double longitude =
          members.map((point) => point.longitude).reduce((a, b) => a + b) /
              members.length;
      return _VolunteerHeatCluster(
        latitude: latitude,
        longitude: longitude,
        members: members,
      );
    }).toList();
    clusters.sort((a, b) => b.count.compareTo(a.count));
    return clusters;
  }

  double? _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.trim());
    }
    return null;
  }

  String? _normalizePhone(dynamic value) {
    if (value == null) {
      return null;
    }
    final String raw = value.toString().trim();
    if (raw.isEmpty) {
      return null;
    }
    final bool hasPlus = raw.startsWith('+');
    final String digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return null;
    }
    return hasPlus ? '+$digits' : digits;
  }

  String? _campNameForVolunteer(
    Map<String, dynamic> volunteer,
    Map<String, Map<String, dynamic>> campsById,
  ) {
    final String campId = '${volunteer['camp_id'] ?? ''}'.trim();
    if (campId.isNotEmpty) {
      final Map<String, dynamic>? camp = campsById[campId];
      if (camp != null) {
        final String campName = '${camp['name'] ?? ''}'.trim();
        if (campName.isNotEmpty) {
          return campName;
        }
      }
    }

    final dynamic locationRaw = volunteer['location'];
    if (locationRaw is Map) {
      final String locationLabel = '${locationRaw['label'] ?? ''}'.trim();
      if (locationLabel.isNotEmpty) {
        return locationLabel;
      }
    }

    return null;
  }
}

class _VolunteerMapPoint {
  const _VolunteerMapPoint({
    required this.latitude,
    required this.longitude,
    required this.locationLabel,
    required this.campName,
    required this.isManager,
    required this.hasActiveAssignment,
  });

  final double latitude;
  final double longitude;
  final String locationLabel;
  final String? campName;
  final bool isManager;
  final bool hasActiveAssignment;
}

class _CampMapPin {
  const _CampMapPin({
    required this.name,
    required this.locationLabel,
    required this.latitude,
    required this.longitude,
    required this.memberCount,
    required this.managerCount,
    required this.activeAssignments,
  });

  final String name;
  final String locationLabel;
  final double latitude;
  final double longitude;
  final int memberCount;
  final int managerCount;
  final int activeAssignments;
}

class _VolunteerHeatCluster {
  const _VolunteerHeatCluster({
    required this.latitude,
    required this.longitude,
    required this.members,
  });

  final double latitude;
  final double longitude;
  final List<_VolunteerMapPoint> members;

  int get count => members.length;
  int get activeCount =>
      members.where((member) => member.hasActiveAssignment).length;
  int get managerCount => members.where((member) => member.isManager).length;

  Color get displayColor {
    if (activeCount > 0) {
      return AppColors.warningAmber;
    }
    if (managerCount > 0) {
      return AppColors.primaryBlue;
    }
    return AppColors.successGreen;
  }

  String get title {
    final Map<String, int> labels = <String, int>{};
    for (final _VolunteerMapPoint member in members) {
      final String label = (member.campName ?? member.locationLabel).trim();
      if (label.isEmpty) {
        continue;
      }
      labels[label] = (labels[label] ?? 0) + 1;
    }
    if (labels.isEmpty) {
      return 'Volunteer cluster';
    }
    final List<MapEntry<String, int>> sorted = labels.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }
}

class _MapViewport {
  const _MapViewport({
    required this.minLatitude,
    required this.maxLatitude,
    required this.minLongitude,
    required this.maxLongitude,
  });

  final double minLatitude;
  final double maxLatitude;
  final double minLongitude;
  final double maxLongitude;

  double get latitudeSpan => math.max(maxLatitude - minLatitude, 0.001);
  double get longitudeSpan => math.max(maxLongitude - minLongitude, 0.001);

  factory _MapViewport.fromData(
    List<_VolunteerMapPoint> points,
    List<_CampMapPin> campPins,
  ) {
    final List<double> latitudes = <double>[
      ...points.map((point) => point.latitude),
      ...campPins.map((pin) => pin.latitude),
    ];
    final List<double> longitudes = <double>[
      ...points.map((point) => point.longitude),
      ...campPins.map((pin) => pin.longitude),
    ];

    if (latitudes.isEmpty || longitudes.isEmpty) {
      return const _MapViewport(
        minLatitude: 17.0,
        maxLatitude: 18.2,
        minLongitude: 73.7,
        maxLongitude: 75.1,
      );
    }

    double minLat = latitudes.reduce(math.min);
    double maxLat = latitudes.reduce(math.max);
    double minLng = longitudes.reduce(math.min);
    double maxLng = longitudes.reduce(math.max);
    final double latPad = math.max((maxLat - minLat).abs() * 0.14, 0.02);
    final double lngPad = math.max((maxLng - minLng).abs() * 0.14, 0.02);

    minLat -= latPad;
    maxLat += latPad;
    minLng -= lngPad;
    maxLng += lngPad;

    return _MapViewport(
      minLatitude: minLat,
      maxLatitude: maxLat,
      minLongitude: minLng,
      maxLongitude: maxLng,
    );
  }

  double x(double longitude) =>
      ((longitude - minLongitude) / longitudeSpan).clamp(0.0, 1.0);
  double y(double latitude) =>
      (1 - ((latitude - minLatitude) / latitudeSpan)).clamp(0.0, 1.0);

  String zoneLabel(double latitude, double longitude) {
    final String ns =
        latitude >= (minLatitude + maxLatitude) / 2 ? 'North' : 'South';
    final String ew =
        longitude >= (minLongitude + maxLongitude) / 2 ? 'East' : 'West';
    return '$ns-$ew';
  }
}

class _VolunteerHeatMapPainter extends CustomPainter {
  const _VolunteerHeatMapPainter({
    required this.viewport,
    required this.clusters,
    required this.campPins,
  });

  final _MapViewport viewport;
  final List<_VolunteerHeatCluster> clusters;
  final List<_CampMapPin> campPins;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = AppColors.white.withOpacity(0.08)
      ..strokeWidth = 1;

    for (int i = 1; i < 6; i++) {
      final double dx = size.width * (i / 6);
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), gridPaint);
    }
    for (int i = 1; i < 4; i++) {
      final double dy = size.height * (i / 4);
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), gridPaint);
    }

    for (final _CampMapPin pin in campPins) {
      final Offset center = Offset(
        viewport.x(pin.longitude) * size.width,
        viewport.y(pin.latitude) * size.height,
      );
      final Path diamond = Path()
        ..moveTo(center.dx, center.dy - 10)
        ..lineTo(center.dx + 10, center.dy)
        ..lineTo(center.dx, center.dy + 10)
        ..lineTo(center.dx - 10, center.dy)
        ..close();
      canvas.drawPath(
        diamond,
        Paint()..color = AppColors.white.withOpacity(0.82),
      );
      canvas.drawPath(
        diamond,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = AppColors.neutral900.withOpacity(0.15),
      );
    }

    for (final _VolunteerHeatCluster cluster in clusters) {
      final Offset center = Offset(
        viewport.x(cluster.longitude) * size.width,
        viewport.y(cluster.latitude) * size.height,
      );
      final double radius = 18 + (cluster.count * 4.0).clamp(0, 28);
      final Color color = cluster.displayColor;

      canvas.drawCircle(
        center,
        radius * 1.45,
        Paint()
          ..color = color.withOpacity(0.16)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
      );
      canvas.drawCircle(
        center,
        radius,
        Paint()..color = color.withOpacity(0.78),
      );
      canvas.drawCircle(
        center,
        radius * 0.58,
        Paint()..color = AppColors.white.withOpacity(0.28),
      );

      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: '${cluster.count}',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(
          center.dx - (textPainter.width / 2),
          center.dy - (textPainter.height / 2),
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VolunteerHeatMapPainter oldDelegate) {
    return oldDelegate.viewport != viewport ||
        oldDelegate.clusters != clusters ||
        oldDelegate.campPins != campPins;
  }
}

class _MapMetricChip extends StatelessWidget {
  const _MapMetricChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 170),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                value,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.neutral600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapLegendChip extends StatelessWidget {
  const _MapLegendChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.neutral600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapInfoPanel extends StatelessWidget {
  const _MapInfoPanel({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: AppTextStyles.titleLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _MapEmptyPanel extends StatelessWidget {
  const _MapEmptyPanel({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, size: 34, color: AppColors.neutral500),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: AppTextStyles.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral600,
            ),
          ),
        ],
      ),
    );
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
          Text(
            'Role: ${user.role.displayName}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Zone: ${user.zoneId}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.neutral600,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthEvent.logoutRequested()),
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
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.neutral100,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutral600,
              ),
            ),
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
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.neutral900,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.neutral600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                trailing,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.neutral500,
                ),
              ),
              if (actionLabel != null) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
                ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
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
