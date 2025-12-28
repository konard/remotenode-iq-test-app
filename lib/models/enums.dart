/// Question categories for the IQ test
enum QuestionCategory {
  verbal,
  numerical,
  logical,
  spatial,
  pattern,
}

/// Different types of questions supported
enum QuestionType {
  multipleChoice,      // Single answer from 4 options
  selectAllThatApply,  // Multiple correct answers
  sequenceCompletion,  // Complete a sequence
  matrixReasoning,     // 3x3 matrix puzzles
  analogies,           // A is to B as C is to ?
  numberSeries,        // Find the next number
  figureRotation,      // Mental rotation tasks
}

/// Difficulty levels for adaptive testing
enum Difficulty {
  easy,
  medium,
  hard,
}

/// Extension methods for QuestionCategory
extension QuestionCategoryExtension on QuestionCategory {
  String get displayName {
    switch (this) {
      case QuestionCategory.verbal:
        return 'Verbal';
      case QuestionCategory.numerical:
        return 'Numerical';
      case QuestionCategory.logical:
        return 'Logical';
      case QuestionCategory.spatial:
        return 'Spatial';
      case QuestionCategory.pattern:
        return 'Pattern Recognition';
    }
  }

  String get description {
    switch (this) {
      case QuestionCategory.verbal:
        return 'Language comprehension, vocabulary, and verbal reasoning';
      case QuestionCategory.numerical:
        return 'Mathematical aptitude and number series recognition';
      case QuestionCategory.logical:
        return 'Deductive reasoning and logical problem-solving';
      case QuestionCategory.spatial:
        return 'Visual-spatial awareness and mental rotation';
      case QuestionCategory.pattern:
        return 'Pattern identification and sequence completion';
    }
  }

  String get icon {
    switch (this) {
      case QuestionCategory.verbal:
        return '📝';
      case QuestionCategory.numerical:
        return '🔢';
      case QuestionCategory.logical:
        return '🧠';
      case QuestionCategory.spatial:
        return '📐';
      case QuestionCategory.pattern:
        return '🔷';
    }
  }
}

/// Extension methods for Difficulty
extension DifficultyExtension on Difficulty {
  String get displayName {
    switch (this) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.medium:
        return 'Medium';
      case Difficulty.hard:
        return 'Hard';
    }
  }

  int get basePoints {
    switch (this) {
      case Difficulty.easy:
        return 1;
      case Difficulty.medium:
        return 2;
      case Difficulty.hard:
        return 3;
    }
  }

  int get timeBonus {
    switch (this) {
      case Difficulty.easy:
        return 30; // seconds
      case Difficulty.medium:
        return 45;
      case Difficulty.hard:
        return 60;
    }
  }
}
