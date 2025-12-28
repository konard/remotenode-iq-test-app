import 'package:hive/hive.dart';
import 'enums.dart';
import 'question.dart';

part 'test_result.g.dart';

/// Represents the result of a completed IQ test
@HiveType(typeId: 0)
class TestResult extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime completedAt;

  @HiveField(2)
  final int totalTimeSeconds;

  @HiveField(3)
  final int totalQuestions;

  @HiveField(4)
  final int correctAnswers;

  @HiveField(5)
  final Map<String, int> categoryCorrect; // category name -> correct count

  @HiveField(6)
  final Map<String, int> categoryTotal; // category name -> total count

  @HiveField(7)
  final int iqScore;

  @HiveField(8)
  final int percentile;

  @HiveField(9)
  final List<Map<String, dynamic>> answersJson; // Serialized QuestionAnswers

  TestResult({
    required this.id,
    required this.completedAt,
    required this.totalTimeSeconds,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.categoryCorrect,
    required this.categoryTotal,
    required this.iqScore,
    required this.percentile,
    required this.answersJson,
  });

  /// Get accuracy percentage
  double get accuracy => totalQuestions > 0
      ? (correctAnswers / totalQuestions) * 100
      : 0;

  /// Get average time per question in seconds
  double get averageTimePerQuestion => totalQuestions > 0
      ? totalTimeSeconds / totalQuestions
      : 0;

  /// Get category scores as percentages for radar chart
  Map<QuestionCategory, double> get categoryScores {
    final scores = <QuestionCategory, double>{};
    for (final category in QuestionCategory.values) {
      final categoryName = category.name;
      final correct = categoryCorrect[categoryName] ?? 0;
      final total = categoryTotal[categoryName] ?? 0;
      scores[category] = total > 0 ? (correct / total) * 100 : 0;
    }
    return scores;
  }

  /// Get IQ range classification
  IQRange get iqRange {
    if (iqScore < 85) return IQRange.veryLow;
    if (iqScore < 90) return IQRange.low;
    if (iqScore < 110) return IQRange.average;
    if (iqScore < 120) return IQRange.aboveAverage;
    if (iqScore < 130) return IQRange.high;
    if (iqScore < 140) return IQRange.veryHigh;
    if (iqScore < 145) return IQRange.superior;
    return IQRange.gifted;
  }

  /// Create from test session data
  factory TestResult.fromTestSession({
    required String id,
    required DateTime completedAt,
    required int totalTimeSeconds,
    required List<Question> questions,
    required List<QuestionAnswer> answers,
  }) {
    final categoryCorrect = <String, int>{};
    final categoryTotal = <String, int>{};

    // Initialize all categories
    for (final category in QuestionCategory.values) {
      categoryCorrect[category.name] = 0;
      categoryTotal[category.name] = 0;
    }

    // Count correct answers per category
    for (final question in questions) {
      final categoryName = question.category.name;
      categoryTotal[categoryName] = (categoryTotal[categoryName] ?? 0) + 1;
    }

    int correctCount = 0;
    for (final answer in answers) {
      if (answer.isCorrect) {
        correctCount++;
        final question = questions.firstWhere((q) => q.id == answer.questionId);
        final categoryName = question.category.name;
        categoryCorrect[categoryName] = (categoryCorrect[categoryName] ?? 0) + 1;
      }
    }

    // Calculate IQ score (simplified formula based on accuracy and difficulty)
    final accuracy = questions.isNotEmpty
        ? correctCount / questions.length
        : 0.0;
    final iqScore = _calculateIQScore(accuracy, questions, answers);
    final percentile = _calculatePercentile(iqScore);

    return TestResult(
      id: id,
      completedAt: completedAt,
      totalTimeSeconds: totalTimeSeconds,
      totalQuestions: questions.length,
      correctAnswers: correctCount,
      categoryCorrect: categoryCorrect,
      categoryTotal: categoryTotal,
      iqScore: iqScore,
      percentile: percentile,
      answersJson: answers.map((a) => a.toJson()).toList(),
    );
  }

  /// Calculate IQ score based on performance
  static int _calculateIQScore(
    double accuracy,
    List<Question> questions,
    List<QuestionAnswer> answers,
  ) {
    // Base IQ calculation using normal distribution
    // Average IQ = 100, Standard Deviation = 15

    // Start with accuracy-based score
    double rawScore = accuracy * 100;

    // Adjust for difficulty
    double difficultyBonus = 0;
    for (int i = 0; i < answers.length && i < questions.length; i++) {
      final answer = answers[i];
      final question = questions.firstWhere(
        (q) => q.id == answer.questionId,
        orElse: () => questions[i],
      );

      if (answer.isCorrect) {
        switch (question.difficulty) {
          case Difficulty.easy:
            difficultyBonus += 0.5;
            break;
          case Difficulty.medium:
            difficultyBonus += 1.0;
            break;
          case Difficulty.hard:
            difficultyBonus += 2.0;
            break;
        }
      }
    }

    // Normalize difficulty bonus
    final maxBonus = questions.length * 2.0;
    final normalizedBonus = maxBonus > 0 ? (difficultyBonus / maxBonus) * 20 : 0;

    // Time bonus (faster completion gives slight bonus)
    double timeBonus = 0;
    final avgTime = answers.isEmpty ? 0 :
        answers.map((a) => a.timeSpentSeconds).reduce((a, b) => a + b) / answers.length;
    if (avgTime > 0 && avgTime < 30) {
      timeBonus = 5;
    } else if (avgTime < 45) {
      timeBonus = 3;
    }

    // Final IQ calculation
    // Map raw score (0-100) to IQ scale (70-145)
    final adjustedScore = rawScore + normalizedBonus + timeBonus;
    final iq = 70 + (adjustedScore / 100) * 75;

    // Clamp to realistic range
    return iq.round().clamp(70, 145);
  }

  /// Calculate percentile from IQ score
  static int _calculatePercentile(int iq) {
    // Using standard normal distribution approximation
    // IQ 100 = 50th percentile, SD = 15
    final z = (iq - 100) / 15;

    // Approximation of cumulative normal distribution
    final percentile = (0.5 * (1 + _erf(z / 1.41421356))) * 100;
    return percentile.round().clamp(1, 99);
  }

  /// Error function approximation for normal distribution
  static double _erf(double x) {
    final a1 = 0.254829592;
    final a2 = -0.284496736;
    final a3 = 1.421413741;
    final a4 = -1.453152027;
    final a5 = 1.061405429;
    final p = 0.3275911;

    final sign = x < 0 ? -1 : 1;
    x = x.abs();

    final t = 1.0 / (1.0 + p * x);
    final y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t *
        _exp(-x * x);

    return sign * y;
  }

  static double _exp(double x) {
    // Simple exp approximation to avoid dart:math dependency
    if (x < -10) return 0;
    if (x > 10) return 22026.47;

    double result = 1.0;
    double term = 1.0;
    for (int i = 1; i <= 20; i++) {
      term *= x / i;
      result += term;
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'completedAt': completedAt.toIso8601String(),
      'totalTimeSeconds': totalTimeSeconds,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'categoryCorrect': categoryCorrect,
      'categoryTotal': categoryTotal,
      'iqScore': iqScore,
      'percentile': percentile,
      'answersJson': answersJson,
    };
  }

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      id: json['id'] as String,
      completedAt: DateTime.parse(json['completedAt'] as String),
      totalTimeSeconds: json['totalTimeSeconds'] as int,
      totalQuestions: json['totalQuestions'] as int,
      correctAnswers: json['correctAnswers'] as int,
      categoryCorrect: Map<String, int>.from(json['categoryCorrect'] as Map),
      categoryTotal: Map<String, int>.from(json['categoryTotal'] as Map),
      iqScore: json['iqScore'] as int,
      percentile: json['percentile'] as int,
      answersJson: List<Map<String, dynamic>>.from(json['answersJson'] as List),
    );
  }
}

