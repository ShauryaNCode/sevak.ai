// C:\Users\th366\Desktop\sevakai\frontend\lib\features\dashboard\presentation\widgets\needs_data_table.dart
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/need_summary.dart';
import '../bloc/dashboard_bloc.dart';
import '../../../../ui/themes/app_colors.dart';
import '../../../../ui/themes/app_spacing.dart';
import '../../../../ui/themes/app_text_styles.dart';

/// Paginated, sortable needs table for coordinator operations.
class NeedsDataTable extends StatefulWidget {
  /// Creates the needs table.
  const NeedsDataTable({
    required this.needs,
    required this.statusFilter,
    required this.priorityFilter,
    this.isLoading = false,
    super.key,
  });

  /// Rows to display.
  final List<NeedSummary> needs;

  /// Active status filter.
  final String? statusFilter;

  /// Active priority filter.
  final int? priorityFilter;

  /// Whether to show loading placeholders.
  final bool isLoading;

  @override
  State<NeedsDataTable> createState() => _NeedsDataTableState();
}

class _NeedsDataTableState extends State<NeedsDataTable> {
  Timer? _minuteTimer;
  final Set<String> _selectedIds = <String>{};
  int _sortColumnIndex = 0;
  bool _sortAscending = false;

  @override
  void initState() {
    super.initState();
    _minuteTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _minuteTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoadingTable();
    }
    if (widget.needs.isEmpty) {
      return _buildEmptyState();
    }

    final List<NeedSummary> sortedNeeds = _sortNeeds(widget.needs);
    final _NeedsTableSource source = _NeedsTableSource(
      context: context,
      needs: sortedNeeds,
      selectedIds: _selectedIds,
      onSelectionChanged: (String id, bool selected) {
        setState(() {
          if (selected) {
            _selectedIds.add(id);
          } else {
            _selectedIds.remove(id);
          }
        });
      },
      onAssignRequested: _showAssignDialog,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Row(
              children: <Widget>[
                Text(
                  'RECENT NEEDS',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.neutral500,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                if (_selectedIds.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => _showAssignDialog(_selectedIds.first),
                    icon: const Icon(Icons.group_add_rounded),
                    label: Text('Assign selected (${_selectedIds.length})'),
                  ),
              ],
            ),
          ),
          PaginatedDataTable(
            source: source,
            header: const SizedBox.shrink(),
            rowsPerPage: 25,
            showFirstLastButtons: true,
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            showCheckboxColumn: true,
            columns: <DataColumn>[
              DataColumn(
                label: _buildPriorityHeader(context),
                onSort: (_, __) => _setSort(0),
              ),
              DataColumn(
                label: _headerLabel('ID'),
                onSort: (_, __) => _setSort(1),
              ),
              DataColumn(label: _headerLabel('Type(s)')),
              DataColumn(label: _headerLabel('Location')),
              DataColumn(
                numeric: true,
                label: _headerLabel('Affected'),
                onSort: (_, __) => _setSort(4),
              ),
              DataColumn(label: _headerLabel('Source')),
              DataColumn(label: _buildStatusHeader(context)),
              DataColumn(label: _headerLabel('Age')),
              DataColumn(label: _headerLabel('Assigned')),
              DataColumn(label: _headerLabel('Actions')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingTable() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.neutral200),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: List<Widget>.generate(
          5,
          (int index) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              children: List<Widget>.generate(
                5,
                (int innerIndex) => Expanded(
                  child: Container(
                    height: 18,
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.neutral100,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.neutral200),
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            const Icon(
              Icons.inbox_rounded,
              size: 48,
              color: AppColors.neutral400,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No needs match your filters',
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.neutral800),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () {
                context.read<DashboardBloc>().add(
                      const DashboardEvent.filterChanged(),
                    );
              },
              child: const Text('Clear filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _headerLabel('Status'),
        const SizedBox(width: AppSpacing.xs),
        DropdownButton<String?>(
          value: widget.statusFilter,
          underline: const SizedBox.shrink(),
          borderRadius: BorderRadius.circular(AppRadius.md),
          items: const <DropdownMenuItem<String?>>[
            DropdownMenuItem<String?>(value: null, child: Text('All')),
            DropdownMenuItem<String?>(value: 'OPEN', child: Text('OPEN')),
            DropdownMenuItem<String?>(value: 'ASSIGNED', child: Text('ASSIGNED')),
            DropdownMenuItem<String?>(value: 'IN_PROGRESS', child: Text('IN_PROGRESS')),
            DropdownMenuItem<String?>(value: 'FULFILLED', child: Text('FULFILLED')),
          ],
          onChanged: (String? value) {
            context.read<DashboardBloc>().add(
                  DashboardEvent.filterChanged(
                    statusFilter: value,
                    priorityFilter: widget.priorityFilter,
                  ),
                );
          },
        ),
      ],
    );
  }

  Widget _buildPriorityHeader(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _headerLabel('Priority'),
        const SizedBox(width: AppSpacing.xs),
        DropdownButton<int?>(
          value: widget.priorityFilter,
          underline: const SizedBox.shrink(),
          borderRadius: BorderRadius.circular(AppRadius.md),
          items: const <DropdownMenuItem<int?>>[
            DropdownMenuItem<int?>(value: null, child: Text('All')),
            DropdownMenuItem<int?>(value: 5, child: Text('5')),
            DropdownMenuItem<int?>(value: 4, child: Text('4')),
            DropdownMenuItem<int?>(value: 3, child: Text('3')),
            DropdownMenuItem<int?>(value: 2, child: Text('2')),
            DropdownMenuItem<int?>(value: 1, child: Text('1')),
          ],
          onChanged: (int? value) {
            context.read<DashboardBloc>().add(
                  DashboardEvent.filterChanged(
                    statusFilter: widget.statusFilter,
                    priorityFilter: value,
                  ),
                );
          },
        ),
      ],
    );
  }

  Widget _headerLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: AppTextStyles.labelMedium.copyWith(
        color: AppColors.neutral500,
        letterSpacing: 0.5,
      ),
    );
  }

