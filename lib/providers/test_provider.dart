import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../data/questions.dart';

/// State for the current test session
class TestState {
  final String id;
  final List<Question> questions;
  final int currentIndex;
  final List<QuestionAnswer> answers;
  final int totalTimeSeconds;
  final int currentQuestionTimeSeconds;
  final bool isComplete;
  final DateTime startedAt;
  final Difficulty currentDifficulty;
  final int consecutiveCorrect;
  final int consecutiveWrong;

  const TestState({
    required this.id,
    required this.questions,
    this.currentIndex = 0,
    this.answers = const [],
    this.totalTimeSeconds = 0,
    this.currentQuestionTimeSeconds = 0,
    this.isComplete = false,
    required this.startedAt,
    this.currentDifficulty = Difficulty.medium,
    this.consecutiveCorrect = 0,
    this.consecutiveWrong = 0,
  });

  Question? get currentQuestion =>
      currentIndex < questions.length ? questions[currentIndex] : null;

  double get progress =>
      questions.isNotEmpty ? (currentIndex / questions.length) : 0;

  int get correctAnswers => answers.where((a) => a.isCorrect).length;

  bool get hasMoreQuestions => currentIndex < questions.length;

  TestState copyWith({
    String? id,
    List<Question>? questions,
    int? currentIndex,
    List<QuestionAnswer>? answers,
    int? totalTimeSeconds,
    int? currentQuestionTimeSeconds,
    bool? isComplete,
    DateTime? startedAt,
    Difficulty? currentDifficulty,
    int? consecutiveCorrect,
    int? consecutiveWrong,
  }) {
    return TestState(
      id: id ?? this.id,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      totalTimeSeconds: totalTimeSeconds ?? this.totalTimeSeconds,
      currentQuestionTimeSeconds:
          currentQuestionTimeSeconds ?? this.currentQuestionTimeSeconds,
      isComplete: isComplete ?? this.isComplete,
      startedAt: startedAt ?? this.startedAt,
      currentDifficulty: currentDifficulty ?? this.currentDifficulty,
      consecutiveCorrect: consecutiveCorrect ?? this.consecutiveCorrect,
      consecutiveWrong: consecutiveWrong ?? this.consecutiveWrong,
    );
  }
}

/// Test session notifier
class TestNotifier extends StateNotifier<TestState?> {
  TestNotifier() : super(null);

  Timer? _totalTimer;
  Timer? _questionTimer;
  final _uuid = const Uuid();

  /// Start a new test session
  void startTest({int questionsPerCategory = 8}) {
    // Cancel any existing timers
    _cancelTimers();

    final questions = getTestQuestions(questionsPerCategory: questionsPerCategory);

    state = TestState(
      id: _uuid.v4(),
      questions: questions,
      startedAt: DateTime.now(),
    );

    // Start total timer
    _startTotalTimer();
    _startQuestionTimer();
  }

  void _startTotalTimer() {
    _totalTimer?.cancel();
    _totalTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state != null && !state!.isComplete) {
        state = state!.copyWith(
          totalTimeSeconds: state!.totalTimeSeconds + 1,
        );
      }
    });
  }

  void _startQuestionTimer() {
    _questionTimer?.cancel();
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state != null && !state!.isComplete) {
        state = state!.copyWith(
          currentQuestionTimeSeconds: state!.currentQuestionTimeSeconds + 1,
        );
      }
    });
  }

  void _cancelTimers() {
    _totalTimer?.cancel();
    _questionTimer?.cancel();
  }

  /// Submit answer for current question
  void submitAnswer(dynamic answer) {
    if (state == null || state!.currentQuestion == null) return;

    final question = state!.currentQuestion!;
    final isCorrect = question.isCorrect(answer);
    final timeSpent = state!.currentQuestionTimeSeconds;

    final questionAnswer = QuestionAnswer(
      questionId: question.id,
      userAnswer: answer,
      isCorrect: isCorrect,
      timeSpentSeconds: timeSpent,
      answeredAt: DateTime.now(),
    );

    final newAnswers = [...state!.answers, questionAnswer];

    // Adaptive difficulty logic
    int newConsecutiveCorrect = isCorrect ? state!.consecutiveCorrect + 1 : 0;
    int newConsecutiveWrong = isCorrect ? 0 : state!.consecutiveWrong + 1;
    Difficulty newDifficulty = state!.currentDifficulty;

    // Increase difficulty after 2 consecutive correct answers
    if (newConsecutiveCorrect >= 2 &&
        state!.currentDifficulty != Difficulty.hard) {
      newDifficulty = state!.currentDifficulty == Difficulty.easy
          ? Difficulty.medium
          : Difficulty.hard;
      newConsecutiveCorrect = 0;
    }

    // Decrease difficulty after 2 consecutive wrong answers
    if (newConsecutiveWrong >= 2 &&
        state!.currentDifficulty != Difficulty.easy) {
      newDifficulty = state!.currentDifficulty == Difficulty.hard
          ? Difficulty.medium
          : Difficulty.easy;
      newConsecutiveWrong = 0;
    }

    final nextIndex = state!.currentIndex + 1;
    final isComplete = nextIndex >= state!.questions.length;

    state = state!.copyWith(
      answers: newAnswers,
      currentIndex: nextIndex,
      currentQuestionTimeSeconds: 0,
      isComplete: isComplete,
      currentDifficulty: newDifficulty,
      consecutiveCorrect: newConsecutiveCorrect,
      consecutiveWrong: newConsecutiveWrong,
    );

    if (isComplete) {
      _cancelTimers();
    } else {
      // Reset question timer for next question
      _startQuestionTimer();
    }
  }

  /// Skip current question (counts as wrong)
  void skipQuestion() {
    submitAnswer(null);
  }

  /// Get the test result
  TestResult? getResult() {
    if (state == null || !state!.isComplete) return null;

    return TestResult.fromTestSession(
      id: state!.id,
      completedAt: DateTime.now(),
      totalTimeSeconds: state!.totalTimeSeconds,
      questions: state!.questions,
      answers: state!.answers,
    );
  }

  /// End the test early
  void endTest() {
    if (state != null) {
      state = state!.copyWith(isComplete: true);
    }
    _cancelTimers();
  }

  /// Reset/clear the test state
  void resetTest() {
    _cancelTimers();
    state = null;
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }
}

/// Provider for test session
final testProvider = StateNotifierProvider<TestNotifier, TestState?>(
  (ref) => TestNotifier(),
);

/// Provider for formatted total time
final formattedTotalTimeProvider = Provider<String>((ref) {
  final testState = ref.watch(testProvider);
  if (testState == null) return '00:00';

  final minutes = testState.totalTimeSeconds ~/ 60;
  final seconds = testState.totalTimeSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
});

/// Provider for formatted question time
final formattedQuestionTimeProvider = Provider<String>((ref) {
  final testState = ref.watch(testProvider);
  if (testState == null) return '0s';

  return '${testState.currentQuestionTimeSeconds}s';
});