/// IQ range classifications
enum IQRange {
  veryLow,      // < 85
  low,          // 85-89
  average,      // 90-109
  aboveAverage, // 110-119
  high,         // 120-129
  veryHigh,     // 130-139
  superior,     // 140-144
  gifted,       // 145+
}

extension IQRangeExtension on IQRange {
  String get displayName {
    switch (this) {
      case IQRange.veryLow:
        return 'Below Average';
      case IQRange.low:
        return 'Low Average';
      case IQRange.average:
        return 'Average';
      case IQRange.aboveAverage:
        return 'Above Average';
      case IQRange.high:
        return 'High';
      case IQRange.veryHigh:
        return 'Very High';
      case IQRange.superior:
        return 'Superior';
      case IQRange.gifted:
        return 'Gifted';
    }
  }

  String get interpretation {
    switch (this) {
      case IQRange.veryLow:
        return 'Your score indicates areas where additional cognitive development may be beneficial. Consider engaging in brain-training activities.';
      case IQRange.low:
        return 'Your score is slightly below average. Regular mental exercises and learning new skills can help improve cognitive function.';
      case IQRange.average:
        return 'Your score falls within the average range, similar to most of the population. You demonstrate solid cognitive abilities.';
      case IQRange.aboveAverage:
        return 'Your score is above average, indicating strong cognitive abilities across multiple areas.';
      case IQRange.high:
        return 'You demonstrate high cognitive ability. Your problem-solving and reasoning skills are well-developed.';
      case IQRange.veryHigh:
        return 'Your score indicates very high intelligence. You excel in complex reasoning and abstract thinking.';
      case IQRange.superior:
        return 'You demonstrate superior cognitive abilities, placing you among the top performers.';
      case IQRange.gifted:
        return 'Your score indicates exceptional cognitive abilities, placing you in the gifted range.';
    }
  }
}
