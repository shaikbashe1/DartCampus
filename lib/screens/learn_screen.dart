import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> modules = [
      {'title': 'Dart Basics', 'lessons': 10, 'completed': 10},
      {'title': 'Object-Oriented Programming', 'lessons': 15, 'completed': 15},
      {'title': 'Collections & Generics', 'lessons': 12, 'completed': 12},
      {'title': 'Asynchronous Programming', 'lessons': 8, 'completed': 5},
      {'title': 'Null Safety Deep Dive', 'lessons': 9, 'completed': 0},
      {'title': 'Advanced Flutter State', 'lessons': 10, 'completed': 0},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Curriculum'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '${appState.points} pts',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.teal),
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          final progress = module['completed'] / module['lessons'];
          final isCompleted = progress >= 1.0;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: isCompleted 
                    ? AppColors.success.withValues(alpha: 0.2) 
                    : AppColors.violet.withValues(alpha: 0.1),
                child: Icon(
                  isCompleted ? Icons.check : Icons.menu_book,
                  color: isCompleted ? AppColors.success : AppColors.violet,
                ),
              ),
              title: Text(module['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Theme.of(context).dividerColor,
                  color: isCompleted ? AppColors.success : AppColors.violet,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        appState.completeLesson();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Lesson completed! Progress saved.')),
                        );
                      },
                      child: const Text('Start Next Lesson'),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
