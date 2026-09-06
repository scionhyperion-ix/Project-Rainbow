import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/member.dart';
import 'member_avatar.dart';

class QuickFrontStrip extends StatelessWidget {
  const QuickFrontStrip({
    super.key,
    required this.members,
    required this.frontingMemberId,
    required this.onOpenMember,
    required this.onFrontChanged,
  });

  final List<Member> members;
  final String? frontingMemberId;
  final ValueChanged<Member> onOpenMember;
  final ValueChanged<String?> onFrontChanged;

  List<Member> get _orderedMembers {
    final result = [...members];

    result.sort((a, b) {
      if (a.id == frontingMemberId && b.id != frontingMemberId) return -1;
      if (b.id == frontingMemberId && a.id != frontingMemberId) return 1;
      return 0;
    });
    return result.take(12).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _orderedMembers;

    if (visible.isEmpty) {
      return SizedBox(
        height: 94,
        child: Center(
          child: Text(
            'Add a member to use quick front.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return SizedBox(
      height: 102,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final slotWidth = (constraints.maxWidth / 4.6).clamp(72.0, 88.0);

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: visible.length,
            itemBuilder: (context, index) {
              final member = visible[index];

              return SizedBox(
                width: slotWidth,
                child: _QuickFrontTile(
                  member: member,
                  isFronting: member.id == frontingMemberId,
                  onTap: () => onOpenMember(member),
                  onHoldComplete: () {
                    if (member.id == frontingMemberId) {
                      onFrontChanged(null);
                    } else {
                      onFrontChanged(member.id);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _QuickFrontTile extends StatefulWidget {
  const _QuickFrontTile({
    required this.member,
    required this.isFronting,
    required this.onTap,
    required this.onHoldComplete,
  });

  final Member member;
  final bool isFronting;
  final VoidCallback onTap;
  final VoidCallback onHoldComplete;

  @override
  State<_QuickFrontTile> createState() => _QuickFrontTileState();
}

class _QuickFrontTileState extends State<_QuickFrontTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _holdController;
  bool _holding = false;

  @override
  void initState() {
    super.initState();

    _holdController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          HapticFeedback.mediumImpact();
          widget.onHoldComplete();
          _holdController.reset();

          if (mounted) {
            setState(() => _holding = false);
          }
        }
      });
  }

  @override
  void dispose() {
    _holdController.dispose();
    super.dispose();
  }

  void _startHold() {
    HapticFeedback.selectionClick();
    setState(() => _holding = true);
    _holdController.forward(from: 0);
  }

  void _cancelHold() {
    if (_holdController.status != AnimationStatus.completed) {
      _holdController.reset();
    }

    if (mounted) {
      setState(() => _holding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ringColor = widget.member.color;

    return Semantics(
      button: true,
      label: widget.member.name,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onLongPressStart: (_) => _startHold(),
        onLongPressEnd: (_) => _cancelHold(),
        onLongPressCancel: _cancelHold,
        child: AnimatedScale(
          scale: _holding ? 0.94 : 1,
          duration: const Duration(milliseconds: 100),
          child: Column(
            children: [
              SizedBox(
                width: 66,
                height: 66,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (widget.isFronting)
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19),
                          border: Border.all(
                            color: ringColor,
                            width: 3,
                          ),
                        ),
                      ),
                    AnimatedBuilder(
                      animation: _holdController,
                      builder: (context, _) {
                        if (_holdController.value == 0 ||
                            widget.isFronting) {
                          return const SizedBox.shrink();
                        }

                        return SizedBox(
                          width: 64,
                          height: 64,
                          child: CustomPaint(
                            painter: _HoldRingPainter(
                              progress: _holdController.value,
                              color: ringColor,
                            ),
                          ),
                        );
                      },
                    ),
                    MemberAvatar(
                      member: widget.member,
                      size: 56,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Text(
                  widget.member.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: widget.isFronting
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HoldRingPainter extends CustomPainter {
  const _HoldRingPainter({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(
      1.5,
      1.5,
      size.width - 3,
      size.height - 3,
    );

    canvas.drawArc(
      rect,
      -1.5708,
      6.28318 * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _HoldRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}
