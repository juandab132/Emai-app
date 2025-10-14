import 'dart:convert';

/// Resultado de evaluar una línea "A op B = C".
class OperationResult {
  final String expression; // "12 + 5 = 17"
  final bool correct;
  final num expected; // 17 (o NaN si indefinido)
  final String message; // "Resultado esperado: 17" | "indefinido"
  final String? tag; // etiqueta de error simple (opcional)

  OperationResult({
    required this.expression,
    required this.correct,
    required this.expected,
    required this.message,
    this.tag,
  });

  OperationResult copyWith({
    String? expression,
    bool? correct,
    num? expected,
    String? message,
    String? tag,
  }) {
    return OperationResult(
      expression: expression ?? this.expression,
      correct: correct ?? this.correct,
      expected: expected ?? this.expected,
      message: message ?? this.message,
      tag: tag ?? this.tag,
    );
  }

  Map<String, dynamic> toMap() => {
    'expression': expression,
    'correct': correct,
    'expected': expected,
    'message': message,
    'tag': tag,
  };

  factory OperationResult.fromMap(Map<String, dynamic> map) => OperationResult(
    expression: (map['expression'] ?? '').toString(),
    correct: map['correct'] == true,
    expected: num.tryParse(map['expected']?.toString() ?? '') ?? double.nan,
    message: (map['message'] ?? '').toString(),
    tag: map['tag']?.toString(),
  );

  String toJson() => json.encode(toMap());
  factory OperationResult.fromJson(String source) =>
      OperationResult.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'OperationResult($expression, $correct, exp=$expected)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OperationResult &&
          expression == other.expression &&
          correct == other.correct &&
          expected == other.expected &&
          message == other.message &&
          tag == other.tag;

  @override
  int get hashCode =>
      expression.hashCode ^
      correct.hashCode ^
      expected.hashCode ^
      message.hashCode ^
      tag.hashCode;
}
