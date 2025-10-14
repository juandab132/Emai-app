import 'dart:async';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import '../core/constants.dart';

/// Servicio OCR on-device con ML Kit.
/// Devuelve el texto “tal cual” de la imagen.
/// La normalización la hace AnalisisService.
class OcrService {
  const OcrService();

  Future<String> recognizeTextFromImage(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final result = await recognizer
          .processImage(inputImage)
          .timeout(const Duration(seconds: kOcrMaxSeconds));
      return result.text; // texto crudo (líneas separadas por \n)
    } on TimeoutException {
      return ''; // o lanza excepción si prefieres
    } catch (_) {
      return '';
    } finally {
      await recognizer.close();
    }
  }
}
