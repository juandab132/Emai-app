// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'core/app_theme.dart';
import 'core/app_router.dart';
import 'core/constants.dart';

// generado por `flutterfire configure`
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase (Android: requiere google-services.json en android/app/)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const EMAIApp());
}

class EMAIApp extends StatelessWidget {
  const EMAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMAI',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(), // usa Material 3 bonito
      initialRoute: AppRoutes.home, // '/'
      routes: AppRouter.routes, // rutas simples
      onGenerateRoute:
          AppRouter.onGenerateRoute, // rutas con args (p. ej., estudiante)
    );
  }
}
