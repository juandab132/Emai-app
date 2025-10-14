import 'dart:convert';

class Examen {
  final String id;
  final String title;
  final String grade; // "3A"
  final DateTime date; // fecha de aplicación
  final bool closed; // si acepta entregas

  Examen({
    required this.id,
    required this.title,
    required this.grade,
    required this.date,
    this.closed = false,
  });

  Examen copyWith({
    String? id,
    String? title,
    String? grade,
    DateTime? date,
    bool? closed,
  }) {
    return Examen(
      id: id ?? this.id,
      title: title ?? this.title,
      grade: grade ?? this.grade,
      date: date ?? this.date,
      closed: closed ?? this.closed,
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'grade': grade,
    'date': date.toIso8601String(),
    'closed': closed,
  };

  factory Examen.fromMap(String id, Map<String, dynamic> map) => Examen(
    id: id,
    title: (map['title'] ?? '').toString(),
    grade: (map['grade'] ?? '').toString(),
    date: DateTime.tryParse(map['date']?.toString() ?? '') ?? DateTime.now(),
    closed: map['closed'] == true,
  );

  String toJson() => json.encode(toMap());
  factory Examen.fromJson(String id, String source) =>
      Examen.fromMap(id, json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Examen($id, $title, $grade)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Examen && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
