import 'dart:async';

import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../models/meeting_session.dart';
import '../models/person.dart';
import '../services/app_store.dart';
import '../services/count_sound_player.dart';
import '../theme.dart';
import 'report_screen.dart';

class ActiveMeetingScreen extends StatefulWidget {
  const ActiveMeetingScreen({
    super.key,
    required this.store,
    required this.participants,
    this.playCountSound,
  });

  final AppStore store;
  final List<Person> participants;
  final Future<void> Function(CountButtonOption option)? playCountSound;

  @override
  State<ActiveMeetingScreen> createState() => _ActiveMeetingScreenState();
}

class _ActiveMeetingScreenState extends State<ActiveMeetingScreen> {
  late final MeetingSession _session;
  CountSoundPlayer? _soundPlayer;

  @override
  void initState() {
    super.initState();
    _session = MeetingSession(widget.participants);
    if (widget.playCountSound == null) {
      _soundPlayer = CountSoundPlayer();
    }
  }

  @override
  void dispose() {
    _soundPlayer?.dispose();
    super.dispose();
  }

  void _increment() {
    setState(_session.incrementSelected);
    final option = widget.store.settings.countButtonOption;
    final player = widget.playCountSound;
    if (player != null) {
      unawaited(player(option));
    } else {
      unawaited(_soundPlayer!.play(option));
    }
  }

  void _endMeeting() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ReportScreen(session: _session)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = _session.selectedParticipant;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              decoration: const BoxDecoration(
                color: PulseColors.background,
                border: Border(bottom: BorderSide(color: Colors.white10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('PARTICIPANTS', style: PulseText.label),
                      const SizedBox(width: 8),
                      Text(
                        '(${_session.participants.length})',
                        style: const TextStyle(
                          color: PulseColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    key: const Key('participantSelector'),
                    constraints: const BoxConstraints(maxHeight: 124),
                    child: SingleChildScrollView(
                      primary: false,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final participant in _session.participants)
                            _ParticipantChip(
                              participant: participant,
                              selected: participant.person.id ==
                                  _session.selectedPersonId,
                              onTap: () => setState(
                                () => _session.select(participant.person.id),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final buttonSize =
                      (constraints.maxHeight * 0.48).clamp(160.0, 256.0);
                  final compact = constraints.maxHeight < 340;
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('COUNTING FOR:', style: PulseText.label),
                            const SizedBox(height: 6),
                            Text(
                              selected.person.name,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: PulseColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            SizedBox(height: compact ? 12 : 20),
                            SizedBox(
                              width: buttonSize,
                              height: buttonSize,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: PulseColors.primaryContainer
                                          .withOpacity(0.22),
                                      blurRadius: 40,
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  key: const Key('countButton'),
                                  style: ElevatedButton.styleFrom(
                                    enableFeedback: false,
                                    shape: const CircleBorder(),
                                    backgroundColor: PulseColors.primary,
                                  ),
                                  onPressed: _increment,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        widget.store.settings.countButtonOption
                                            .iconAsset,
                                        width: buttonSize < 220 ? 64 : 96,
                                        height: buttonSize < 220 ? 64 : 96,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'AH',
                                        style: TextStyle(
                                          fontSize: buttonSize < 220 ? 48 : 72,
                                          fontWeight: FontWeight.w800,
                                          color: PulseColors.onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: compact ? 8 : 16),
                            SizedBox(
                              height: 40,
                              child: Center(
                                child: Text(
                                  _session.lastEvent == null
                                      ? 'Ready'
                                      : 'Last: ${_session.lastEvent!.personName} +1',
                                  style: const TextStyle(
                                    color: PulseColors.secondary,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const Key('undoButton'),
                      onPressed: _session.events.isEmpty
                          ? null
                          : () => setState(_session.undoLast),
                      icon: const Icon(Icons.undo),
                      label: const Text('Undo'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        enableFeedback: false,
                        backgroundColor: PulseColors.surfaceHigh,
                        foregroundColor: PulseColors.error,
                        side: const BorderSide(color: PulseColors.error),
                      ),
                      onPressed: _endMeeting,
                      icon: const Icon(Icons.stop_circle_outlined),
                      label: const Text('End Meeting'),
                    ),
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

class _ParticipantChip extends StatelessWidget {
  const _ParticipantChip({
    required this.participant,
    required this.selected,
    required this.onTap,
  });

  final MeetingParticipant participant;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor:
          selected ? PulseColors.primaryContainer : PulseColors.surface,
      side: BorderSide(
        color: selected ? PulseColors.primary : PulseColors.outline,
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            participant.person.name,
            style: TextStyle(
              color: selected
                  ? PulseColors.onPrimary
                  : PulseColors.onSurfaceVariant,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              color: selected
                  ? PulseColors.background.withOpacity(0.18)
                  : PulseColors.surfaceVariant,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              child: Text(
                '${participant.count}',
                style: TextStyle(
                  color: selected
                      ? PulseColors.onPrimary
                      : PulseColors.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
