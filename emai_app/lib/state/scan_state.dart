import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../models/operation_result.dart';
import '../models/submission.dart';
import '../services/ocr_service.dart';
import '../services/analisis_service.dart';
import '../services/db_service.dart';

class ScanState extends ChangeNotifier {
  final OcrService ocr;
  final AnalisisService analisis;
  final DbService db;

  ScanState({required this.ocr, required this.analisis, required this.db});

  bool _loading = false;
  bool get loading => _loading;

  List<OperationResult> _results = [];
  List<OperationResult> get results => _results;

  double get accuracy {
    if (_results.isEmpty) return 0;
    final corrects = _results.where((e) => e.correct).length;
    return corrects / _results.length;
  }

  String? _error;
  String? get error => _error;

  bool _childMode = false;
  bool get childMode => _childMode;
  void toggleChildMode(bool v) {
    _childMode = v;
    notifyListeners();
  }

  XFile? _lastImage;
  XFile? get lastImage => _lastImage;

  Future<void> processImage(XFile image) async {
    _loading = true;
    _error = null;
    _results = [];
    _lastImage = image;
    notifyListeners();

    try {
      final text = await ocr.recognizeTextFromImage(image);
      _results = analisis.parseAndEvaluate(text);
      if (_results.isEmpty) {
        _error = 'No se detectaron operaciones válidas en la imagen.';
      }
    } catch (e) {
      _error = 'Ocurrió un error procesando la imagen.';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> saveSubmission({
    required String studentId,
    required String evaluationId,
    DateTime? when,
  }) async {
    if (_results.isEmpty) {
      _error = 'No hay resultados para guardar.';
      notifyListeners();
      return;
    }
    final submission = Submission(
      id: '', // Firestore generará el ID
      studentId: studentId,
      evaluationId: evaluationId,
      submittedAt: when ?? DateTime.now(),
      results: List<OperationResult>.from(_results),
    );
    await db.addSubmission(submission);
  }

  void clear() {
    _results = [];
    _error = null;
    _lastImage = null;
    notifyListeners();
  }
}
