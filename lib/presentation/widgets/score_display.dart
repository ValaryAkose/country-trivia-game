import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  final int score;
  final String progress;

  const ScoreDisplay({
    super.key,
    required this.score,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.stars, color: Colors.amber, size: 28),
          const SizedBox(width: 8),
          Text(
            '$score',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey[300],
          ),
          const SizedBox(width: 16),
          const Icon(Icons.flag, color: Colors.green, size: 24),
          const SizedBox(width: 8),
          Text(
            progress,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
