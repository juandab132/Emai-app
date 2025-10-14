import 'package:flutter/material.dart';
import '../students/curso_page.dart';

class LobbyPage extends StatelessWidget {
  const LobbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cursos = ['1-1', '1-2', '2-1', '2-2', '3-1'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Colegio Nuestra Señora del Carmen"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade400,
              child: const Icon(Icons.person),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: cursos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CursoPage(curso: cursos[index]),
                  ),
                ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.indigo.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "Curso ${cursos[index]}",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("EMAI-APP", textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
