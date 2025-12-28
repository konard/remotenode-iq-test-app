import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/models.dart';

/// Results storage notifier
class ResultsNotifier extends StateNotifier<List<TestResult>> {
  ResultsNotifier() : super([]) {
    _loadResults();
  }

  static const _boxName = 'test_results';

  Future<void> _loadResults() async {
    try {
      final box = await Hive.openBox<TestResult>(_boxName);
      state = box.values.toList()
        ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
    } catch (e) {
      state = [];
    }
  }

  Future<void> saveResult(TestResult result) async {
    try {
      final box = await Hive.openBox<TestResult>(_boxName);
      await box.put(result.id, result);
      state = [...state, result]
        ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
    } catch (e) {
      // Handle error silently or show error
    }
  }

  Future<void> deleteResult(String id) async {
    try {
      final box = await Hive.openBox<TestResult>(_boxName);
      await box.delete(id);
      state = state.where((r) => r.id != id).toList();
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> clearAllResults() async {
    try {
      final box = await Hive.openBox<TestResult>(_boxName);
      await box.clear();
      state = [];
    } catch (e) {
      // Handle error silently
    }
  }

  /// Get the best result (highest IQ score)
  TestResult? get bestResult {
    if (state.isEmpty) return null;
    return state.reduce((a, b) => a.iqScore > b.iqScore ? a : b);
  }

  /// Get the most recent result
  TestResult? get latestResult {
    if (state.isEmpty) return null;
    return state.first; // Already sorted by completedAt descending
  }

  /// Get average IQ score
  double get averageIQ {
    if (state.isEmpty) return 0;
    return state.map((r) => r.iqScore).reduce((a, b) => a + b) / state.length;
  }
}

/// Provider for results
final resultsProvider = StateNotifierProvider<ResultsNotifier, List<TestResult>>(
  (ref) => ResultsNotifier(),
);

/// Provider for best result
final bestResultProvider = Provider<TestResult?>((ref) {
  final results = ref.watch(resultsProvider);
  if (results.isEmpty) return null;
  return results.reduce((a, b) => a.iqScore > b.iqScore ? a : b);
});

/// Provider for latest result
final latestResultProvider = Provider<TestResult?>((ref) {
  final results = ref.watch(resultsProvider);
  if (results.isEmpty) return null;
  return results.first;
});
