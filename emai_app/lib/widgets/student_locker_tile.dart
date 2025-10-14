import 'package:flutter/material.dart';
import 'score_badge.dart';

class StudentLockerTile extends StatelessWidget {
  final String name;
  final String grade;
  final double score; // 0..1
  final VoidCallback onTap;

  const StudentLockerTile({
    super.key,
    required this.name,
    required this.grade,
    required this.score,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('Grado $grade'),
        trailing: ScoreBadge(score: score, compact: true),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
