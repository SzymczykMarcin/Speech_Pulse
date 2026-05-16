import 'person.dart';

class CountEvent {
  const CountEvent({required this.personId, required this.personName});

  final String personId;
  final String personName;
}

class MeetingParticipant {
  const MeetingParticipant({required this.person, this.count = 0});

  final Person person;
  final int count;

  MeetingParticipant copyWith({Person? person, int? count}) {
    return MeetingParticipant(
      person: person ?? this.person,
      count: count ?? this.count,
    );
  }
}

class MeetingSession {
  MeetingSession(List<Person> people)
      : participants =
            people.map((person) => MeetingParticipant(person: person)).toList(),
        selectedPersonId = people.first.id;

  List<MeetingParticipant> participants;
  String selectedPersonId;
  final List<CountEvent> _events = [];

  List<CountEvent> get events => List.unmodifiable(_events);
  CountEvent? get lastEvent => _events.isEmpty ? null : _events.last;
  int get totalCount => participants.fold(0, (sum, item) => sum + item.count);

  MeetingParticipant get selectedParticipant {
    return participants
        .firstWhere((item) => item.person.id == selectedPersonId);
  }

  void select(String personId) {
    if (participants.any((item) => item.person.id == personId)) {
      selectedPersonId = personId;
    }
  }

  void incrementSelected() {
    final selected = selectedParticipant;
    _events.add(
      CountEvent(
          personId: selected.person.id, personName: selected.person.name),
    );
    _replaceCount(selected.person.id, selected.count + 1);
  }

  bool undoLast() {
    if (_events.isEmpty) {
      return false;
    }
    final event = _events.removeLast();
    final participant = participants.firstWhere(
      (item) => item.person.id == event.personId,
    );
    _replaceCount(event.personId, participant.count - 1);
    return true;
  }

  void _replaceCount(String personId, int count) {
    participants = participants
        .map(
          (item) => item.person.id == personId
              ? item.copyWith(count: count < 0 ? 0 : count)
              : item,
        )
        .toList();
  }
}
