class TipsData {
  static Map<String, List<String>> tips = {
    'suma': [
      'Repasa el acarreo con ejercicios visuales.',
      'Usa material concreto (fichas o bloques) para reforzar el concepto de sumar llevando.'
    ],
    'resta': [
      'Refuerza el préstamo en restas con material gráfico.',
      'Practica restas con líneas numéricas.'
    ],
    'multiplicacion': [
      'Practica tablas de multiplicar con juegos.',
      'Realiza ejercicios paso a paso verificando productos parciales.'
    ],
    'division': [
      'Explica la división como reparto equitativo.',
      'Practica divisiones pequeñas con objetos físicos.'
    ]
  };

  static String obtenerTip(String tipo) {
    final lista = tips[tipo] ?? ['Revisar el procedimiento con ejemplos.'];
    lista.shuffle();
    return lista.first;
  }
}
