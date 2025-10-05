import '../utils/tips_data.dart';

class AnalisisService {
  static Map<String, dynamic> analizar(String texto) {
    final operaciones = RegExp(r'(\d+)\s*([\+\-\×x*\/])\s*(\d+)\s*=\s*(\d+)');
    final matches = operaciones.allMatches(texto);
    List<Map<String, dynamic>> resultados = [];

    for (var match in matches) {
      final n1 = int.parse(match.group(1)!);
      final op = match.group(2)!;
      final n2 = int.parse(match.group(3)!);
      final res = int.parse(match.group(4)!);

      int correcto = switch (op) {
        '+' => n1 + n2,
        '-' => n1 - n2,
        'x' || '×' || '*' => n1 * n2,
        '/' => n1 ~/ n2,
        _ => 0
      };

      bool bien = res == correcto;
      String tipo = switch (op) {
        '+' => 'suma',
        '-' => 'resta',
        'x' || '×' || '*' => 'multiplicacion',
        '/' => 'division',
        _ => 'otro'
      };

      resultados.add({
        'operacion': '$n1 $op $n2 = $res',
        'correcto': bien,
        'tip': bien ? null : TipsData.obtenerTip(tipo),
      });
    }

    return {'resultados': resultados};
  }
}
