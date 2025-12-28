import '../models/models.dart';
import 'verbal_questions.dart';
import 'numerical_questions.dart';
import 'logical_questions.dart';
import 'spatial_questions.dart';
import 'pattern_questions.dart';

export 'verbal_questions.dart';
export 'numerical_questions.dart';
export 'logical_questions.dart';
export 'spatial_questions.dart';
export 'pattern_questions.dart';

/// All questions combined
final List<Question> allQuestions = [
  ...verbalQuestions,
  ...numericalQuestions,
  ...logicalQuestions,
  ...spatialQuestions,
  ...patternQuestions,
];

/// Get questions by category
List<Question> getQuestionsByCategory(QuestionCategory category) {
  return allQuestions.where((q) => q.category == category).toList();
}

/// Get questions by difficulty
List<Question> getQuestionsByDifficulty(Difficulty difficulty) {
  return allQuestions.where((q) => q.difficulty == difficulty).toList();
}

/// Get a balanced set of questions for a full test
/// Returns questions with adaptive difficulty consideration
List<Question> getTestQuestions({
  int questionsPerCategory = 8,
  bool shuffle = true,
}) {
  final testQuestions = <Question>[];

  for (final category in QuestionCategory.values) {
    final categoryQuestions = getQuestionsByCategory(category);

    // Get a mix of difficulties
    final easy = categoryQuestions
        .where((q) => q.difficulty == Difficulty.easy)
        .toList();
    final medium = categoryQuestions
        .where((q) => q.difficulty == Difficulty.medium)
        .toList();
    final hard = categoryQuestions
        .where((q) => q.difficulty == Difficulty.hard)
        .toList();

    if (shuffle) {
      easy.shuffle();
      medium.shuffle();
      hard.shuffle();
    }

    // Take proportional questions from each difficulty
    // 25% easy, 50% medium, 25% hard (approximately)
    final easyCount = (questionsPerCategory * 0.25).ceil();
    final hardCount = (questionsPerCategory * 0.25).ceil();
    final mediumCount = questionsPerCategory - easyCount - hardCount;

    testQuestions.addAll(easy.take(easyCount));
    testQuestions.addAll(medium.take(mediumCount));
    testQuestions.addAll(hard.take(hardCount));
  }

  if (shuffle) {
    // Shuffle within categories but maintain category grouping
    // for a better test experience
  }

  return testQuestions;
}

/// Get the total number of questions available
int get totalQuestionsCount => allQuestions.length;

/// Get statistics about available questions
Map<String, dynamic> getQuestionStats() {
  final stats = <String, dynamic>{};

  stats['total'] = allQuestions.length;

  // By category
  final byCategory = <String, int>{};
  for (final category in QuestionCategory.values) {
    byCategory[category.displayName] = getQuestionsByCategory(category).length;
  }
  stats['byCategory'] = byCategory;

  // By difficulty
  final byDifficulty = <String, int>{};
  for (final difficulty in Difficulty.values) {
    byDifficulty[difficulty.displayName] =
        getQuestionsByDifficulty(difficulty).length;
  }
  stats['byDifficulty'] = byDifficulty;

  return stats;
}
