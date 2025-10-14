import 'package:image_picker/image_picker.dart';

import '../models/operation_result.dart';
import '../services/ocr_service.dart';
import '../services/analisis_service.dart';

class ScanRepository {
  final OcrService ocr;
  final AnalisisService analisis;

  const ScanRepository({required this.ocr, required this.analisis});

  Future<({num accuracy, List<OperationResult> results})> process(
    XFile image,
  ) async {
    final text = await ocr.recognizeTextFromImage(image);
    final results = analisis.parseAndEvaluate(text);
    final acc =
        results.isEmpty
            ? 0
            : results.where((r) => r.correct).length / results.length;
    return (results: results, accuracy: acc);
  }
}
