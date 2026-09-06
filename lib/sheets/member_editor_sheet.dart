import 'package:flutter/material.dart';

import '../models/member.dart';
import '../state/app_scope.dart';

Future<void> showMemberEditor(
  BuildContext context, {
  Member? existing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) => MemberEditorSheet(existing: existing),
  );
}

class MemberEditorSheet extends StatefulWidget {
  const MemberEditorSheet({
    super.key,
    this.existing,
  });

  final Member? existing;

  @override
  State<MemberEditorSheet> createState() => _MemberEditorSheetState();
}

class _MemberEditorSheetState extends State<MemberEditorSheet> {
  late final TextEditingController _name;
  late final TextEditingController _pronouns;
  late final TextEditingController _role;
  late final TextEditingController _description;
  late final TextEditingController _tags;
  late final TextEditingController _note;

  static const palette = [
    0xFF7567D8,
    0xFFAD6178,
    0xFF4B7B69,
    0xFFB17936,
    0xFF4976A3,
    0xFF8B5A9E,
    0xFF8A694E,
    0xFF4C7D8A,
  ];

  late int _colorValue;

  @override
  void initState() {
    super.initState();

    final existing = widget.existing;
    _name = TextEditingController(text: existing?.name ?? '');
    _pronouns = TextEditingController(text: existing?.pronouns ?? '');
    _role = TextEditingController(text: existing?.role ?? 'Member');
    _description = TextEditingController(text: existing?.description ?? '');
    _tags = TextEditingController(text: existing?.tags.join(', ') ?? '');
    _note = TextEditingController(text: existing?.note ?? '');
    _colorValue = existing?.colorValue ?? palette.first;
  }

  @override
  void dispose() {
    _name.dispose();
    _pronouns.dispose();
    _role.dispose();
    _description.dispose();
    _tags.dispose();
    _note.dispose();
    super.dispose();
  }

  void _save() {
    final name = _name.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A member name is required.')),
      );
      return;
    }

    final store = AppScope.of(context);
    final tags = _tags.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toSet()
        .toList();

    final existing = widget.existing;
    final member = Member(
      id: existing?.id ??
          'member-${DateTime.now().microsecondsSinceEpoch.toString()}',
      name: name,
      pronouns: _pronouns.text.trim().isEmpty
          ? 'unspecified'
          : _pronouns.text.trim(),
      role: _role.text.trim().isEmpty ? 'Member' : _role.text.trim(),
      description: _description.text.trim(),
      colorValue: _colorValue,
      tags: tags,
      note: _note.text.trim(),
    );

    if (existing == null) {
      store.addMember(member);
    } else {
      store.updateMember(member);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(18, 4, 18, 18 + keyboard),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.existing == null ? 'New member' : 'Edit member',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pronouns,
                    decoration: const InputDecoration(labelText: 'Pronouns'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _role,
                    decoration: const InputDecoration(labelText: 'Role'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _description,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Short description',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tags,
              decoration: const InputDecoration(
                labelText: 'Tags',
                hintText: 'organizer, creative, quiet',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _note,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Notes',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            Text('Accent', style: theme.textTheme.labelLarge),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final value in palette)
                  GestureDetector(
                    onTap: () => setState(() => _colorValue = value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Color(value),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _colorValue == value
                              ? theme.colorScheme.onSurface
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check_rounded),
                label: Text(
                  widget.existing == null ? 'Create member' : 'Save changes',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
