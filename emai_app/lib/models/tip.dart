import 'dart:convert';

/// “Tip” o consejo para la guía de captura y buenas prácticas.
class Tip {
  final String id;
  final String title;
  final String description;
  final int order;

  Tip({
    required this.id,
    required this.title,
    required this.description,
    this.order = 0,
  });

  Tip copyWith({String? id, String? title, String? description, int? order}) =>
      Tip(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        order: order ?? this.order,
      );

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'order': order,
  };

  factory Tip.fromMap(String id, Map<String, dynamic> map) => Tip(
    id: id,
    title: (map['title'] ?? '').toString(),
    description: (map['description'] ?? '').toString(),
    order: int.tryParse(map['order']?.toString() ?? '0') ?? 0,
  );

  String toJson() => json.encode(toMap());
  factory Tip.fromJson(String id, String source) =>
      Tip.fromMap(id, json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Tip($id, $title)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Tip && id == other.id;
  @override
  int get hashCode => id.hashCode;
}
