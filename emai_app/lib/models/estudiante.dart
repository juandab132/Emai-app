import 'dart:convert';

class Estudiante {
  final String id;
  final String name;
  final String grade; // ej: "3A"
  final DateTime createdAt;

  Estudiante({
    required this.id,
    required this.name,
    required this.grade,
    required this.createdAt,
  });

  Estudiante copyWith({
    String? id,
    String? name,
    String? grade,
    DateTime? createdAt,
  }) {
    return Estudiante(
      id: id ?? this.id,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'grade': grade,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Estudiante.fromMap(String id, Map<String, dynamic> map) {
    return Estudiante(
      id: id,
      name: (map['name'] ?? '').toString(),
      grade: (map['grade'] ?? '').toString(),
      createdAt:
          DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());
  factory Estudiante.fromJson(String id, String source) =>
      Estudiante.fromMap(id, json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Estudiante($id, $name, $grade)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Estudiante &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          grade == other.grade;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ grade.hashCode;
}
