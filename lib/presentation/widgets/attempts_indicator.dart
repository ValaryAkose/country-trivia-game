import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AttemptsIndicator extends StatelessWidget {
  final int attemptsRemaining;
  final int totalAttempts;

  const AttemptsIndicator({
    super.key,
    required this.attemptsRemaining,
    this.totalAttempts = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalAttempts, (index) {
        final isActive = index < attemptsRemaining;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            Icons.favorite,
            color: isActive ? AppColors.incorrect : Colors.grey[300],
            size: 28,
          ),
        );
      }),
    );
  }
}
