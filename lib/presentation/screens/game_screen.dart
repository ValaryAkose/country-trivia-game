import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/flag_image_widget.dart';
import '../widgets/answer_button.dart';
import '../widgets/attempts_indicator.dart';
import '../widgets/score_display.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import 'game_completed_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<GameProvider>();
      if (!provider.state.isPlaying && !provider.state.isCompleted) {
        provider.startGame();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Trivia'),
        centerTitle: true,
      ),
      body: Consumer<GameProvider>(
        builder: (context, provider, child) {
          if (provider.state.isCompleted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const GameCompletedScreen(),
                ),
              );
            });
            return const SizedBox.shrink();
          }

          if (provider.hasError && provider.state.currentQuestion == null) {
            return ErrorDisplayWidget(
              message: provider.errorMessage!,
              onRetry: () => provider.loadCountries(),
            );
          }

          if (provider.state.isLoading || provider.state.currentQuestion == null) {
            return const LoadingWidget(message: 'Loading question...');
          }

          final question = provider.state.currentQuestion!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ScoreDisplay(
                  score: provider.state.score,
                  progress: provider.state.progressDisplay,
                ),
                const SizedBox(height: 16),
                AttemptsIndicator(
                  attemptsRemaining: provider.state.attemptsRemaining,
                ),
                const SizedBox(height: 24),
                FlagImageWidget(
                  flagUrl: question.flagUrl,
                  width: 240,
                  height: 160,
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: ListView.builder(
                    itemCount: question.options.length,
                    itemBuilder: (context, index) {
                      final option = question.options[index];
                      return AnswerButton(
                        option: option,
                        isAnswerLocked: provider.state.isAnswerLocked,
                        onTap: () {
                          provider.submitAnswer(option.country.iso2);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
