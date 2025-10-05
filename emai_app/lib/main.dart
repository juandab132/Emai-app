import 'package:flutter/material.dart';
import 'pages/bienvenida_page.dart';
import 'services/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBService.initDB();
  runApp(const EMAIApp());
}

class EMAIApp extends StatelessWidget {
  const EMAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EMAI-APP',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const BienvenidaPage(),
    );
  }
}
