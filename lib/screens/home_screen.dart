import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/providers.dart';
import '../utils/utils.dart';
import '../models/models.dart';
import '../data/questions.dart';
import 'test_screen.dart';
import 'results_screen.dart';
import 'settings_screen.dart';
import 'history_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestResult = ref.watch(latestResultProvider);

    return Scaffold(
      body: SafeArea(
        child: ResponsiveContainer(
          maxWidth: 600,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with settings
                _buildHeader(context),
                const SizedBox(height: 32),

                // Welcome section
                _buildWelcomeSection(context)
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.2, end: 0),
                const SizedBox(height: 32),

                // Test info cards
                _buildInfoCards(context)
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 32),

                // Category overview
                _buildCategoryOverview(context)
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms),
                const SizedBox(height: 32),

                // Start button
                _buildStartButton(context, ref)
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 600.ms)
                    .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
                const SizedBox(height: 16),

                // View previous results
                if (latestResult != null)
                  _buildViewResultsButton(context, latestResult)
                      .animate()
                      .fadeIn(delay: 700.ms, duration: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // App logo/title
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.psychology_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'IQ Test',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        // Settings and history buttons
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              ),
              tooltip: 'History',
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
              tooltip: 'Settings',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Discover Your\nCognitive Potential',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          'Take a comprehensive IQ test that evaluates your cognitive abilities across 5 key areas.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
        ),
      ],
    );
  }

  Widget _buildInfoCards(BuildContext context) {
    final totalQuestions = allQuestions.length;

    return Row(
      children: [
        Expanded(
          child: _InfoCard(
            icon: Icons.timer_outlined,
            title: '25-35',
            subtitle: 'Minutes',
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoCard(
            icon: Icons.quiz_outlined,
            title: '$totalQuestions',
            subtitle: 'Questions',
            color: AppColors.accent,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoCard(
            icon: Icons.category_outlined,
            title: '5',
            subtitle: 'Categories',
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryOverview(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Categories',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ...QuestionCategory.values.map((category) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _CategoryRow(category: category),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        ref.read(testProvider.notifier).startTest();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TestScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.play_arrow_rounded, size: 28),
          const SizedBox(width: 8),
          Text(
            'Start Test',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewResultsButton(BuildContext context, TestResult result) {
    return OutlinedButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ResultsScreen(result: result)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bar_chart_rounded),
          const SizedBox(width: 8),
          Text('View Last Result (IQ: ${result.iqScore})'),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _InfoCard({
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
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
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

class _CategoryRow extends StatelessWidget {
  final QuestionCategory category;

  const _CategoryRow({required this.category});

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

  IconData get _categoryIcon {
    switch (category) {
      case QuestionCategory.verbal:
        return Icons.text_fields;
      case QuestionCategory.numerical:
        return Icons.calculate_outlined;
      case QuestionCategory.logical:
        return Icons.psychology_outlined;
      case QuestionCategory.spatial:
        return Icons.view_in_ar_outlined;
      case QuestionCategory.pattern:
        return Icons.grid_view_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _categoryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _categoryIcon,
            color: _categoryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.displayName,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(
                category.description,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
