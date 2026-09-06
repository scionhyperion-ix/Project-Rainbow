import 'package:flutter/material.dart';

import '../models/member.dart';
import '../state/app_scope.dart';
import '../widgets/member_avatar.dart';

Future<String?> showMemberSearchSheet(
  BuildContext context,
) {
  return showModalBottomSheet<String?>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return const FractionallySizedBox(
        heightFactor: 0.88,
        child: MemberSearchSheet(),
      );
    },
  );
}

class MemberSearchSheet extends StatefulWidget {
  const MemberSearchSheet({super.key});

  @override
  State<MemberSearchSheet> createState() =>
      _MemberSearchSheetState();
}

class _MemberSearchSheetState
    extends State<MemberSearchSheet> {
  final _searchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_refresh);
  }

  @override
  void dispose() {
    _searchController.removeListener(_refresh);
    _searchController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  List<Member> _results(
    List<Member> members,
  ) {
    final query = _searchController.text
        .trim()
        .toLowerCase();

    if (query.isEmpty) {
      return members;
    }

    return members.where((member) {
      final searchable = [
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
    final members = _results(store.members);

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
                  'Search members',
                  style:
                      theme.textTheme.titleLarge,
                ),
              ),
              IconButton(
                onPressed: () =>
                    Navigator.pop(context),
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
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText:
                  'Name, role, pronouns, tags...',
              prefixIcon: const Icon(
                Icons.search_rounded,
              ),
              suffixIcon:
                  _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed:
                              _searchController.clear,
                          icon: const Icon(
                            Icons.close_rounded,
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
            alignment: Alignment.centerLeft,
            child: Text(
              '${members.length} members',
              style:
                  theme.textTheme.bodyMedium,
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
                    style:
                        theme.textTheme.bodyMedium,
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.fromLTRB(
                    10,
                    8,
                    10,
                    24,
                  ),
                  itemCount: members.length,
                  itemExtent: 68,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior
                          .onDrag,
                  itemBuilder:
                      (context, index) {
                    final member =
                        members[index];

                    return ListTile(
                      leading: MemberAvatar(
                        member: member,
                        size: 42,
                      ),
                      title:
                          Text(member.name),
                      subtitle: Text(
                        '${member.pronouns}  •  ${member.role}',
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                      ),
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
