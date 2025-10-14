import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants.dart';
import '../models/estudiante.dart';
import '../models/submission.dart';
import '../services/db_service.dart';

/// Fila para el reporte general del curso
class CourseRow {
  final String studentId;
  final String studentName;
  final String grade;
  final double accuracy; // 0..1
  final int submissionsCount;

  const CourseRow({
    required this.studentId,
    required this.studentName,
    required this.grade,
    required this.accuracy,
    required this.submissionsCount,
  });
}

/// Resumen del curso (precisión global + filas)
class CourseReport {
  final String grade;
  final double accuracyGlobal; // promedio de estudiantes
  final List<CourseRow> rows;

  const CourseReport({
    required this.grade,
    required this.accuracyGlobal,
    required this.rows,
  });
}

class ExamRepository {
  final DbService db;
  final FirebaseFirestore _fs;

  ExamRepository({DbService? dbService, FirebaseFirestore? instance})
    : db = dbService ?? DbService(instance: instance),
      _fs = instance ?? FirebaseFirestore.instance;

  /// Observa el reporte del curso (por grado): une estudiantes + submissions del grado
  Stream<CourseReport> watchCourseReport(String grade) {
    final students$ = _fs
        .collection(colStudents)
        .where('grade', isEqualTo: grade)
        .orderBy('name')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Estudiante.fromMap(d.id, d.data())).toList(),
        );

    final submissions$ = db.watchSubmissionsByGrade(grade);

    return _combineLatest<List<Estudiante>, List<Submission>, CourseReport>(
      students$,
      submissions$,
      (students, subs) {
        final rows = <CourseRow>[];

        for (final st in students) {
          final mySubs = subs.where((s) => s.studentId == st.id).toList();
          final acc = _promedio(mySubs);
          rows.add(
            CourseRow(
              studentId: st.id,
              studentName: st.name,
              grade: st.grade,
              accuracy: acc,
              submissionsCount: mySubs.length,
            ),
          );
        }

        final global =
            rows.isEmpty
                ? 0
                : rows.map((r) => r.accuracy).fold<double>(0, (a, b) => a + b) /
                    rows.length;

        return CourseReport(
          grade: grade,
          accuracyGlobal: global.toDouble(),
          rows: rows,
        );
      },
    );
  }

  double _promedio(List<Submission> list) {
    if (list.isEmpty) return 0;
    final sum = list.map((s) => s.accuracy).fold<double>(0, (a, b) => a + b);
    return sum / list.length;
  }

  /// Pequeño combinador tipo combineLatest (sin rxdart)
  Stream<R> _combineLatest<A, B, R>(
    Stream<A> a$,
    Stream<B> b$,
    R Function(A a, B b) projector,
  ) async* {
    A? lastA;
    B? lastB;
    bool hasA = false, hasB = false;

    late StreamSubscription subA;
    late StreamSubscription subB;
    final controller = StreamController<R>();

    void emitIfReady() {
      if (hasA && hasB) {
        controller.add(projector(lastA as A, lastB as B));
      }
    }

    subA = a$.listen((a) {
      lastA = a;
      hasA = true;
      emitIfReady();
    }, onError: controller.addError);

    subB = b$.listen((b) {
      lastB = b;
      hasB = true;
      emitIfReady();
    }, onError: controller.addError);

    yield* controller.stream;

    await subA.cancel();
    await subB.cancel();
    await controller.close();
  }
}
