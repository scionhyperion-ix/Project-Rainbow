import 'package:flutter/material.dart';

import '../models/front_session.dart';
import '../models/member.dart';
import '../sheets/front_session_sheet.dart';
import '../state/app_scope.dart';
import '../widgets/member_avatar.dart';
import '../widgets/quick_front_strip.dart';
import 'member_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  void _openMember(
    BuildContext context,
    Member member,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            MemberDetailPage(
          memberId: member.id,
        ),
      ),
    );
  }

  String _frontSubtitle(
    List<Member> fronting,
  ) {
    if (fronting.isEmpty) {
      return 'No one is currently fronting';
    }

    if (fronting.length == 1) {
      return '${fronting.first.name} is currently fronting';
    }

    return '${fronting.length} members are currently fronting';
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final theme = Theme.of(context);

    final fronting =
        store.frontingMembers;

    final frequent =
        store.frequentMembers(
      limit: 12,
    );

    return SafeArea(
      bottom: false,
      child: ListView(
        padding:
            const EdgeInsets.fromLTRB(
          18,
          14,
          18,
          120,
        ),
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Home',
                      style: theme
                          .textTheme
                          .headlineMedium,
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Text(
                      _frontSubtitle(
                        fronting,
                      ),
                      style: theme
                          .textTheme
                          .bodyMedium,
                    ),
                  ],
                ),
              ),

              IconButton.filledTonal(
                tooltip:
                    'Add or replace fronter',
                onPressed: () {
                  showFrontSessionSheet(
                    context,
                  );
                },
                icon: const Icon(
                  Icons
                      .person_add_alt_1_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 26),

          Text(
            fronting.length > 1
                ? 'Current fronts'
                : 'Current front',
            style:
                theme.textTheme.titleMedium,
          ),

          const SizedBox(height: 10),

          if (store
              .activeFrontSessions
              .isEmpty)
            const _NoCurrentFront()
          else
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(
                  8,
                ),
                child: Column(
                  children: [
                    for (var i = 0;
                        i <
                            store
                                .activeFrontSessions
                                .length;
                        i++) ...[
                      _ActiveFrontRow(
                        session: store
                                .activeFrontSessions[
                            i],
                      ),

                      if (i !=
                          store
                                  .activeFrontSessions
                                  .length -
                              1)
                        Divider(
                          height: 1,
                          indent: 62,
                          color: theme
                              .dividerColor,
                        ),
                    ],
                  ],
                ),
              ),
            ),

          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick front',
                      style: theme
                          .textTheme
                          .titleMedium,
                    ),

                    const SizedBox(
                      height: 2,
                    ),

                    Text(
                      'Frequently used',
                      style: theme
                          .textTheme
                          .bodyMedium,
                    ),
                  ],
                ),
              ),

              // Button only.
              // No Clear row inside the member picker.
              if (fronting.isNotEmpty)
                IconButton(
                  tooltip:
                      'End all current fronts',
                  onPressed: () {
                    store
                        .endAllActiveFronts();
                  },
                  icon: const Icon(
                    Icons
                        .stop_circle_outlined,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          QuickFrontStrip(
            members: frequent,
            frontingMemberIds:
                store.frontingMemberIds,
            onOpenMember: (member) {
              _openMember(
                context,
                member,
              );
            },
            onQuickFront: (member) {
              if (store.isFronting(
                member.id,
              )) {
                store
                    .endFrontSessionForMember(
                  member.id,
                );
              } else {
                store.startFrontSession(
                  memberId: member.id,
                );
              }
            },
          ),

          const SizedBox(height: 6),

          Text(
            'Tap a profile to open it. Hold to quickly add or end a front.',
            style:
                theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _NoCurrentFront
    extends StatelessWidget {
  const _NoCurrentFront();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme
                    .colorScheme.onSurface
                    .withOpacity(0.05),
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
              child: const Icon(
                Icons
                    .person_outline_rounded,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'No current front',
                    style: theme
                        .textTheme
                        .titleMedium,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    'Use the button above to start a session.',
                    style: theme
                        .textTheme
                        .bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveFrontRow
    extends StatelessWidget {
  const _ActiveFrontRow({
    required this.session,
  });

  final FrontSession session;

  String _formatStarted(
    BuildContext context,
  ) {
    final time =
        MaterialLocalizations.of(context)
            .formatTimeOfDay(
      TimeOfDay.fromDateTime(
        session.startedAt,
      ),
    );

    return 'Started $time';
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final theme = Theme.of(context);

    final member =
        store.memberById(
      session.memberId,
    );

    if (member == null) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) =>
                MemberDetailPage(
              memberId: member.id,
            ),
          ),
        );
      },
      borderRadius:
          BorderRadius.circular(14),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 10,
        ),
        child: Row(
          children: [
            MemberAvatar(
              member: member,
              size: 46,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: theme
                        .textTheme
                        .titleMedium,
                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  Text(
                    _formatStarted(
                      context,
                    ),
                    style: theme
                        .textTheme
                        .bodyMedium,
                  ),

                  if (session
                      .note.isNotEmpty) ...[
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      session.note,
                      maxLines: 2,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style: theme
                          .textTheme
                          .bodyMedium,
                    ),
                  ],
                ],
              ),
            ),

            Icon(
              Icons
                  .chevron_right_rounded,
              color: theme
                  .textTheme
                  .bodyMedium
                  ?.color,
            ),
          ],
        ),
      ),
    );
  }
}