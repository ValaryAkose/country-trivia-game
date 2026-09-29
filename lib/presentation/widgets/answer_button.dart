import 'package:flutter/material.dart';
import '../../domain/entities/answer_option.dart';
import '../../theme/app_colors.dart';

class AnswerButton extends StatelessWidget {
  final AnswerOption option;
  final bool isAnswerLocked;
  final VoidCallback onTap;

  const AnswerButton({
    super.key,
    required this.option,
    required this.isAnswerLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelectedWrong = option.isSelectedWrong;
    final isCorrect = option.isCorrect;

    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    Color textColor = Colors.black87;

    if (isSelectedWrong) {
      backgroundColor = AppColors.incorrect.withValues(alpha: 0.1);
      borderColor = AppColors.incorrect;
      textColor = AppColors.incorrect;
    } else if (isAnswerLocked && isCorrect) {
      backgroundColor = AppColors.correct.withValues(alpha: 0.1);
      borderColor = AppColors.correct;
      textColor = AppColors.correct;
    }

    final bool isDisabled = isSelectedWrong || (isAnswerLocked && !isCorrect);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isDisabled ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            side: BorderSide(color: borderColor, width: 2),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: isDisabled ? 0 : 2,
          ),
          child: Row(
            children: [
              if (isSelectedWrong)
                const Icon(Icons.close, color: AppColors.incorrect, size: 20)
              else if (isAnswerLocked && isCorrect)
                const Icon(Icons.check, color: AppColors.correct, size: 20)
              else
                const SizedBox(width: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option.country.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDisabled ? Colors.grey : textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
