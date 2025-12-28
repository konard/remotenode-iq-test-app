import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class TestProgressIndicator extends StatelessWidget {
  final double progress;
  final int currentQuestion;
  final int totalQuestions;
  final QuestionCategory category;

  const TestProgressIndicator({
    super.key,
    required this.progress,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.category,
  });

  Color get _categoryColor {
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          // Question counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question $currentQuestion of $totalQuestions',
                style: Theme.of(context).textTheme.labelMedium,
                semanticsLabel: 'Question $currentQuestion of $totalQuestions',
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: _categoryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: _categoryColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(_categoryColor),
              semanticsLabel: 'Test progress: ${(progress * 100).toStringAsFixed(0)}%',
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated circular progress indicator for results
class CircularScoreIndicator extends StatelessWidget {
  final double score;
  final double maxScore;
  final Color color;
  final double size;
  final double strokeWidth;

  const CircularScoreIndicator({
    super.key,
    required this.score,
    required this.maxScore,
    this.color = AppColors.primary,
    this.size = 120,
    this.strokeWidth = 12,
  });

  @override
  Widget build(BuildContext context) {
    final progress = score / maxScore;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: strokeWidth,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(color.withOpacity(0.2)),
            ),
          ),
          // Progress circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: strokeWidth,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(color),
              strokeCap: StrokeCap.round,
            ),
          ),
          // Score text
          Center(
            child: Text(
              '${score.toInt()}',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
