import 'package:flutter/material.dart';

import '../models/member.dart';

class MemberAvatar extends StatelessWidget {
  const MemberAvatar({
    super.key,
    required this.member,
    this.size = 48,
  });

  final Member member;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: member.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Text(
        member.initials,
        style: TextStyle(
          color: member.color,
          fontSize: size * 0.31,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
