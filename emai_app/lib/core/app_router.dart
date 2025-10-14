import 'package:flutter/material.dart';

import '../pages/home/lobby_page.dart';
import '../pages/auth/login_page.dart';
import '../pages/home/bienvenida_page.dart';
import '../pages/scan/examen_page.dart';
import '../pages/students/curso_page.dart';
import '../pages/students/estudiante_page.dart';
import '../pages/auth/editar_perfil_page.dart';
import 'constants.dart';

class AppRouter {
  static Map<String, WidgetBuilder> get routes => {
    AppRoutes.home: (_) => const LobbyPage(),
    AppRoutes.login: (_) => const LoginPage(),
    AppRoutes.bienvenida: (_) => const BienvenidaPage(),
    AppRoutes.scan: (_) => const ExamenPage(examen: ''),
    AppRoutes.curso: (_) => const CursoPage(curso: ''),
    AppRoutes.editarPerfil: (_) => const EditarPerfilPage(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.estudiante:
        // Ejemplo de uso:
        // Navigator.pushNamed(context, AppRoutes.estudiante,
        //   arguments: {'studentId': 'abc123', 'name': 'Ana Ruiz'});
        final args = (settings.arguments as Map?) ?? {};
        return MaterialPageRoute(
          builder:
              (_) => EstudiantePage(
                studentId: args['studentId'],
                studentName: args['name'],
                estudiante: '',
              ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) => const Scaffold(
                body: Center(child: Text('Ruta no encontrada')),
              ),
          settings: settings,
        );
    }
  }
}
