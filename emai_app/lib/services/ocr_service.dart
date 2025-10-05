// import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

class OCRService {
  static Future<String> extractText(File imageFile) async {
    // final inputImage = InputImage.fromFile(imageFile);
    // final textRecognizer = GoogleMlKit.vision.textRecognizer();
    // final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    // await textRecognizer.close();

    // String text = '';
    // for (var block in recognizedText.blocks) {
    //   for (var line in block.lines) {
    //     text += line.text + '\n';
    //   }
    // }
    // return text;

    // Temporal: solo retorna cadena vacía
    return '';
  }
}
