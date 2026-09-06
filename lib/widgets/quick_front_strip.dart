import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/member.dart';

class QuickFrontStrip extends StatelessWidget {
  const QuickFrontStrip({
    super.key,
    required this.members,
    required this.frontingMemberIds,
    required this.onOpenMember,
    required this.onQuickFront,
  });

  final List<Member> members;
  final Set<String> frontingMemberIds;

  final ValueChanged<Member> onOpenMember;
  final ValueChanged<Member> onQuickFront;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            'Fronting history will build your frequent list.',
            style:
                Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return SizedBox(
      height: 102,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics:
            const BouncingScrollPhysics(),
        itemCount: members.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final member = members[index];

          return _QuickFrontTile(
            member: member,
            isFronting:
                frontingMemberIds.contains(
              member.id,
            ),
            onTap: () {
              onOpenMember(member);
            },
            onLongPress: () {
              HapticFeedback.mediumImpact();
              onQuickFront(member);
            },
          );
        },
      ),
    );
  }
}

class _QuickFrontTile
    extends StatelessWidget {
  const _QuickFrontTile({
    required this.member,
    required this.isFronting,
    required this.onTap,
    required this.onLongPress,
  });

  final Member member;
  final bool isFronting;

  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 72,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: member.color.withOpacity(
                      theme.brightness ==
                              Brightness.dark
                          ? 0.28
                          : 0.17,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                  child: Text(
                    member.initials,
                    style: TextStyle(
                      color: member.color,
                      fontSize: 17,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ),

                if (isFronting)
                  Positioned(
                    right: -3,
                    top: -3,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: member.color,
                        borderRadius:
                            BorderRadius.circular(
                          7,
                        ),
                        border: Border.all(
                          color: theme
                              .scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              member.name,
              maxLines: 1,
              overflow:
                  TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(
                color:
                    theme.colorScheme.onSurface,
                fontSize: 12,
                fontWeight: isFronting
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}