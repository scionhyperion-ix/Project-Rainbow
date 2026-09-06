import 'package:flutter/material.dart';

import '../sheets/member_editor_sheet.dart';
import '../state/app_scope.dart';
import '../widgets/member_avatar.dart';
import '../widgets/property_row.dart';

class MemberDetailPage extends StatelessWidget {
  const MemberDetailPage({
    super.key,
    required this.memberId,
  });

  final String memberId;

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final member = store.memberById(memberId);

    if (member == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('This member no longer exists.')),
      );
    }

    final theme = Theme.of(context);
    final isFronting = store.frontingMember?.id == member.id;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Edit',
            onPressed: () => showMemberEditor(context, existing: member),
            icon: const Icon(Icons.edit_outlined),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _confirmDelete(context);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded),
                    SizedBox(width: 10),
                    Text('Delete member'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 34),
        children: [
          const SizedBox(height: 8),
          MemberAvatar(member: member, size: 74),
          const SizedBox(height: 16),
          Text(member.name, style: theme.textTheme.displaySmall),
          const SizedBox(height: 6),
          Text(
            member.description.isEmpty
                ? 'No description yet.'
                : member.description,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: isFronting
                ? OutlinedButton.icon(
                    onPressed: () => store.setFrontingMember(null),
                    icon: const Icon(Icons.pause_rounded),
                    label: const Text('Clear current front'),
                  )
                : FilledButton.icon(
                    onPressed: () => store.setFrontingMember(member.id),
                    icon: const Icon(Icons.person_pin_circle_outlined),
                    label: const Text('Set as fronting'),
                  ),
          ),
          const SizedBox(height: 22),
          Text('Properties', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  PropertyRow(
                    icon: Icons.badge_outlined,
                    label: 'Pronouns',
                    value: Text(member.pronouns),
                  ),
                  PropertyRow(
                    icon: Icons.work_outline_rounded,
                    label: 'Role',
                    value: Text(member.role),
                  ),
                  PropertyRow(
                    icon: Icons.sell_outlined,
                    label: 'Tags',
                    value: member.tags.isEmpty
                        ? Text(
                            'None',
                            style: theme.textTheme.bodyMedium,
                          )
                        : Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final tag in member.tags)
                                Chip(
                                  visualDensity: VisualDensity.compact,
                                  label: Text(tag),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text('Notes', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                member.note.isEmpty
                    ? 'Nothing has been added here yet.'
                    : member.note,
                style: member.note.isEmpty
                    ? theme.textTheme.bodyMedium
                    : theme.textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final store = AppScope.of(context);
    final member = store.memberById(memberId);
    if (member == null) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete member?'),
        content: Text(
          'This will remove ${member.name} from the current local workspace.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !context.mounted) return;

    store.deleteMember(member.id);
    Navigator.pop(context);
  }
}
