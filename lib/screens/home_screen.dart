import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../data/mock_data.dart';
import '../theme/app_colors.dart';
import '../widgets/activity_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, appState),
              const SizedBox(height: 32),
              _buildDailyChallenge(context),
              const SizedBox(height: 24),
              _buildStatsRow(context, appState),
              const SizedBox(height: 32),
              Text(
                'Continue Learning',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildRecommendedTopics(context),
              const SizedBox(height: 32),
              Text(
                'Weekly Activity',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ActivityChart(weeklyData: MockData.weeklyActivity),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppState appState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              MockData.userName,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
        const CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.violet,
          child: Icon(Icons.person, color: AppColors.white),
        ),
      ],
    );
  }

  Widget _buildDailyChallenge(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
              ? [AppColors.navyLight, AppColors.violet.withValues(alpha: 0.4)]
              : [AppColors.teal, AppColors.teal.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.violet : AppColors.teal).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                'Daily Challenge',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+${MockData.dailyChallenge['points']} pts',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            MockData.dailyChallenge['title'],
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            MockData.dailyChallenge['description'],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: isDark ? AppColors.navy : AppColors.teal,
            ),
            child: const Text('Start Challenge'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, AppState appState) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orange, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '${appState.streakDays} Days',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text('Current Streak', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircularProgressIndicator(
                    value: appState.progressPercent,
                    backgroundColor: Theme.of(context).dividerColor,
                    color: AppColors.violet,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${appState.completedLessons}/${appState.totalLessons}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text('Lessons', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedTopics(BuildContext context) {
    return Column(
      children: MockData.recommendedTopics.map((topic) {
        IconData iconData;
        switch (topic['icon']) {
          case 'shield': iconData = Icons.security; break;
          case 'timer': iconData = Icons.timer; break;
          case 'list': iconData = Icons.list; break;
          default: iconData = Icons.book;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: AppColors.teal),
            ),
            title: Text(topic['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(topic['description'], maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: topic['progress'],
                  backgroundColor: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
              onPressed: () {},
            ),
          ),
        );
      }).toList(),
    );
  }
}
