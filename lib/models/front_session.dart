class FrontSession {
  const FrontSession({
    required this.id,
    required this.memberId,
    required this.startedAt,
    this.endedAt,
    this.note = '',
  });

  final String id;
  final String memberId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String note;

  bool get isActive => endedAt == null;

  FrontSession end(DateTime time) {
    return FrontSession(
      id: id,
      memberId: memberId,
      startedAt: startedAt,
      endedAt: time,
      note: note,
    );
  }
}