import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants.dart';
import '../models/estudiante.dart';
import '../models/submission.dart';
import '../services/db_service.dart';

/// Datos agregados del estudiante para el Locker
class StudentStats {
  final Estudiante student;
  final List<Submission> submissions;
  final double accuracyGlobal; // 0..1

  const StudentStats({
    required this.student,
    required this.submissions,
    required this.accuracyGlobal,
  });
}

class StudentRepository {
  final DbService db;
  final FirebaseFirestore _fs;

  StudentRepository({DbService? dbService, FirebaseFirestore? instance})
    : db = dbService ?? DbService(instance: instance),
      _fs = instance ?? FirebaseFirestore.instance;

  /// Obtiene un estudiante por id (una sola vez)
  Future<Estudiante?> getStudent(String id) async {
    final snap = await _fs.collection(colStudents).doc(id).get();
    if (!snap.exists) return null;
    return Estudiante.fromMap(snap.id, snap.data()!);
  }

  /// Observa un estudiante y sus submissions con agregados (accuracy global)
  Stream<StudentStats?> watchStudentStats(String studentId) async* {
    // Trae el estudiante una vez
    final est = await getStudent(studentId);
    if (est == null) {
      yield null;
      return;
    }
    // Escucha sus entregas
    await for (final list in db.watchSubmissionsByStudent(studentId)) {
      final acc = _promedio(list);
      yield StudentStats(student: est, submissions: list, accuracyGlobal: acc);
    }
  }

  double _promedio(List<Submission> list) {
    if (list.isEmpty) return 0;
    final sum = list.map((s) => s.accuracy).fold<double>(0, (a, b) => a + b);
    return sum / list.length;
  }
}
