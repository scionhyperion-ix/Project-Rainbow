class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.authorMemberId,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final String? authorMemberId;
  final DateTime createdAt;

  JournalEntry copyWith({
    String? id,
    String? title,
    String? body,
    String? authorMemberId,
    DateTime? createdAt,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      authorMemberId: authorMemberId ?? this.authorMemberId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
