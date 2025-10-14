import 'package:flutter/material.dart';
import 'estudiante_page.dart';

class CursoPage extends StatelessWidget {
  final String curso;
  const CursoPage({super.key, required this.curso});

  @override
  Widget build(BuildContext context) {
    final estudiantes = ['Juan', 'María', 'Pedro', 'Lucía', 'Carlos'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Curso $curso"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: estudiantes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => EstudiantePage(
                        estudiante: estudiantes[index],
                        studentId: null,
                        studentName: null,
                      ),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(estudiantes[index]),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
          );
        },
      ),
    );
  }
}
