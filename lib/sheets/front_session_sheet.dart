import 'package:flutter/material.dart';

import '../models/member.dart';
import '../state/app_scope.dart';
import '../widgets/member_avatar.dart';

enum _FrontAction {
  add,
  replace,
}

enum _SessionType {
  now,
  past,
}

Future<void> showFrontSessionSheet(
  BuildContext context,
) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return const FractionallySizedBox(
        heightFactor: 0.92,
        child: FrontSessionSheet(),
      );
    },
  );
}

class FrontSessionSheet
    extends StatefulWidget {
  const FrontSessionSheet({
    super.key,
  });

  @override
  State<FrontSessionSheet> createState() =>
      _FrontSessionSheetState();
}

class _FrontSessionSheetState
    extends State<FrontSessionSheet> {
  final TextEditingController
      _noteController =
      TextEditingController();

  String? _selectedMemberId;

  _FrontAction _action =
      _FrontAction.add;

  _SessionType _sessionType =
      _SessionType.now;

  late DateTime _pastStart;
  late DateTime _pastEnd;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _pastEnd = now;
    _pastStart = now.subtract(
      const Duration(hours: 1),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _chooseMember() async {
    final selected =
        await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return const FractionallySizedBox(
          heightFactor: 0.88,
          child: _MemberPickerSheet(),
        );
      },
    );

    if (!mounted || selected == null) {
      return;
    }

    setState(() {
      _selectedMemberId = selected;
    });
  }

  Future<DateTime?> _pickDateTime(
    DateTime initial,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(
        const Duration(days: 1),
      ),
    );

    if (date == null || !mounted) {
      return null;
    }

    final time = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(initial),
    );

    if (time == null) {
      return null;
    }

    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  Future<void> _pickStart() async {
    final value =
        await _pickDateTime(_pastStart);

    if (value == null) return;

    setState(() {
      _pastStart = value;

      if (!_pastEnd.isAfter(_pastStart)) {
        _pastEnd = _pastStart.add(
          const Duration(hours: 1),
        );
      }
    });
  }

  Future<void> _pickEnd() async {
    final value =
        await _pickDateTime(_pastEnd);

    if (value == null) return;

    setState(() {
      _pastEnd = value;
    });
  }

  String _formatDateTime(
    BuildContext context,
    DateTime value,
  ) {
    final time =
        MaterialLocalizations.of(context)
            .formatTimeOfDay(
      TimeOfDay.fromDateTime(value),
    );

    return '${value.day}/${value.month}/${value.year}  $time';
  }

  void _save() {
    final memberId = _selectedMemberId;

    if (memberId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Select a fronter first.',
          ),
        ),
      );

      return;
    }

    final store = AppScope.of(context);

    if (_sessionType ==
        _SessionType.past) {
      if (!_pastEnd.isAfter(
        _pastStart,
      )) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'The end time must be after the start time.',
            ),
          ),
        );

        return;
      }

      store.logPastFrontSession(
        memberId: memberId,
        startedAt: _pastStart,
        endedAt: _pastEnd,
        note: _noteController.text,
      );

      Navigator.pop(context);
      return;
    }

    final success =
        store.startFrontSession(
      memberId: memberId,
      note: _noteController.text,
      replaceCurrent:
          _action ==
              _FrontAction.replace,
    );

    if (!success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'That member is already fronting.',
          ),
        ),
      );

      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final theme = Theme.of(context);

    final selectedMember =
        store.memberById(
      _selectedMemberId,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        18,
        0,
        18,
        24 +
            MediaQuery.viewInsetsOf(context)
                .bottom,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add fronter',
                      style: theme
                          .textTheme
                          .titleLarge,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Start a front or log a previous session.',
                      style: theme
                          .textTheme
                          .bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Close',
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Text(
            'Fronter',
            style:
                theme.textTheme.labelLarge,
          ),

          const SizedBox(height: 8),

          Card(
            child: InkWell(
              onTap: _chooseMember,
              borderRadius:
                  BorderRadius.circular(16),
              child: Padding(
                padding:
                    const EdgeInsets.all(14),
                child: Row(
                  children: [
                    if (selectedMember !=
                        null)
                      MemberAvatar(
                        member:
                            selectedMember,
                        size: 44,
                      )
                    else
                      Container(
                        width: 44,
                        height: 44,
                        decoration:
                            BoxDecoration(
                          color: theme
                              .colorScheme
                              .onSurface
                              .withOpacity(
                            0.06,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            12,
                          ),
                        ),
                        child: const Icon(
                          Icons
                              .person_search_outlined,
                        ),
                      ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            selectedMember
                                    ?.name ??
                                'Select fronter',
                            style: theme
                                .textTheme
                                .titleMedium,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            selectedMember ==
                                    null
                                ? 'Search members'
                                : '${selectedMember.pronouns}  •  ${selectedMember.role}',
                            style: theme
                                .textTheme
                                .bodyMedium,
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons
                          .chevron_right_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Session',
            style:
                theme.textTheme.labelLarge,
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child:
                SegmentedButton<
                    _SessionType>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value:
                      _SessionType.now,
                  icon: Icon(
                    Icons
                        .play_arrow_rounded,
                  ),
                  label: Text(
                    'Start now',
                  ),
                ),
                ButtonSegment(
                  value:
                      _SessionType.past,
                  icon: Icon(
                    Icons
                        .history_rounded,
                  ),
                  label: Text(
                    'Past session',
                  ),
                ),
              ],
              selected: {
                _sessionType,
              },
              onSelectionChanged:
                  (selection) {
                setState(() {
                  _sessionType =
                      selection.first;
                });
              },
            ),
          ),

          if (_sessionType ==
              _SessionType.now) ...[
            const SizedBox(height: 24),

            Text(
              'Current front',
              style:
                  theme.textTheme.labelLarge,
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child:
                  SegmentedButton<
                      _FrontAction>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value:
                        _FrontAction.add,
                    icon: Icon(
                      Icons.add_rounded,
                    ),
                    label: Text(
                      'Add / Co-front',
                    ),
                  ),
                  ButtonSegment(
                    value:
                        _FrontAction
                            .replace,
                    icon: Icon(
                      Icons
                          .swap_horiz_rounded,
                    ),
                    label: Text(
                      'Replace',
                    ),
                  ),
                ],
                selected: {
                  _action,
                },
                onSelectionChanged:
                    (selection) {
                  setState(() {
                    _action =
                        selection.first;
                  });
                },
              ),
            ),
          ],

          if (_sessionType ==
              _SessionType.past) ...[
            const SizedBox(height: 24),

            Text(
              'Session time',
              style:
                  theme.textTheme.labelLarge,
            ),

            const SizedBox(height: 8),

            _DateTimeRow(
              icon:
                  Icons.login_rounded,
              label: 'Started',
              value:
                  _formatDateTime(
                context,
                _pastStart,
              ),
              onTap: _pickStart,
            ),

            const SizedBox(height: 8),

            _DateTimeRow(
              icon:
                  Icons.logout_rounded,
              label: 'Ended',
              value:
                  _formatDateTime(
                context,
                _pastEnd,
              ),
              onTap: _pickEnd,
            ),

            const SizedBox(height: 8),

            Text(
              'Past sessions do not change the current front.',
              style:
                  theme.textTheme.bodyMedium,
            ),
          ],

          const SizedBox(height: 24),

          Text(
            'Notes',
            style:
                theme.textTheme.labelLarge,
          ),

          const SizedBox(height: 8),

          TextField(
            controller: _noteController,
            minLines: 3,
            maxLines: 6,
            textCapitalization:
                TextCapitalization
                    .sentences,
            decoration:
                const InputDecoration(
              hintText:
                  'Optional session notes...',
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _save,
              icon: Icon(
                _sessionType ==
                        _SessionType.past
                    ? Icons
                        .history_rounded
                    : Icons
                        .person_add_alt_1_rounded,
              ),
              label: Text(
                _sessionType ==
                        _SessionType.past
                    ? 'Save past session'
                    : _action ==
                            _FrontAction
                                .replace
                        ? 'Replace current front'
                        : 'Add fronter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateTimeRow
    extends StatelessWidget {
  const _DateTimeRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon),
        title: Text(label),
        subtitle: Text(value),
        trailing: const Icon(
          Icons.edit_outlined,
        ),
      ),
    );
  }
}

