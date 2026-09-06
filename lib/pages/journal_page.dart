import 'package:flutter/material.dart';

import '../models/journal_entry.dart';
import '../sheets/journal_editor_sheet.dart';
import '../state/app_scope.dart';
import '../widgets/member_avatar.dart';
import '../widgets/page_header.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  String _relativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _openEntry(BuildContext context, JournalEntry entry) {
    final store = AppScope.of(context);
    final author = store.memberById(entry.authorMemberId);
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.title, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (author != null) ...[
                    MemberAvatar(member: author, size: 30),
                    const SizedBox(width: 8),
                    Text(author.name, style: theme.textTheme.labelLarge),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    _relativeDate(entry.createdAt),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(entry.body, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 26),
              TextButton.icon(
                onPressed: () {
                  store.deleteJournalEntry(entry.id);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Delete entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 130),
            children: [
              PageHeader(
                title: 'Journal',
                subtitle: 'Shared notes, thoughts, and daily entries',
                actions: [
                  IconButton(
                    tooltip: 'Search',
                    onPressed: () {},
                    icon: const Icon(Icons.search_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (store.journalEntries.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        const Icon(Icons.menu_book_outlined, size: 32),
                        const SizedBox(height: 10),
                        Text(
                          'The journal is empty.',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Create the first shared entry.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...store.journalEntries.map((entry) {
                  final author = store.memberById(entry.authorMemberId);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      child: InkWell(
                        onTap: () => _openEntry(context, entry),
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.title,
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 7),
                              Text(
                                entry.body,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  if (author != null) ...[
                                    MemberAvatar(member: author, size: 28),
                                    const SizedBox(width: 8),
                                    Text(
                                      author.name,
                                      style: theme.textTheme.labelLarge,
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Text(
                                    _relativeDate(entry.createdAt),
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
          Positioned(
            right: 18,
            bottom: 102,
            child: FloatingActionButton.extended(
              heroTag: 'journal-add',
              onPressed: () => showJournalEditor(context),
              icon: const Icon(Icons.edit_rounded),
              label: const Text('Write'),
            ),
          ),
        ],
      ),
    );
  }
}
