import '../models/meeting_session.dart';

class ReportBuilder {
  static String build(MeetingSession session) {
    final lines = <String>[
      'Speech Pulse Meeting Report',
      '',
      'Participant summary:',
      for (final participant in session.participants)
        '- ${participant.person.name}: ${participant.count} filler sounds',
      '',
      'Total: ${session.totalCount} filler sounds',
    ];
    return lines.join('\n');
  }
}
