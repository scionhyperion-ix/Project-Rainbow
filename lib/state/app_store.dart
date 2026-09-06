import 'package:flutter/material.dart';

import '../models/front_session.dart';
import '../models/journal_entry.dart';
import '../models/member.dart';

class AppStore extends ChangeNotifier {
  AppStore({
    required List<Member> members,
    required List<JournalEntry> journalEntries,
    List<FrontSession>? frontSessions,
    String? frontingMemberId,
    ThemeMode themeMode = ThemeMode.system,
  })  : _members = List<Member>.from(members),
        _journalEntries = List<JournalEntry>.from(journalEntries),
        _frontSessions = List<FrontSession>.from(
          frontSessions ?? const [],
        ),
        _themeMode = themeMode {
    // Compatibility with the older single-front constructor.
    if (frontingMemberId != null &&
        !_frontSessions.any(
          (session) =>
              session.memberId == frontingMemberId &&
              session.isActive,
        )) {
      _frontSessions.add(
        FrontSession(
          id: _newId('front'),
          memberId: frontingMemberId,
          startedAt: DateTime.now(),
        ),
      );
    }
  }

  factory AppStore.seeded() {
    const members = [
      Member(
        id: 'aster',
        name: 'Aster',
        pronouns: 'they/them',
        role: 'Caretaker',
        description:
            'Likes quiet evenings, planning, and keeping shared notes.',
        colorValue: 0xFF7567D8,
        tags: ['calm', 'organizer'],
        note: 'Usually helps keep the day structured.',
      ),
      Member(
        id: 'mira',
        name: 'Mira',
        pronouns: 'she/her',
        role: 'Archivist',
        description:
            'Keeps track of journals, memories, and useful references.',
        colorValue: 0xFFAD6178,
        tags: ['journal', 'creative'],
        note: 'Enjoys writing longer journal entries.',
      ),
      Member(
        id: 'noah',
        name: 'Noah',
        pronouns: 'he/him',
        role: 'Member',
        description:
            'Prefers concise notes and low-pressure check-ins.',
        colorValue: 0xFF4B7B69,
        tags: ['quiet'],
      ),
      Member(
        id: 'lumi',
        name: 'Lumi',
        pronouns: 'she/they',
        role: 'Member',
        description:
            'Likes music, visual organization, and colorful pages.',
        colorValue: 0xFFB17936,
        tags: ['music', 'art'],
      ),
    ];

    final now = DateTime.now();

    return AppStore(
      members: members,

      frontSessions: [
        FrontSession(
          id: 'front-active-aster',
          memberId: 'aster',
          startedAt: now.subtract(
            const Duration(minutes: 42),
          ),
        ),
        FrontSession(
          id: 'front-old-mira-1',
          memberId: 'mira',
          startedAt: now.subtract(
            const Duration(days: 1, hours: 2),
          ),
          endedAt: now.subtract(
            const Duration(days: 1, minutes: 45),
          ),
        ),
        FrontSession(
          id: 'front-old-mira-2',
          memberId: 'mira',
          startedAt: now.subtract(
            const Duration(days: 3, hours: 1),
          ),
          endedAt: now.subtract(
            const Duration(days: 3),
          ),
        ),
        FrontSession(
          id: 'front-old-noah',
          memberId: 'noah',
          startedAt: now.subtract(
            const Duration(days: 4, hours: 2),
          ),
          endedAt: now.subtract(
            const Duration(days: 4),
          ),
        ),
      ],

      journalEntries: [
        JournalEntry(
          id: 'journal-1',
          title: 'A quiet Sunday',
          body:
              'We kept today simple. A few tasks, some music, and a little organizing.',
          authorMemberId: 'aster',
          createdAt: now.subtract(
            const Duration(hours: 2),
          ),
        ),
        JournalEntry(
          id: 'journal-2',
          title: 'Things to reorganize',
          body:
              'Member pages could use cleaner tags. Remember to sort the shared notes later.',
          authorMemberId: 'mira',
          createdAt: now.subtract(
            const Duration(days: 1, hours: 3),
          ),
        ),
      ],
    );
  }

  final List<Member> _members;
  final List<JournalEntry> _journalEntries;
  final List<FrontSession> _frontSessions;

  ThemeMode _themeMode;

  static String _newId(String prefix) {
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
  }

  List<Member> get members {
    return List.unmodifiable(_members);
  }

  Member? memberById(String? id) {
    if (id == null) return null;

    for (final member in _members) {
      if (member.id == id) {
        return member;
      }
    }

    return null;
  }

  void addMember(Member member) {
    _members.add(member);
    notifyListeners();
  }

  void updateMember(Member member) {
    final index = _members.indexWhere(
      (item) => item.id == member.id,
    );

    if (index < 0) return;

    _members[index] = member;
    notifyListeners();
  }

  void deleteMember(String id) {
    _members.removeWhere(
      (member) => member.id == id,
    );

    _frontSessions.removeWhere(
      (session) => session.memberId == id,
    );

    notifyListeners();
  }

  List<FrontSession> get frontSessions {
    final copy = [..._frontSessions];

    copy.sort(
      (a, b) => b.startedAt.compareTo(a.startedAt),
    );

    return List.unmodifiable(copy);
  }

  List<FrontSession> get activeFrontSessions {
    final result = _frontSessions
        .where((session) => session.isActive)
        .toList();

    result.sort(
      (a, b) => a.startedAt.compareTo(b.startedAt),
    );

    return List.unmodifiable(result);
  }

