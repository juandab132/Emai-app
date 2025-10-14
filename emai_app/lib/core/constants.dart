// --- Evaluación / análisis ---
const double kEpsilon = 1e-6; // Tolerancia numérica para comparar resultados
const double kLowScoreThreshold = 0.60; // Umbral de alerta (<60%)
const int kOcrMaxSeconds = 8; // Tiempo tope razonable para OCR (seg)

// --- Firestore (colecciones) ---
const String colStudents = 'students';
const String colEvaluations = 'evaluations';
const String colSubmissions = 'submissions';

class AppRoutes {
  static const String home = '/'; // Lobby
  static const String login = '/login';
  static const String bienvenida = '/bienvenida';
  static const String scan = '/scan'; // Examen / Escaneo
  static const String curso = '/curso'; // Reporte general (por grado)
  static const String estudiante = '/estudiante'; // Reporte individual
  static const String editarPerfil = '/editar-perfil';
}

const String kExprPattern =
    r'^\s*(-?\d+(?:\.\d+)?)\s*([+\-x*/])\s*(-?\d+(?:\.\d+)?)\s*=\s*(-?\d+(?:\.\d+)?)\s*$';
