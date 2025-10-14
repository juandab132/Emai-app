import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../services/ocr_service.dart';
import '../services/analisis_service.dart';
import '../services/db_service.dart';
import '../state/scan_state.dart';

import '../widgets/section_card.dart';
import '../widgets/score_badge.dart';


class ExamenPage extends StatefulWidget {
  const ExamenPage({super.key});

  @override
  State<ExamenPage> createState() => _ExamenPageState();
}

class _ExamenPageState extends State<ExamenPage> {
  final _picker = ImagePicker();

  String? _selectedStudentId;
  String? _selectedEvalId;
  String? _selectedGrade; // para filtrar evaluaciones por grado

  @override
  Widget build(BuildContext context) {
    // Inyecta ScanState si no existe aún en el árbol
    return ChangeNotifierProvider<ScanState>(
      create: (_) => ScanState(
        ocr: const OcrService(),
        analisis: const AnalisisService(),
        db: DbService(),
      ),
      child: Consumer<ScanState>(
        builder: (context, scan, _) {
          final scheme = Theme.of(context).colorScheme;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Escanear y evaluar'),
              actions: [
                Row(
                  children: [
                    const Text('Modo infantil'),
                    Switch(
                      value: scan.childMode,
                      onChanged: scan.toggleChildMode,
                    ),
                  ],
                ),
                const SizedBox(width: 8),
              ],
            ),
            floatingActionButton: _buildFab(scan),
            body: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                SectionCard(
                  title: '1) Captura o selecciona una foto',
                  child: Wrap(
                    spacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: scan.loading ? null : () => _takePhoto(scan),
                        icon: const Icon(Icons.photo_camera),
                        label: const Text('Cámara'),
                      ),
                      OutlinedButton.icon(
                        onPressed: scan.loading ? null : () => _pickFromGallery(scan),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Galería'),
                      ),
                      if (scan.lastImage != null)
                        Text('Imagen lista: ${scan.lastImage!.name}', style: TextStyle(color: scheme.secondary)),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                SectionCard(
                  title: '2) Resultados de la evaluación',
                  trailing: ScoreBadge(score: scan.accuracy),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (scan.loading) ...[
                        const LinearProgressIndicator(),
                        const SizedBox(height: 8),
                        const Text('Procesando imagen…'),
                      ] else if (scan.error != null) ...[
                        Text(scan.error!, style: TextStyle(color: scheme.error)),
                      ] else if (scan.results.isEmpty) ...[
                        const Text('Aún no hay resultados.'),
                      ] else ...[
                        Text('Precisión: ${(scan.accuracy * 100).toStringAsFixed(0)}%'),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(value: scan.accuracy),
                        const SizedBox(height: 12),
                        for (final r in scan.results)
                          ResultItem(
                            expression: r.expression,
                            correct: r.correct,
                            expectedMsg: r.correct ? null : r.message,
                          ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                SectionCard(
                  title: '3) Asociar a Estudiante y Evaluación',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _GradePicker(
                        onChanged: (g) {
                          setState(() { _selectedGrade = g; });
                          // al cambiar grado, limpia selección de eval por coherencia
                          _selectedEvalId = null;
                        },
                      ),
                      const SizedBox(height: 12),
                      _StudentPicker(
                        selectedId: _selectedStudentId,
                        onChanged: (id) => setState(() => _selectedStudentId = id),
                      ),
                      const SizedBox(height: 12),
                      _EvaluationPicker(
                        grade: _selectedGrade,
                        selectedId: _selectedEvalId,
                        onChanged: (id) => setState(() => _selectedEvalId = id),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: (scan.results.isNotEmpty &&
                                  _selectedStudentId != null &&
                                  _selectedEvalId != null &&
                                  !scan.loading)
                              ? () async {
                                  await scan.saveSubmission(
                                    studentId: _selectedStudentId!,
                                    evaluationId: _selectedEvalId!,
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Entrega guardada')),
                                    );
                                  }
                                }
                              : null,
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar entrega'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80), // espacio para el FAB
              ],
            ),
          );
        },
      ),
    );
  }

  FloatingActionButton _buildFab(ScanState scan) {
    final hasResults = scan.results.isNotEmpty;
    return FloatingActionButton.extended(
      onPressed: scan.loading
          ? null
          : () async {
              // Acceso rápido: si ya hay imagen, reprocesa; si no, abre galería
              if (scan.lastImage != null) {
                await scan.processImage(scan.lastImage!);
              } else {
                await _pickFromGallery(scan);
              }
            },
      icon: Icon(hasResults ? Icons.refresh : Icons.play_arrow),
      label: Text(hasResults ? 'Reprocesar' : 'Procesar'),
    );
  }

  Future<void> _takePhoto(ScanState scan) async {
    final img = await _picker.pickImage(source: ImageSource.camera);
    if (img != null) await scan.processImage(img);
  }

  Future<void> _pickFromGallery(ScanState scan) async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) await scan.processImage(img);
  }
}

// ------------------ Pickers (alumnos, evaluaciones, grado) ------------------

class _StudentPicker extends StatelessWidget {
  final String? selectedId;
  final ValueChanged<String?> onChanged;
  const _StudentPicker({required this.selectedId, required this.on_
