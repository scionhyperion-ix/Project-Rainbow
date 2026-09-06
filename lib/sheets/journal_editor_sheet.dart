import 'package:flutter/material.dart';

import '../models/journal_entry.dart';
import '../state/app_scope.dart';

Future<void> showJournalEditor(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) => const JournalEditorSheet(),
  );
}

class JournalEditorSheet extends StatefulWidget {
  const JournalEditorSheet({super.key});

  @override
  State<JournalEditorSheet> createState() => _JournalEditorSheetState();
}

class _JournalEditorSheetState extends State<JournalEditorSheet> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  String? _authorMemberId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authorMemberId ??= AppScope.of(context).frontingMember?.id;
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  void _save() {
    final body = _body.text.trim();
    if (body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write something before saving.')),
      );
      return;
    }

    final now = DateTime.now();
    AppScope.of(context).addJournalEntry(
      JournalEntry(
        id: 'journal-${now.microsecondsSinceEpoch}',
        title: _title.text.trim().isEmpty ? 'Untitled' : _title.text.trim(),
        body: body,
        authorMemberId: _authorMemberId,
        createdAt: now,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(18, 4, 18, 18 + keyboard),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('New journal entry', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String?>(
              value: _authorMemberId,
              decoration: const InputDecoration(labelText: 'Author'),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('Shared / unspecified'),
                ),
                ...store.members.map(
                  (member) => DropdownMenuItem<String?>(
                    value: member.id,
                    child: Text(member.name),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _authorMemberId = value),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _body,
              autofocus: true,
              minLines: 8,
              maxLines: 14,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Start writing...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Save entry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
