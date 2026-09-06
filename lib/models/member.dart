import 'package:flutter/material.dart';

class Member {
  const Member({
    required this.id,
    required this.name,
    required this.pronouns,
    required this.role,
    required this.description,
    required this.colorValue,
    required this.tags,
    this.note = '',
  });

  final String id;
  final String name;
  final String pronouns;
  final String role;
  final String description;
  final int colorValue;
  final List<String> tags;
  final String note;

  Color get color => Color(colorValue);

  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final word = parts.first;
      return word.substring(0, word.length >= 2 ? 2 : 1).toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Member copyWith({
    String? id,
    String? name,
    String? pronouns,
    String? role,
    String? description,
    int? colorValue,
    List<String>? tags,
    String? note,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      pronouns: pronouns ?? this.pronouns,
      role: role ?? this.role,
      description: description ?? this.description,
      colorValue: colorValue ?? this.colorValue,
      tags: tags ?? this.tags,
      note: note ?? this.note,
    );
  }
}