  List<Member> get frontingMembers {
    final result = <Member>[];
    final seen = <String>{};

    for (final session in activeFrontSessions) {
      if (!seen.add(session.memberId)) {
        continue;
      }

      final member = memberById(session.memberId);

      if (member != null) {
        result.add(member);
      }
    }

    return List.unmodifiable(result);
  }

  Set<String> get frontingMemberIds {
    return activeFrontSessions
        .map((session) => session.memberId)
        .toSet();
  }

  Member? get frontingMember {
    final current = frontingMembers;

    if (current.isEmpty) {
      return null;
    }

    return current.first;
  }

  bool isFronting(String memberId) {
    return _frontSessions.any(
      (session) =>
          session.memberId == memberId &&
          session.isActive,
    );
  }

  bool startFrontSession({
    required String memberId,
    DateTime? startedAt,
    String note = '',
    bool replaceCurrent = false,
  }) {
    if (memberById(memberId) == null) {
      return false;
    }

    final start = startedAt ?? DateTime.now();

    if (replaceCurrent) {
      _endAllActiveAt(start);
    } else if (isFronting(memberId)) {
      return false;
    }

    _frontSessions.add(
      FrontSession(
        id: _newId('front'),
        memberId: memberId,
        startedAt: start,
        note: note.trim(),
      ),
    );

    notifyListeners();
    return true;
  }

  bool logPastFrontSession({
    required String memberId,
    required DateTime startedAt,
    required DateTime endedAt,
    String note = '',
  }) {
    if (memberById(memberId) == null) {
      return false;
    }

    if (!endedAt.isAfter(startedAt)) {
      return false;
    }

    _frontSessions.add(
      FrontSession(
        id: _newId('front'),
        memberId: memberId,
        startedAt: startedAt,
        endedAt: endedAt,
        note: note.trim(),
      ),
    );

    notifyListeners();
    return true;
  }

  void endFrontSessionForMember(
    String memberId, {
    DateTime? endedAt,
  }) {
    final end = endedAt ?? DateTime.now();

    var changed = false;

    for (var i = 0; i < _frontSessions.length; i++) {
      final session = _frontSessions[i];

      if (session.memberId != memberId ||
          !session.isActive) {
        continue;
      }

      final safeEnd = end.isBefore(session.startedAt)
          ? session.startedAt
          : end;

      _frontSessions[i] = session.end(safeEnd);
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  void endAllActiveFronts({
    DateTime? endedAt,
  }) {
    final end = endedAt ?? DateTime.now();

    if (_endAllActiveAt(end)) {
      notifyListeners();
    }
  }

  bool _endAllActiveAt(DateTime end) {
    var changed = false;

    for (var i = 0; i < _frontSessions.length; i++) {
      final session = _frontSessions[i];

      if (!session.isActive) {
        continue;
      }

      final safeEnd = end.isBefore(session.startedAt)
          ? session.startedAt
          : end;

      _frontSessions[i] = session.end(safeEnd);
      changed = true;
    }

    return changed;
  }

  void setFrontingMember(String? memberId) {
    if (memberId == null) {
      endAllActiveFronts();
      return;
    }

    startFrontSession(
      memberId: memberId,
      replaceCurrent: true,
    );
  }

  List<Member> frequentMembers({
    int limit = 10,
  }) {
    if (_members.isEmpty) {
      return const [];
    }

    final now = DateTime.now();

    final scores = <String, double>{};
    final latestUse = <String, DateTime>{};

    for (final session in _frontSessions) {
      if (memberById(session.memberId) == null) {
        continue;
      }

      var points = 1.0;

      final age = now.difference(
        session.startedAt,
      );

      if (session.isActive) {
        points += 8;
      }

      if (age.inDays <= 7) {
        points += 4;
      } else if (age.inDays <= 30) {
        points += 2;
      }

      scores.update(
        session.memberId,
        (old) => old + points,
        ifAbsent: () => points,
      );

      final previous = latestUse[session.memberId];

      if (previous == null ||
          session.startedAt.isAfter(previous)) {
        latestUse[session.memberId] =
            session.startedAt;
      }
    }

    final ranked = [..._members];

    ranked.sort((a, b) {
      final aScore = scores[a.id] ?? 0;
      final bScore = scores[b.id] ?? 0;

      final scoreCompare =
          bScore.compareTo(aScore);

      if (scoreCompare != 0) {
        return scoreCompare;
      }

      final aLatest = latestUse[a.id];
      final bLatest = latestUse[b.id];

      if (aLatest != null && bLatest != null) {
        final recentCompare =
            bLatest.compareTo(aLatest);

        if (recentCompare != 0) {
          return recentCompare;
        }
      }

      if (aLatest != null) return -1;
      if (bLatest != null) return 1;

      return a.name
          .toLowerCase()
          .compareTo(
            b.name.toLowerCase(),
          );
    });

    return ranked.take(limit).toList();
  }

  List<JournalEntry> get journalEntries {
    final copy = [..._journalEntries];

    copy.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );

    return List.unmodifiable(copy);
  }

  void addJournalEntry(
    JournalEntry entry,
  ) {
    _journalEntries.add(entry);
    notifyListeners();
  }

  void deleteJournalEntry(String id) {
    _journalEntries.removeWhere(
      (entry) => entry.id == id,
    );

    notifyListeners();
  }

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode value) {
    if (_themeMode == value) return;

    _themeMode = value;
    notifyListeners();
  }
}