class _MemberPickerSheet
    extends StatefulWidget {
  const _MemberPickerSheet();

  @override
  State<_MemberPickerSheet>
      createState() =>
          _MemberPickerSheetState();
}

class _MemberPickerSheetState
    extends State<_MemberPickerSheet> {
  final TextEditingController
      _searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(
      _refresh,
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(
      _refresh,
    );

    _searchController.dispose();

    super.dispose();
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final theme = Theme.of(context);

    final query = _searchController.text
        .trim()
        .toLowerCase();

    final members = query.isEmpty
        ? store.members
        : store.members.where((member) {
            final searchable = [
              member.name,
              member.pronouns,
              member.role,
              member.description,
              ...member.tags,
            ].join(' ').toLowerCase();

            return searchable.contains(
              query,
            );
          }).toList();

    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.fromLTRB(
            18,
            0,
            10,
            8,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Select fronter',
                  style: theme
                      .textTheme
                      .titleLarge,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close_rounded,
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          child: TextField(
            controller:
                _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText:
                  'Search members...',
              prefixIcon: const Icon(
                Icons.search_rounded,
              ),
              suffixIcon:
                  _searchController
                          .text.isEmpty
                      ? null
                      : IconButton(
                          onPressed:
                              _searchController
                                  .clear,
                          icon: const Icon(
                            Icons
                                .close_rounded,
                          ),
                        ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Align(
            alignment:
                Alignment.centerLeft,
            child: Text(
              '${members.length} members',
              style: theme
                  .textTheme.bodyMedium,
            ),
          ),
        ),

        const SizedBox(height: 8),

        Divider(
          height: 1,
          color: theme.dividerColor,
        ),

        Expanded(
          child: members.isEmpty
              ? Center(
                  child: Text(
                    'No members found.',
                    style: theme
                        .textTheme
                        .bodyMedium,
                  ),
                )
              : ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior
                          .onDrag,
                  padding:
                      const EdgeInsets
                          .fromLTRB(
                    10,
                    8,
                    10,
                    24,
                  ),
                  itemCount:
                      members.length,
                  itemExtent: 68,
                  itemBuilder:
                      (context, index) {
                    final member =
                        members[index];

                    return ListTile(
                      leading:
                          MemberAvatar(
                        member: member,
                        size: 42,
                      ),
                      title: Text(
                        member.name,
                      ),
                      subtitle: Text(
                        '${member.pronouns}  •  ${member.role}',
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                      ),
                      trailing:
                          store.isFronting(
                        member.id,
                      )
                              ? Icon(
                                  Icons
                                      .check_rounded,
                                  color: member
                                      .color,
                                )
                              : null,
                      onTap: () {
                        Navigator.pop(
                          context,
                          member.id,
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}