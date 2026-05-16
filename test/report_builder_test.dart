import 'package:flutter_test/flutter_test.dart';
import 'package:speech_pulse/models/meeting_session.dart';
import 'package:speech_pulse/models/person.dart';
import 'package:speech_pulse/services/report_builder.dart';

void main() {
  test('builds a plain-text meeting report', () {
    final session = MeetingSession(const [
      Person(id: 'anna', name: 'Anna'),
      Person(id: 'david', name: 'David'),
    ]);
    session.incrementSelected();
    session.select('david');
    session.incrementSelected();

    final report = ReportBuilder.build(session);

    expect(report, contains('Speech Pulse Meeting Report'));
    expect(report, contains('- Anna: 1 filler sounds'));
    expect(report, contains('- David: 1 filler sounds'));
    expect(report, contains('Total: 2 filler sounds'));
  });
}
