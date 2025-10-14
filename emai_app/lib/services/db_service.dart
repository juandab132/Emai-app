import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/constants.dart';
import '../models/estudiante.dart';
import '../models/examen.dart';
import '../models/submission.dart';

/// Servicio de acceso a Firestore para EMAI.
/// Requiere haber inicializado Firebase en main() antes de usarlo.
class DbService {
  final FirebaseFirestore _db;
  DbService({FirebaseFirestore? instance})
    : _db = instance ?? FirebaseFirestore.instance;

  // ---------- Estudiantes ----------

  Future<void> addStudent(Estudiante e) async {
    final ref = _db.collection(colStudents).doc(e.id.isEmpty ? null : e.id);
    final doc = e.toMap();
    await (e.id.isEmpty ? ref.set(doc) : ref.set(doc, SetOptions(merge: true)));
  }

  Stream<List<Estudiante>> watchStudents({String? grade}) {
    Query<Map<String, dynamic>> q = _db.collection(colStudents).orderBy('name');
    if (grade != null && grade.isNotEmpty) {
      q = q.where('grade', isEqualTo: grade);
    }
    return q.snapshots().map(
      (snap) =>
          snap.docs.map((d) => Estudiante.fromMap(d.id, d.data())).toList(),
    );
  }

  // ---------- Evaluaciones ----------

  Future<void> addEvaluation(Examen x) async {
    final ref = _db.collection(colEvaluations).doc(x.id.isEmpty ? null : x.id);
    await (x.id.isEmpty
        ? ref.set(x.toMap())
        : ref.set(x.toMap(), SetOptions(merge: true)));
  }

  Stream<List<Examen>> watchEvaluations({String? grade}) {
    Query<Map<String, dynamic>> q = _db
        .collection(colEvaluations)
        .orderBy('date', descending: true);
    if (grade != null && grade.isNotEmpty) {
      q = q.where('grade', isEqualTo: grade);
    }
    return q.snapshots().map(
      (snap) => snap.docs.map((d) => Examen.fromMap(d.id, d.data())).toList(),
    );
  }

  // ---------- Entregas (Submissions) ----------

  Future<void> addSubmission(Submission s) async {
    final ref = _db.collection(colSubmissions).doc(s.id.isEmpty ? null : s.id);
    await (s.id.isEmpty
        ? ref.set(s.toMap())
        : ref.set(s.toMap(), SetOptions(merge: true)));
  }

  Stream<List<Submission>> watchSubmissionsByStudent(String studentId) {
    return _db
        .collection(colSubmissions)
        .where('studentId', isEqualTo: studentId)
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Submission.fromMap(d.id, d.data())).toList(),
        );
  }

  /// Entregas por grado: hace join “lógico” en la app.
  /// 1) Trae evaluaciones del grado; 2) usa sus ids para filtrar submissions.
  Stream<List<Submission>> watchSubmissionsByGrade(String grade) async* {
    // 1) Obtiene evaluaciones del grado (escucha activa)
    await for (final evals in watchEvaluations(grade: grade)) {
      final ids = evals.map((e) => e.id).toList();
      if (ids.isEmpty) {
        yield <Submission>[];
        continue;
      }
      // 2) Filtra submissions por evaluationId IN ids (si IN excede 10, particiona)
      // Firestore IN máx 10 elementos -> particionar si es necesario:
      final chunks = <List<String>>[];
      for (var i = 0; i < ids.length; i += 10) {
        chunks.add(ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10));
      }

      final futures = chunks.map(
        (chunk) =>
            _db
                .collection(colSubmissions)
                .where('evaluationId', whereIn: chunk)
                .snapshots(),
      );

      // Combinar streams: para MVP, emitimos el primero en llegar y
      // hacemos una re-colección simple cada vez que cambie un chunk.
      final List<Submission> buffer = [];
      await for (final snap in StreamGroup.merge(futures)) {
        buffer
          ..clear()
          ..addAll(snap.docs.map((d) => Submission.fromMap(d.id, d.data())));
        yield List<Submission>.from(buffer);
      }
    }
  }
}

/// Utilidad simple para combinar múltiples streams en uno (para el caso IN particionado).
/// Para algo más robusto, usa `rxdart` o maneja la agregación en repositorio/estado.
class StreamGroup<T> {
  static Stream<T> merge<T>(Iterable<Stream<T>> streams) async* {
    final controller = StreamController<T>();
    final subs = <StreamSubscription<T>>[];

    for (final s in streams) {
      subs.add(s.listen(controller.add, onError: controller.addError));
    }
    // Emitimos lo que el controller produzca
    yield* controller.stream;

    // Limpieza (no suele ejecutarse en generadores; sirve como referencia)
    for (final sub in subs) {
      await sub.cancel();
    }
    await controller.close();
  }
}
