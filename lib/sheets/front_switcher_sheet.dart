import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../widgets/member_avatar.dart';

Future<void> showFrontSwitcher(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) => const FrontSwitcherSheet(),
  );
}

class FrontSwitcherSheet extends StatelessWidget {
  const FrontSwitcherSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final frontingId = store.frontingMember?.id;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Switch front', style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Choose who is currently fronting.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 430),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: store.members.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                if (index == store.members.length) {
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    leading: const Icon(Icons.pause_circle_outline_rounded),
                    title: const Text('No one selected'),
                    subtitle: const Text('Clear the current front'),
                    trailing: frontingId == null
                        ? const Icon(Icons.check_rounded)
                        : null,
                    onTap: () {
                      store.setFrontingMember(null);
                      Navigator.pop(context);
                    },
                  );
                }

                final member = store.members[index];
                final selected = member.id == frontingId;

                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leading: MemberAvatar(member: member, size: 42),
                  title: Text(member.name),
                  subtitle: Text('${member.pronouns}  •  ${member.role}'),
                  trailing: selected
                      ? Icon(Icons.check_rounded, color: member.color)
                      : null,
                  onTap: () {
                    store.setFrontingMember(member.id);
                    Navigator.pop(context);
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
