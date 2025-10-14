import 'package:flutter/material.dart';

class ScoreBadge extends StatelessWidget {
  final double score; // 0..1
  final bool compact;
  const ScoreBadge({super.key, required this.score, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final pct = (score * 100).clamp(0, 100).toStringAsFixed(0);
    final scheme = Theme.of(context).colorScheme;
    final ok = score >= .60;
    final bg = ok ? scheme.primaryContainer : scheme.errorContainer;
    final fg = ok ? scheme.onPrimaryContainer : scheme.onErrorContainer;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$pct%',
        style: TextStyle(color: fg, fontWeight: FontWeight.w700),
      ),
    );
  }
}
