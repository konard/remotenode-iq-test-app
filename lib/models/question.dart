import 'enums.dart';

/// Represents a single question in the IQ test
class Question {
  final String id;
  final QuestionCategory category;
  final QuestionType type;
  final Difficulty difficulty;
  final String questionText;
  final List<String> options;
  final dynamic correctAnswer; // Can be int, List<int>, or String depending on type
  final String? explanation;
  final String? imageAsset; // For visual questions
  final int? timeLimitSeconds; // Per-question time limit (optional)
  final Map<String, String>? translations; // For localized question text

  const Question({
    required this.id,
    required this.category,
    required this.type,
    required this.difficulty,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    this.imageAsset,
    this.timeLimitSeconds,
    this.translations,
  });

  /// Check if the given answer is correct
  bool isCorrect(dynamic answer) {
    if (type == QuestionType.selectAllThatApply) {
      if (answer is! List || correctAnswer is! List) return false;
      final answerSet = Set.from(answer);
      final correctSet = Set.from(correctAnswer as List);
      return answerSet.length == correctSet.length &&
          answerSet.containsAll(correctSet);
    }
    return answer == correctAnswer;
  }

  /// Get the question text for a specific locale
  String getLocalizedText(String locale) {
    return translations?[locale] ?? questionText;
  }

  /// Create a copy of this question with modified fields
  Question copyWith({
    String? id,
    QuestionCategory? category,
    QuestionType? type,
    Difficulty? difficulty,
    String? questionText,
    List<String>? options,
    dynamic correctAnswer,
    String? explanation,
    String? imageAsset,
    int? timeLimitSeconds,
    Map<String, String>? translations,
  }) {
    return Question(
      id: id ?? this.id,
      category: category ?? this.category,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      imageAsset: imageAsset ?? this.imageAsset,
      timeLimitSeconds: timeLimitSeconds ?? this.timeLimitSeconds,
      translations: translations ?? this.translations,
    );
  }

  @override
  String toString() {
    return 'Question(id: $id, category: $category, type: $type, difficulty: $difficulty)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Question && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Represents a user's answer to a question
class QuestionAnswer {
  final String questionId;
  final dynamic userAnswer;
  final bool isCorrect;
  final int timeSpentSeconds;
  final DateTime answeredAt;

  const QuestionAnswer({
    required this.questionId,
    required this.userAnswer,
    required this.isCorrect,
    required this.timeSpentSeconds,
    required this.answeredAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'userAnswer': userAnswer,
      'isCorrect': isCorrect,
      'timeSpentSeconds': timeSpentSeconds,
      'answeredAt': answeredAt.toIso8601String(),
    };
  }

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      questionId: json['questionId'] as String,
      userAnswer: json['userAnswer'],
      isCorrect: json['isCorrect'] as bool,
      timeSpentSeconds: json['timeSpentSeconds'] as int,
      answeredAt: DateTime.parse(json['answeredAt'] as String),
    );
  }
}
