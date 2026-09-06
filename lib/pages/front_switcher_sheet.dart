import 'package:flutter/material.dart';

import '../models/member.dart';
import '../state/app_scope.dart';
import '../widgets/member_avatar.dart';

Future<void> showFrontSwitcher(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return const FractionallySizedBox(
        heightFactor: 0.88,
        child: FrontSwitcherSheet(),
      );
    },
  );
}

class FrontSwitcherSheet extends StatefulWidget {
  const FrontSwitcherSheet({super.key});

  @override
  State<FrontSwitcherSheet> createState() => _FrontSwitcherSheetState();
}

class _FrontSwitcherSheetState extends State<FrontSwitcherSheet> {
  final TextEditingController _searchController =
      TextEditingController();

  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocus.dispose();

    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  List<Member> _filteredMembers(List<Member> members) {
    final query =
        _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return members;
    }

    return members.where((member) {
      final searchable = <String>[
        member.name,
        member.pronouns,
        member.role,
        member.description,
        ...member.tags,
      ].join(' ').toLowerCase();

      return searchable.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final theme = Theme.of(context);

    final currentFront = store.frontingMember;
    final members = _filteredMembers(
      store.members,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            18,
            4,
            10,
            8,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Switch front',
                      style:
                          theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Choose who is currently fronting.',
                      style:
                          theme.textTheme.bodyMedium,
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
        ),

        //
        // SEARCH BAR
        //
        Padding(
          padding: const EdgeInsets.fromLTRB(
            18,
            8,
            18,
            0,
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            textInputAction:
                TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search members...',
              prefixIcon: const Icon(
                Icons.search_rounded,
              ),
              suffixIcon:
                  _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          onPressed: () {
                            _searchController.clear();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                        ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Row(
            children: [
              Text(
                '${members.length} members',
                style:
                    theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Divider(
          height: 1,
          color: theme.dividerColor,
        ),

        Expanded(
          child: members.isEmpty
              ? _NoResults(
                  query:
                      _searchController.text,
                )
              : Scrollbar(
                  child: ListView.builder(
                    padding:
                        const EdgeInsets.fromLTRB(
                      10,
                      8,
                      10,
                      24,
                    ),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior
                            .onDrag,
                    itemCount: members.length,
                    itemBuilder:
                        (context, index) {
                      final member =
                          members[index];

                      final selected =
                          currentFront?.id ==
                              member.id;

                      return _MemberResult(
                        member: member,
                        selected: selected,
                        onTap: () {
                          store.setFrontingMember(
                            member.id,
                          );

                          Navigator.pop(
                            context,
                          );
                        },
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

class _MemberResult extends StatelessWidget {
  const _MemberResult({
    required this.member,
    required this.selected,
    required this.onTap,
  });

  final Member member;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: Material(
        color: selected
            ? member.color.withOpacity(
                theme.brightness ==
                        Brightness.dark
                    ? 0.13
                    : 0.07,
              )
            : Colors.transparent,
        borderRadius:
            BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(14),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            child: Row(
              children: [
                MemberAvatar(
                  member: member,
                  size: 44,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        member.name,
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style: theme
                            .textTheme
                            .titleMedium,
                      ),

                      const SizedBox(
                        height: 3,
                      ),

                      Text(
                        '${member.pronouns}  •  ${member.role}',
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style: theme
                            .textTheme
                            .bodyMedium,
                      ),
                    ],
                  ),
                ),

                if (selected)
                  Icon(
                    Icons.check_rounded,
                    color: member.color,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({
    required this.query,
  });

  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 36,
              color: theme
                  .textTheme
                  .bodyMedium
                  ?.color,
            ),

            const SizedBox(height: 10),

            Text(
              'No members found',
              style:
                  theme.textTheme.titleMedium,
            ),

            const SizedBox(height: 4),

            Text(
              query.trim().isEmpty
                  ? 'There are no members yet.'
                  : 'Nothing matches "$query".',
              textAlign: TextAlign.center,
              style:
                  theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}