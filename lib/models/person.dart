import 'dart:convert';

class Person {
  const Person({required this.id, required this.name, this.isGuest = false});

  final String id;
  final String name;
  final bool isGuest;

  static String? validateName(String value) {
    return value.trim().isEmpty ? 'Name is required' : null;
  }

  Person copyWith({String? id, String? name, bool? isGuest}) {
    return Person(
      id: id ?? this.id,
      name: name ?? this.name,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'isGuest': isGuest,
      };

  factory Person.fromJson(Map<String, Object?> json) {
    return Person(
      id: json['id'] as String,
      name: json['name'] as String,
      isGuest: json['isGuest'] as bool? ?? false,
    );
  }

  static List<Person> decodeList(String raw) {
    final values = jsonDecode(raw) as List<dynamic>;
    return values
        .map((value) => Person.fromJson(value as Map<String, Object?>))
        .toList();
  }

  static String encodeList(List<Person> people) {
    return jsonEncode(people.map((person) => person.toJson()).toList());
  }
}
