import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:flutter_highlighter/themes/atom-one-light.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_colors.dart';
import 'package:flutter/services.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final String _codeSnippet = '''
List<int> reverseList(List<int> input) {
  List<int> reversed = [];
  for (int i = input.length - 1; i >= 0; i--) {
    reversed.add(input[i]);
  }
  return reversed;
}

void main() {
  var numbers = [1, 2, 3, 4, 5];
  print(reverseList(numbers)); // Output: [5, 4, 3, 2, 1]
}
''';

  bool _isSubmitting = false;
  bool _showOutput = false;

  void _runCode(BuildContext context) async {
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _showOutput = true;
      });
      Provider.of<AppState>(context, listen: false).completeChallenge(50);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('+50 Points awarded!')),
      );
    }
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _codeSnippet));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Challenge'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.violet.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Medium',
                      style: TextStyle(color: AppColors.violet, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('50 Points', style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 16),
              Text('Reverse a List', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 8),
              Text(
                'Write a function that reverses a given list of integers without using the built-in reversed method.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: isDark ? AppColors.navy : Colors.grey[200],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('main.dart', style: GoogleFonts.firaCode(fontSize: 14)),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: _copyCode,
                            tooltip: 'Copy Code',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: HighlightView(
                        _codeSnippet,
                        language: 'dart',
                        theme: isDark ? atomOneDarkTheme : atomOneLightTheme,
                        padding: const EdgeInsets.all(16),
                        textStyle: GoogleFonts.firaCode(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (_showOutput) ...[
                Text('Output', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.navy : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Text(
                    '[5, 4, 3, 2, 1]\n\nProgram finished successfully.',
                    style: GoogleFonts.firaCode(
                      fontSize: 14,
                      color: isDark ? Colors.greenAccent : Colors.green[700],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : () => _runCode(context),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Run Code'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
