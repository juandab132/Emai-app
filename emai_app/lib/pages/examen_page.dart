import 'package:flutter/material.dart';

class ExamenPage extends StatelessWidget {
  final String examen;
  const ExamenPage({super.key, required this.examen});

  @override
  Widget build(BuildContext context) {
    final tips = [
      'Tip 1: Repasar sumas con acarreo.',
      'Tip 2: Practicar restas con préstamo.',
      'Tip 3: Multiplicaciones paso a paso.',
      'Tip 4: Divisiones con reparto.'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(examen),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Imagen del examen (simulada)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(child: Text('Imagen Placeholder')),
            ),
            const SizedBox(height: 16),
            const Text('Informe de tips:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(tips[index]),
                      trailing: Checkbox(value: false, onChanged: (val) {}),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