  List<NeedSummary> _sortNeeds(List<NeedSummary> needs) {
    final List<NeedSummary> sorted = List<NeedSummary>.from(needs);
    switch (_sortColumnIndex) {
      case 1:
        sorted.sort((NeedSummary a, NeedSummary b) => a.id.compareTo(b.id));
        break;
      case 4:
        sorted.sort(
          (NeedSummary a, NeedSummary b) =>
              a.affectedCount.compareTo(b.affectedCount),
        );
        break;
      case 0:
      default:
        sorted.sort(
          (NeedSummary a, NeedSummary b) => b.priority.compareTo(a.priority),
        );
        break;
    }
    if (_sortAscending) {
      return sorted.reversed.toList();
    }
    return sorted;
  }

  void _setSort(int columnIndex) {
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumnIndex = columnIndex;
        _sortAscending = false;
      }
    });
  }

  Future<void> _showAssignDialog(String needId) async {
    final String? selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => _VolunteerPickerDialog(needId: needId),
    );
    if (!mounted || selected == null) {
      return;
    }
    context.read<DashboardBloc>().add(
          DashboardEvent.volunteerAssigned(
            needId: needId,
            volunteerId: selected,
          ),
        );
  }
}

class _NeedsTableSource extends DataTableSource {
  _NeedsTableSource({
    required this.context,
    required this.needs,
    required this.selectedIds,
    required this.onSelectionChanged,
    required this.onAssignRequested,
  });

  final BuildContext context;
  final List<NeedSummary> needs;
  final Set<String> selectedIds;
  final void Function(String id, bool selected) onSelectionChanged;
  final void Function(String needId) onAssignRequested;

