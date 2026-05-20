import 'package:flutter_test/flutter_test.dart';
import 'package:speech_pulse/models/meeting_session.dart';
import 'package:speech_pulse/models/person.dart';

void main() {
  const people = [
    Person(id: 'anna', name: 'Anna'),
    Person(id: 'david', name: 'David'),
  ];

  test('requires at least one participant', () {
    expect(() => MeetingSession(const []), throwsArgumentError);
  });

  test('increments the currently selected participant', () {
    final session = MeetingSession(people);

    session.incrementSelected();
    session.select('david');
    session.incrementSelected();
    session.incrementSelected();

    expect(session.participants[0].count, 1);
    expect(session.participants[1].count, 2);
    expect(session.totalCount, 3);
  });

  test('undo reverses the most recent event even after switching participant',
      () {
    final session = MeetingSession(people);

    session.incrementSelected();
    session.select('david');
    session.incrementSelected();
    session.select('anna');

    expect(session.undoLast(), isTrue);
    expect(session.participants[0].count, 1);
    expect(session.participants[1].count, 0);
    expect(session.selectedPersonId, 'anna');
  });

  test('undo returns false when there is no event', () {
    final session = MeetingSession(people);

    expect(session.undoLast(), isFalse);
    expect(session.totalCount, 0);
  });
}
