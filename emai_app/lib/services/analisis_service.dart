import 'dart:math';
import '../core/constants.dart';
import '../models/operation_result.dart';

/// Servicio que toma el texto OCR, lo normaliza, parsea líneas tipo
/// "A op B = C" y devuelve una lista de OperationResult.
class AnalisisService {
  const AnalisisService();

  /// Proceso completo: normalizar -> dividir en líneas -> evaluar cada una.
  List<OperationResult> parseAndEvaluate(String ocrText) {
    if (ocrText.trim().isEmpty) return [];

    final normalized = _normalize(ocrText);
    final lines =
        normalized
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

    final regex = RegExp(kExprPattern);
    final results = <OperationResult>[];

    for (final line in lines) {
      final m = regex.firstMatch(line);
      if (m == null) {
        // línea no válida -> ignora sin error
        continue;
      }

      final a = num.tryParse(m.group(1)!);
      var op = m.group(2)!;
      final b = num.tryParse(m.group(3)!);
      final c = num.tryParse(m.group(4)!);

      if (a == null || b == null || c == null) {
        continue;
      }

      // Normaliza operador 'x' a '*'
      if (op == 'x') op = '*';

      // División por cero
      if (op == '/' && b == 0) {
        results.add(
          OperationResult(
            expression: line,
            correct: false,
            expected: double.nan,
            message: 'indefinido',
            tag: 'division_por_cero',
          ),
        );
        continue;
      }

      // Calcula esperado
      final expected = _eval(a, op, b);
      final ok = _equals(expected, c);

      results.add(
        ok
            ? OperationResult(
              expression: line,
              correct: true,
              expected: expected,
              message: '¡Correcto!',
              tag: null,
            )
            : OperationResult(
              expression: line,
              correct: false,
              expected: expected,
              message: 'Resultado esperado: $expected',
              tag: _guessTag(a, op, b, c, expected),
            ),
      );
    }

    return results;
  }

  // --- Helpers ---

  /// Normaliza símbolos y caracteres: ×->x, coma->punto, colapsa espacios,
  /// conserva sólo dígitos, signos y '=' (más saltos de línea).
  String _normalize(String text) {
    var t = text.replaceAll('×', 'x').replaceAll('X', 'x').replaceAll(',', '.');

    // Reemplaza separadores raros por espacio
    t = t.replaceAll('\r', '\n');

    // Filtrado por línea: deja chars válidos y espacio
    final buffer = StringBuffer();
    for (int i = 0; i < t.length; i++) {
      final ch = t[i];
      final isAllowed = _isAllowedChar(ch);
      buffer.write(isAllowed ? ch : ' ');
    }

    // Colapsa espacios múltiples por línea
    final lines =
        buffer
            .toString()
            .split('\n')
            .map((line) => line.replaceAll(RegExp(r'\s+'), ' ').trim())
            .toList();

    return lines.join('\n');
  }

  bool _isAllowedChar(String ch) {
    const allowed = '0123456789.+-x*/= ';
    return allowed.contains(ch) || ch == '\n';
  }

  num _eval(num a, String op, num b) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        return a / b;
      default:
        return double.nan;
    }
  }

  bool _equals(num x, num y) {
    final diff = (x - y).abs();
    return diff <= kEpsilon;
  }

  /// Heurística simple para “etiquetar” errores comunes.
  String? _guessTag(num a, String op, num b, num c, num expected) {
    // Error de multiplicación por 0
    if (op == '*' && (a == 0 || b == 0) && c != 0)
      return 'multiplicacion_por_cero';
    // Error de signo: esperado = -(c)
    if ((op == '+' || op == '-') && (expected == -c)) return 'signo';
    // Error de llevada (heurística): diferencia de 1, 10 o 100
    final d = (expected - c).abs();
    if (d == 1 || d == 10 || d == 100) return 'llevada';
    return null;
  }
}
