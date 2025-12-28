import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import '../models/models.dart';
import '../utils/utils.dart';

class ResultsScreen extends ConsumerStatefulWidget {
  final TestResult result;

  const ResultsScreen({super.key, required this.result});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  final _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final result = widget.result;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: _shareResults,
            tooltip: 'Share Results',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ResponsiveContainer(
            maxWidth: 600,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // IQ Score Card
                Screenshot(
                  controller: _screenshotController,
                  child: _buildScoreCard(context, result)
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(begin: const Offset(0.8, 0.8)),
                ),
                const SizedBox(height: 24),

                // Stats Row
                _buildStatsRow(context, result)
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms),
                const SizedBox(height: 24),

                // Category Breakdown with Radar Chart
                _buildCategoryBreakdown(context, result)
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms),
                const SizedBox(height: 24),

                // Interpretation
                _buildInterpretation(context, result)
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 600.ms),
                const SizedBox(height: 24),

                // Action buttons
                _buildActionButtons(context)
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 600.ms),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context, TestResult result) {
    return Card(
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ],
          ),
        ),
        child: Column(
          children: [
            Text(
              'Your IQ Score',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              '${result.iqScore}',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 72,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                result.iqRange.displayName,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.trending_up, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Top ${100 - result.percentile}% of test takers',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, TestResult result) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_outline,
            title: '${result.correctAnswers}/${result.totalQuestions}',
            subtitle: 'Correct',
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.percent,
            title: '${result.accuracy.toStringAsFixed(1)}%',
            subtitle: 'Accuracy',
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.timer_outlined,
            title: _formatTime(result.totalTimeSeconds),
            subtitle: 'Time',
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdown(BuildContext context, TestResult result) {
    final scores = result.categoryScores;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Breakdown',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // Radar Chart
            SizedBox(
              height: 250,
              child: RadarChart(
                RadarChartData(
                  dataSets: [
                    RadarDataSet(
                      fillColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.3),
                      borderColor: Theme.of(context).colorScheme.primary,
                      borderWidth: 2,
                      entryRadius: 3,
                      dataEntries: QuestionCategory.values.map((category) {
                        return RadarEntry(value: scores[category] ?? 0);
                      }).toList(),
                    ),
                  ],
                  radarBackgroundColor: Colors.transparent,
                  radarBorderData: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                  titlePositionPercentageOffset: 0.2,
                  titleTextStyle: Theme.of(context).textTheme.labelSmall,
                  getTitle: (index, angle) {
                    final category = QuestionCategory.values[index];
                    return RadarChartTitle(
                      text: category.displayName.split(' ').first,
                      angle: angle,
                    );
                  },
                  tickCount: 5,
                  ticksTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 8,
                      ),
                  tickBorderData: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.5),
                    width: 1,
                  ),
                  gridBorderData: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Category bars
            ...QuestionCategory.values.map((category) {
              final score = scores[category] ?? 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CategoryBar(
                  category: category,
                  score: score,
                  correct: result.categoryCorrect[category.name] ?? 0,
                  total: result.categoryTotal[category.name] ?? 0,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInterpretation(BuildContext context, TestResult result) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Interpretation',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              result.iqRange.interpretation,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: const Icon(Icons.home_outlined),
          label: const Text('Back to Home'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _shareResults,
          icon: const Icon(Icons.share_outlined),
          label: const Text('Share Results'),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${secs}s';
    }
    return '${secs}s';
  }

  Future<void> _shareResults() async {
    try {
      final image = await _screenshotController.capture();
      if (image != null) {
        await Share.shareXFiles(
          [XFile.fromData(image, mimeType: 'image/png', name: 'iq_result.png')],
          text: 'I scored ${widget.result.iqScore} on the IQ Test! '
              'That puts me in the ${widget.result.iqRange.displayName} range.',
        );
      } else {
        // Fallback to text sharing
        await Share.share(
          'I scored ${widget.result.iqScore} on the IQ Test! '
          'That puts me in the ${widget.result.iqRange.displayName} range '
          '(top ${100 - widget.result.percentile}% of test takers).',
        );
      }
    } catch (e) {
      // Fallback to text sharing
      await Share.share(
        'I scored ${widget.result.iqScore} on the IQ Test! '
        'That puts me in the ${widget.result.iqRange.displayName} range.',
      );
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final QuestionCategory category;
  final double score;
  final int correct;
  final int total;

  const _CategoryBar({
    required this.category,
    required this.score,
    required this.correct,
    required this.total,
  });

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category.displayName,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              '$correct/$total (${score.toStringAsFixed(0)}%)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 8,
            backgroundColor: _color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation(_color),
          ),
        ),
      ],
    );
  }
}
