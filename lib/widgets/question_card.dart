import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class QuestionCard extends StatelessWidget {
  final Question question;
  final int? selectedAnswer;
  final List<int> selectedMultiple;
  final Function(int) onAnswerSelected;

  const QuestionCard({
    super.key,
    required this.question,
    this.selectedAnswer,
    this.selectedMultiple = const [],
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Question text
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.questionText,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        height: 1.4,
                      ),
                  semanticsLabel: question.questionText,
                ),
                if (question.imageAsset != null) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      question.imageAsset!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Hint text based on question type
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            _getHintText(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),

        // Answer options
        ...List.generate(question.options.length, (index) {
          final isSelected = question.type == QuestionType.selectAllThatApply
              ? selectedMultiple.contains(index)
              : selectedAnswer == index;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OptionCard(
              text: question.options[index],
              index: index,
              isSelected: isSelected,
              isMultiSelect: question.type == QuestionType.selectAllThatApply,
              onTap: () => onAnswerSelected(index),
            ),
          );
        }),
      ],
    );
  }

  String _getHintText() {
    switch (question.type) {
      case QuestionType.selectAllThatApply:
        return 'Select all that apply';
      case QuestionType.sequenceCompletion:
        return 'Complete the sequence';
      case QuestionType.matrixReasoning:
        return 'Find the missing element';
      case QuestionType.analogies:
        return 'Complete the analogy';
      case QuestionType.numberSeries:
        return 'Find the next number';
      case QuestionType.figureRotation:
        return 'Choose the correct transformation';
      case QuestionType.multipleChoice:
      default:
        return 'Choose the correct answer';
    }
  }
}

class _OptionCard extends StatelessWidget {
  final String text;
  final int index;
  final bool isSelected;
  final bool isMultiSelect;
  final VoidCallback onTap;

  const _OptionCard({
    required this.text,
    required this.index,
    required this.isSelected,
    required this.isMultiSelect,
    required this.onTap,
  });

  String get _optionLabel {
    return String.fromCharCode('A'.codeUnitAt(0) + index);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Material(
      color: isSelected
          ? primaryColor.withOpacity(0.1)
          : Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? primaryColor
                  : Theme.of(context).dividerColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Option indicator
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: isMultiSelect ? BoxShape.rectangle : BoxShape.circle,
                  borderRadius: isMultiSelect
                      ? BorderRadius.circular(6)
                      : null,
                  color: isSelected
                      ? primaryColor
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? primaryColor
                        : Theme.of(context).dividerColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isSelected
                      ? Icon(
                          isMultiSelect ? Icons.check : Icons.check,
                          color: Colors.white,
                          size: 18,
                        )
                      : Text(
                          _optionLabel,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                                  ),
                        ),
                ),
              ),
              const SizedBox(width: 16),

              // Option text
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                  semanticsLabel: 'Option $_optionLabel: $text',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
