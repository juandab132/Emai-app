import 'dart:convert';

class Profesor {
  final String id;
  final String name;
  final String email;

  Profesor({required this.id, required this.name, required this.email});

  Profesor copyWith({String? id, String? name, String? email}) => Profesor(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
  );

  Map<String, dynamic> toMap() => {'name': name, 'email': email};

  factory Profesor.fromMap(String id, Map<String, dynamic> map) => Profesor(
    id: id,
    name: (map['name'] ?? '').toString(),
    email: (map['email'] ?? '').toString(),
  );

  String toJson() => json.encode(toMap());
  factory Profesor.fromJson(String id, String source) =>
      Profesor.fromMap(id, json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Profesor($id, $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profesor && id == other.id && email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
