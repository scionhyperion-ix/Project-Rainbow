import 'package:flutter/material.dart';

import '../models/journal_entry.dart';
import '../models/member.dart';

class AppStore extends ChangeNotifier {
  AppStore({
    required List<Member> members,
    required List<JournalEntry> journalEntries,
    String? frontingMemberId,
    ThemeMode themeMode = ThemeMode.system,
  })  : _members = members,
        _journalEntries = journalEntries,
        _frontingMemberId = frontingMemberId,
        _themeMode = themeMode;

  factory AppStore.seeded() {
    const members = [
      Member(
        id: 'aster',
        name: 'Aster',
        pronouns: 'they/them',
        role: 'Caretaker',
        description: 'Likes quiet evenings, planning, and keeping shared notes.',
        colorValue: 0xFF7567D8,
        tags: ['calm', 'organizer'],
        note: 'Usually helps keep the day structured.',
      ),
      Member(
        id: 'mira',
        name: 'Mira',
        pronouns: 'she/her',
        role: 'Archivist',
        description: 'Keeps track of journals, memories, and useful references.',
        colorValue: 0xFFAD6178,
        tags: ['journal', 'creative'],
        note: 'Enjoys writing longer journal entries.',
      ),
      Member(
        id: 'noah',
        name: 'Noah',
        pronouns: 'he/him',
        role: 'Member',
        description: 'Prefers concise notes and low-pressure check-ins.',
        colorValue: 0xFF4B7B69,
        tags: ['quiet'],
      ),
      Member(
        id: 'lumi',
        name: 'Lumi',
        pronouns: 'she/they',
        role: 'Member',
        description: 'Likes music, visual organization, and colorful pages.',
        colorValue: 0xFFB17936,
        tags: ['music', 'art'],
      ),
    ];

    final now = DateTime.now();

    return AppStore(
      members: members,
      frontingMemberId: 'aster',
      journalEntries: [
        JournalEntry(
          id: 'journal-1',
          title: 'A quiet Sunday',
          body:
              'We kept today simple. A few tasks, some music, and a little organizing.',
          authorMemberId: 'aster',
          createdAt: now.subtract(const Duration(hours: 2)),
        ),
        JournalEntry(
          id: 'journal-2',
          title: 'Things to reorganize',
          body:
              'Member pages could use cleaner tags. Also remember to sort the shared notes later.',
          authorMemberId: 'mira',
          createdAt: now.subtract(const Duration(days: 1, hours: 3)),
        ),
      ],
    );
  }

  final List<Member> _members;
  final List<JournalEntry> _journalEntries;
  String? _frontingMemberId;
  ThemeMode _themeMode;

  List<Member> get members => List.unmodifiable(_members);

  List<JournalEntry> get journalEntries {
    final copy = [..._journalEntries];
    copy.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(copy);
  }

  ThemeMode get themeMode => _themeMode;

  Member? get frontingMember {
    if (_frontingMemberId == null) return null;

    for (final member in _members) {
      if (member.id == _frontingMemberId) return member;
    }

    return null;
  }

  Member? memberById(String? id) {
    if (id == null) return null;

    for (final member in _members) {
      if (member.id == id) return member;
    }

    return null;
  }

  void setThemeMode(ThemeMode value) {
    if (_themeMode == value) return;
    _themeMode = value;
    notifyListeners();
  }

  void setFrontingMember(String? memberId) {
    if (_frontingMemberId == memberId) return;
    _frontingMemberId = memberId;
    notifyListeners();
  }

  void addMember(Member member) {
    _members.add(member);
    notifyListeners();
  }

  void updateMember(Member member) {
    final index = _members.indexWhere((item) => item.id == member.id);
    if (index < 0) return;

    _members[index] = member;
    notifyListeners();
  }

  void deleteMember(String id) {
    _members.removeWhere((member) => member.id == id);

    if (_frontingMemberId == id) {
      _frontingMemberId = null;
    }

    notifyListeners();
  }

  void addJournalEntry(JournalEntry entry) {
    _journalEntries.add(entry);
    notifyListeners();
  }

  void deleteJournalEntry(String id) {
    _journalEntries.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }
}
