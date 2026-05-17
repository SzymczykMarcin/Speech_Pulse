import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../debug_log.dart';
import '../models/meeting_session.dart';
import '../services/report_builder.dart';
import '../theme.dart';
import '../widgets/pulse_widgets.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key, required this.session});

  final MeetingSession session;

  @override
  Widget build(BuildContext context) {
    return PulsePage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Meeting Report',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: context.pulseOnSurface,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SurfacePanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.assignment_outlined,
                          color: context.pulseSecondary),
                      const SizedBox(width: 8),
                      const Text(
                        'Participant Summary',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: session.participants.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final participant = session.participants[index];
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: context.pulseSurfaceHigh,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    participant.person.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text('${participant.count} filler sounds'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        '${session.totalCount}',
                        style: TextStyle(
                          color: context.pulsePrimary,
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () async {
              appDebugLog('Report: Copy Report tapped');
              await Clipboard.setData(
                ClipboardData(text: ReportBuilder.build(session)),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report copied')),
                );
              }
            },
            icon: const Icon(Icons.content_copy),
            label: const Text('Copy Report'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    appDebugLog('Report: New Meeting tapped');
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Meeting'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    appDebugLog('Report: Back Home tapped');
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Back Home'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
