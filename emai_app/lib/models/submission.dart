import 'dart:convert';
import 'operation_result.dart';

/// Entrega de un estudiante para una evaluación.
class Submission {
  final String id;
  final String studentId;
  final String evaluationId;
  final DateTime submittedAt;
  final List<OperationResult> results;

  Submission({
    required this.id,
    required this.studentId,
    required this.evaluationId,
    required this.submittedAt,
    required this.results,
  });

  double get accuracy {
    if (results.isEmpty) return 0;
    final corrects = results.where((r) => r.correct).length;
    return corrects / results.length;
  }

  Submission copyWith({
    String? id,
    String? studentId,
    String? evaluationId,
    DateTime? submittedAt,
    List<OperationResult>? results,
  }) {
    return Submission(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      evaluationId: evaluationId ?? this.evaluationId,
      submittedAt: submittedAt ?? this.submittedAt,
      results: results ?? this.results,
    );
  }

  Map<String, dynamic> toMap() => {
    'studentId': studentId,
    'evaluationId': evaluationId,
    'submittedAt': submittedAt.toIso8601String(),
    'results': results.map((e) => e.toMap()).toList(),
  };

  factory Submission.fromMap(String id, Map<String, dynamic> map) => Submission(
    id: id,
    studentId: (map['studentId'] ?? '').toString(),
    evaluationId: (map['evaluationId'] ?? '').toString(),
    submittedAt:
        DateTime.tryParse(map['submittedAt']?.toString() ?? '') ??
        DateTime.now(),
    results:
        ((map['results'] as List?) ?? const [])
            .map(
              (e) =>
                  OperationResult.fromMap(Map<String, dynamic>.from(e as Map)),
            )
            .toList(),
  );

  String toJson() => json.encode(toMap());
  factory Submission.fromJson(String id, String source) =>
      Submission.fromMap(id, json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Submission($id, student=$studentId, eval=$evaluationId, acc=${accuracy.toStringAsFixed(2)})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Submission && id == other.id);

  @override
  int get hashCode => id.hashCode;
}