  @override
  DataRow? getRow(int index) {
    if (index >= needs.length) {
      return null;
    }
    final NeedSummary need = needs[index];
    final bool selected = selectedIds.contains(need.id);
    return DataRow.byIndex(
      index: index,
      selected: selected,
      onSelectChanged: (bool? value) {
        onSelectionChanged(need.id, value ?? false);
      },
      cells: <DataCell>[
        DataCell(_PriorityBadge(need: need)),
        DataCell(
          InkWell(
            onTap: () => Clipboard.setData(ClipboardData(text: need.id)),
            child: Tooltip(
              message: 'Copy ${need.id}',
              child: Text(_truncateId(need.id)),
            ),
          ),
        ),
        DataCell(
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: need.needTypes
                .map(
                  (String type) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlueLight,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      type,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        DataCell(
          Tooltip(
            message: need.locationRaw,
            child: SizedBox(
              width: 180,
              child: Text(
                need.locationRaw,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        DataCell(Align(alignment: Alignment.centerRight, child: Text('${need.affectedCount}'))),
        DataCell(Tooltip(message: need.source, child: Icon(need.sourceIcon))),
        DataCell(_StatusBadge(status: need.status)),
        DataCell(Text(need.ageLabel)),
        DataCell(
          need.assignedVolunteerIds.isEmpty
              ? Text(
                  'Unassigned',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.dangerRed),
                )
              : Text('${need.assignedVolunteerIds.length} assigned'),
        ),
        DataCell(
          TextButton(
            onPressed: () => onAssignRequested(need.id),
            child: Text(need.assignedVolunteerIds.isEmpty ? 'Assign' : 'View'),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => needs.length;

  @override
  int get selectedRowCount => selectedIds.length;

  String _truncateId(String id) {
    if (id.length <= 12) {
      return id;
    }
    return '${id.substring(0, 6)}...${id.substring(id.length - 4)}';
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.need});

  final NeedSummary need;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: need.priorityColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        need.priorityLabel,
        style: AppTextStyles.labelSmall.copyWith(color: need.priorityColor),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (status) {
      'ASSIGNED' => AppColors.primaryBlue,
      'IN_PROGRESS' => AppColors.warningAmber,
      'FULFILLED' => AppColors.successGreen,
      _ => AppColors.dangerRed,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        status,
        style: AppTextStyles.labelSmall.copyWith(color: color),
      ),
    );
  }
}

class _VolunteerPickerDialog extends StatefulWidget {
  const _VolunteerPickerDialog({required this.needId});

  final String needId;

  @override
  State<_VolunteerPickerDialog> createState() => _VolunteerPickerDialogState();
}

class _VolunteerPickerDialogState extends State<_VolunteerPickerDialog> {
  final TextEditingController _searchController = TextEditingController();
  final Dio _dio = getIt<Dio>();
  List<_VolunteerOption> _options = <_VolunteerOption>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadVolunteers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadVolunteers() async {
    try {
      final Response<Map<String, dynamic>> response =
          await _dio.get<Map<String, dynamic>>('/volunteers');
      final List<dynamic> data = response.data?['data'] as List<dynamic>? ?? <dynamic>[];
      if (!mounted) {
        return;
      }
      setState(() {
        _options = data
            .whereType<Map<dynamic, dynamic>>()
            .map((Map<dynamic, dynamic> item) => Map<String, dynamic>.from(item))
            .where((Map<String, dynamic> item) {
              final String status = '${item['status'] ?? ''}'.toLowerCase();
              return status.isEmpty || status == 'available';
            })
            .map(
              (Map<String, dynamic> item) => _VolunteerOption(
                '${item['id']}',
                '${item['name'] ?? 'Volunteer'}',
                <String>[
                  if ('${item['qualification'] ?? ''}'.trim().isNotEmpty)
                    '${item['qualification']}',
                  if ('${item['designation'] ?? ''}'.trim().isNotEmpty)
                    '${item['designation']}',
                ],
              ),
            )
            .toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _options = <_VolunteerOption>[];
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String query = _searchController.text.toLowerCase();
    final List<_VolunteerOption> filtered = _options.where((_VolunteerOption option) {
      return option.name.toLowerCase().contains(query) ||
          option.skills.any((String skill) => skill.toLowerCase().contains(query));
    }).toList();

    return AlertDialog(
      title: const Text('Assign volunteer'),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                hintText: 'Search volunteer or skill',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.md),
            Flexible(
              child: _loading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    )
                  : filtered.isEmpty
                      ? Center(
                          child: Text(
                            'No available volunteers found.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.neutral600,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (BuildContext context, int index) {
                            final _VolunteerOption option = filtered[index];
                            return ListTile(
                              title: Text(option.name),
                              subtitle: Wrap(
                                spacing: AppSpacing.xs,
                                children: option.skills
                                    .map(
                                      (String skill) => Chip(
                                        backgroundColor: AppColors.primaryBlueLight,
                                        side: BorderSide.none,
                                        label: Text(
                                          skill,
                                          style: AppTextStyles.labelSmall.copyWith(
                                            color: AppColors.primaryBlue,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.successGreenLight,
                                  borderRadius: BorderRadius.circular(AppRadius.full),
                                ),
                                child: Text(
                                  'AVAILABLE',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.successGreen,
                                  ),
                                ),
                              ),
                              onTap: () => Navigator.of(context).pop(option.id),
                            );
                          },
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
      ],
    );
  }
}

class _VolunteerOption {
  const _VolunteerOption(this.id, this.name, this.skills);

  final String id;
  final String name;
  final List<String> skills;
}
