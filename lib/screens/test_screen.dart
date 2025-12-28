import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/providers.dart';
import '../utils/utils.dart';
import '../models/models.dart';
import '../widgets/question_card.dart';
import '../widgets/progress_indicator.dart';
import 'results_screen.dart';

class TestScreen extends ConsumerStatefulWidget {
  const TestScreen({super.key});

  @override
  ConsumerState<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends ConsumerState<TestScreen> {
  int? _selectedAnswer;
  List<int> _selectedMultiple = [];

  @override
  Widget build(BuildContext context) {
    final testState = ref.watch(testProvider);
    final totalTime = ref.watch(formattedTotalTimeProvider);
    final questionTime = ref.watch(formattedQuestionTimeProvider);

    if (testState == null) {
      return const Scaffold(
        body: Center(
          child: Text('No active test'),
        ),
      );
    }

    if (testState.isComplete) {
      // Navigate to results
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final result = ref.read(testProvider.notifier).getResult();
        if (result != null) {
          ref.read(resultsProvider.notifier).saveResult(result);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ResultsScreen(result: result),
            ),
          );
        }
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final question = testState.currentQuestion!;
    final progress = testState.progress;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showExitDialog(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Exit button
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => _showExitDialog(context),
                tooltip: 'Exit Test',
              ),
              // Timer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      totalTime,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
              // Question time
              Text(
                questionTime,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Progress bar
              TestProgressIndicator(
                progress: progress,
                currentQuestion: testState.currentIndex + 1,
                totalQuestions: testState.questions.length,
                category: question.category,
              ),

              // Question content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ResponsiveContainer(
                    maxWidth: 600,
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Category and difficulty badge
                        _buildBadges(context, question),
                        const SizedBox(height: 20),

                        // Question card
                        QuestionCard(
                          key: ValueKey(question.id),
                          question: question,
                          selectedAnswer: _selectedAnswer,
                          selectedMultiple: _selectedMultiple,
                          onAnswerSelected: (answer) {
                            if (question.type == QuestionType.selectAllThatApply) {
                              setState(() {
                                if (_selectedMultiple.contains(answer)) {
                                  _selectedMultiple.remove(answer);
                                } else {
                                  _selectedMultiple.add(answer);
                                }
                              });
                            } else {
                              setState(() {
                                _selectedAnswer = answer;
                              });
                            }
                          },
                        ).animate().fadeIn(duration: 300.ms),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom action bar
              _buildActionBar(context, question),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadges(BuildContext context, Question question) {
    return Row(
      children: [
        _CategoryBadge(category: question.category),
        const SizedBox(width: 8),
        _DifficultyBadge(difficulty: question.difficulty),
      ],
    );
  }

  Widget _buildActionBar(BuildContext context, Question question) {
    final bool canSubmit = question.type == QuestionType.selectAllThatApply
        ? _selectedMultiple.isNotEmpty
        : _selectedAnswer != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Skip button
          TextButton(
            onPressed: _skipQuestion,
            child: const Text('Skip'),
          ),
          const Spacer(),
          // Submit button
          ElevatedButton(
            onPressed: canSubmit ? _submitAnswer : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Next'),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitAnswer() {
    final testState = ref.read(testProvider);
    if (testState == null) return;

    final question = testState.currentQuestion!;
    dynamic answer;

    if (question.type == QuestionType.selectAllThatApply) {
      answer = _selectedMultiple.toList();
    } else {
      answer = _selectedAnswer;
    }

    ref.read(testProvider.notifier).submitAnswer(answer);
    _resetSelection();
  }

  void _skipQuestion() {
    ref.read(testProvider.notifier).skipQuestion();
    _resetSelection();
  }

  void _resetSelection() {
    setState(() {
      _selectedAnswer = null;
      _selectedMultiple = [];
    });
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Test?'),
        content: const Text(
          'Are you sure you want to exit? Your progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(testProvider.notifier).resetTest();
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to home
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final QuestionCategory category;

  const _CategoryBadge({required this.category});

  Color get _color {
    switch (category) {
      case QuestionCategory.verbal:
        return AppColors.verbalColor;
      case QuestionCategory.numerical:
        return AppColors.numericalColor;
      case QuestionCategory.logical:
        return AppColors.logicalColor;
      case QuestionCategory.spatial:
        return AppColors.spatialColor;
      case QuestionCategory.pattern:
        return AppColors.patternColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Text(
        category.displayName,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: _color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final Difficulty difficulty;

  const _DifficultyBadge({required this.difficulty});

  Color get _color {
    switch (difficulty) {
      case Difficulty.easy:
        return AppColors.success;
      case Difficulty.medium:
        return AppColors.warning;
      case Difficulty.hard:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Text(
        difficulty.displayName,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: _color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
