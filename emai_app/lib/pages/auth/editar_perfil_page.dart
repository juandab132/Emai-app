import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({super.key});

  @override
  State<EditarPerfilPage> createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  final _nombreController = TextEditingController(text: 'Profesor Ejemplo');
  final _cursoController = TextEditingController(text: '1-1');
  final _materiaController = TextEditingController(text: 'Matemáticas');
  final _edadController = TextEditingController(text: '35');
  String sexo = 'Hombre';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _cursoController,
              decoration: const InputDecoration(labelText: 'Curso a cargo'),
            ),
            TextField(
              controller: _materiaController,
              decoration: const InputDecoration(labelText: 'Materia'),
            ),
            TextField(
              controller: _edadController,
              decoration: const InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: sexo,
              items: const [
                DropdownMenuItem(value: 'Hombre', child: Text('Hombre')),
                DropdownMenuItem(value: 'Mujer', child: Text('Mujer')),
              ],
              onChanged: (val) {
                setState(() {
                  sexo = val!;
                });
              },
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Guardar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Perfil guardado (simulado)')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
