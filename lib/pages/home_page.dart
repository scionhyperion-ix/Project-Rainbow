import 'package:flutter/material.dart';

import '../models/member.dart';
import '../sheets/front_switcher_sheet.dart';
import '../sheets/journal_editor_sheet.dart';
import '../sheets/member_editor_sheet.dart';
import '../state/app_scope.dart';
import '../widgets/member_card.dart';
import '../widgets/page_header.dart';
import '../widgets/quick_front_strip.dart';
import '../widgets/section_header.dart';
import 'member_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openMember(
    BuildContext context,
    Member member,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MemberDetailPage(
          memberId: member.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final theme = Theme.of(context);

    final fronting = store.frontingMember;

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          18,
          14,
          18,
          120,
        ),
        children: [
          PageHeader(
            title: 'Home',
            subtitle: fronting == null
                ? 'No one is currently fronting'
                : '${fronting.name} is currently fronting',
            actions: [
              IconButton(
                tooltip: 'Search members',
                onPressed: () {
                  showFrontSwitcher(context);
                },
                icon: const Icon(
                  Icons.search_rounded,
                ),
              ),
              IconButton(
                tooltip: 'More',
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Quick front',
                  style: theme.textTheme.titleMedium,
                ),
              ),

              if (fronting != null)
                TextButton.icon(
                  onPressed: () {
                    store.setFrontingMember(null);
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 17,
                  ),
                  label: const Text(
                    'Clear',
                  ),
                ),

              TextButton(
                onPressed: () {
                  showFrontSwitcher(context);
                },
                child: const Text(
                  'All members',
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          QuickFrontStrip(
            members: store.members,
            frontingMemberId: fronting?.id,
            onOpenMember: (member) {
              _openMember(
                context,
                member,
              );
            },
            onFrontChanged: (
              memberId,
            ) {
              store.setFrontingMember(
                memberId,
              );
            },
          ),

          const SizedBox(height: 4),

          Text(
            'Hold a member to switch front.',
            style: theme.textTheme.bodyMedium,
          ),

          const SizedBox(height: 28),

          const SectionHeader(
            title: 'Quick actions',
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  icon:
                      Icons.edit_note_rounded,
                  label: 'New note',
                  onTap: () {
                    showJournalEditor(
                      context,
                    );
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _ActionCard(
                  icon: Icons
                      .person_add_alt_1_rounded,
                  label: 'Add member',
                  onTap: () {
                    showMemberEditor(
                      context,
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          SectionHeader(
            title: 'Members',
            actionLabel: 'See all',
            onAction: () {
              showFrontSwitcher(context);
            },
          ),

          const SizedBox(height: 10),

          ...store.members.take(3).map(
                (member) => Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 9,
                  ),
                  child: MemberCard(
                    member: member,
                    isFronting:
                        fronting?.id ==
                            member.id,
                    onTap: () {
                      _openMember(
                        context,
                        member,
                      );
                    },
                  ),
                ),
              ),

          const SizedBox(height: 14),

          Divider(
            color: theme.dividerColor,
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 16,
                color:
                    theme.textTheme.bodyMedium?.color,
              ),

              const SizedBox(width: 7),

              Expanded(
                child: Text(
                  'Project Rainbow local workspace',
                  style:
                      theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(16),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
              ),

              const SizedBox(width: 9),

              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}