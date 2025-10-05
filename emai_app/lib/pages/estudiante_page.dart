import 'package:flutter/material.dart';
import 'examen_page.dart';

class EstudiantePage extends StatelessWidget {
  final String estudiante;
  const EstudiantePage({super.key, required this.estudiante});

  @override
  Widget build(BuildContext context) {
    final examenes = ['Examen 1', 'Examen 2', 'Examen 3'];

    return Scaffold(
      appBar: AppBar(
        title: Text(estudiante),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: examenes.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(examenes[index]),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExamenPage(examen: examenes[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FloatingActionButton(
              onPressed: () {
                // Simular cámara: por ahora solo mensaje
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función de cámara simulada')),
                );
              },
              child: const Icon(Icons.camera_alt),
            ),
          )
        ],
      ),
    );
  }
}
