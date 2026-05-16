import 'package:flutter_test/flutter_test.dart';
import 'package:speech_pulse/models/person.dart';

void main() {
  test('person name validation rejects empty names', () {
    expect(Person.validateName(''), isNotNull);
    expect(Person.validateName('   '), isNotNull);
    expect(Person.validateName('Anna'), isNull);
  });

  test('person list encodes and decodes stable local data', () {
    const people = [
      Person(id: '1', name: 'Anna'),
      Person(id: '2', name: 'Guest', isGuest: true),
    ];

    final encoded = Person.encodeList(people);
    final decoded = Person.decodeList(encoded);

    expect(decoded, hasLength(2));
    expect(decoded.first.id, '1');
    expect(decoded.last.isGuest, isTrue);
  });
}
