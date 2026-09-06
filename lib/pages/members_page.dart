import 'package:flutter/material.dart';

import '../models/member.dart';
import '../sheets/front_switcher_sheet.dart';
import '../sheets/member_editor_sheet.dart';
import '../state/app_scope.dart';
import '../widgets/member_avatar.dart';
import 'member_detail_page.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  bool _showPronouns = true;
  bool _showFrontButtons = false;
  bool _sortAZ = false;

  List<Member> _displayMembers(List<Member> members) {
    final result = [...members];

    if (_sortAZ) {
      result.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    }

    return result;
  }

  void _openMember(Member member) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MemberDetailPage(memberId: member.id),
      ),
    );
  }

  void _showOptions() {
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            void update(VoidCallback action) {
              setState(action);
              setSheetState(() {});
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.search_rounded),
                    title: const Text('Search members'),
                    onTap: () {
                      Navigator.pop(sheetContext);
                      showFrontSwitcher(this.context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.sort_by_alpha_rounded),
                    title: const Text('Sort A to Z'),
                    trailing: _sortAZ
                        ? Icon(
                            Icons.check_rounded,
                            color: theme.colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      update(() => _sortAZ = !_sortAZ);
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.badge_outlined),
                    title: const Text('Show pronouns'),
                    value: _showPronouns,
                    onChanged: (value) {
                      update(() => _showPronouns = value);
                    },
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.front_hand_outlined),
                    title: const Text('Show front buttons'),
                    value: _showFrontButtons,
                    onChanged: (value) {
                      update(() => _showFrontButtons = value);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final theme = Theme.of(context);
    final frontingId = store.frontingMember?.id;
    final members = _displayMembers(store.members);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 12, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Members',
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Add member',
                  onPressed: () => showMemberEditor(context),
                  icon: const Icon(Icons.add_rounded),
                ),
                IconButton(
                  tooltip: 'Options',
                  onPressed: _showOptions,
                  icon: const Icon(Icons.more_vert_rounded),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: theme.dividerColor),
          Expanded(
            child: members.isEmpty
                ? Center(
                    child: Text(
                      'No members yet.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 112),
                    itemCount: members.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: theme.dividerColor),
                    itemBuilder: (context, index) {
                      final member = members[index];
                      final isFronting = member.id == frontingId;

                      return _PrismLikeMemberRow(
                        member: member,
                        isFronting: isFronting,
                        showPronouns: _showPronouns,
                        showFrontButton: _showFrontButtons,
                        frontButtonBusy: false,
                        onTap: () => _openMember(member),
                        onFrontTap: () {
                          if (isFronting) {
                            store.setFrontingMember(null);
                          } else {
                            store.setFrontingMember(member.id);
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _PrismLikeMemberRow extends StatelessWidget {
  const _PrismLikeMemberRow({
    required this.member,
    required this.isFronting,
    required this.showPronouns,
    required this.showFrontButton,
    required this.frontButtonBusy,
    required this.onTap,
    required this.onFrontTap,
  });

  final Member member;
  final bool isFronting;
  final bool showPronouns;
  final bool showFrontButton;
  final bool frontButtonBusy;
  final VoidCallback onTap;
  final VoidCallback onFrontTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 10,
          ),
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (isFronting)
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: member.color,
                          width: 2.5,
                        ),
                      ),
                    ),
                  MemberAvatar(member: member, size: 46),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            member.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: isFronting
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isFronting) ...[
                          const SizedBox(width: 7),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: member.color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'Fronting',
                              style: TextStyle(
                                color: member.color,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      showPronouns
                          ? '${member.pronouns}  •  ${member.role}'
                          : member.role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (showFrontButton)
                IconButton(
                  tooltip: isFronting ? 'Stop fronting' : 'Start fronting',
                  onPressed: frontButtonBusy ? null : onFrontTap,
                  icon: Icon(
                    isFronting
                        ? Icons.stop_circle_outlined
                        : Icons.play_circle_outline_rounded,
                  ),
                )
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: theme.textTheme.bodyMedium?.color,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
