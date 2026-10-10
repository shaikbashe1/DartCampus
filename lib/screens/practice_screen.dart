import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../services/database_service.dart';
import '../theme/app_colors.dart';
import 'package:flutter/services.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final _dbService = DatabaseService();
  
  static const String _defaultCode = '''
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

  late TextEditingController _codeController;

  bool _isSubmitting = false;
  bool _showOutput = false;
  String _output = '';
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: _defaultCode);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _resetCode() {
    setState(() {
      _codeController.text = _defaultCode;
      _showOutput = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code reset to default template.')),
    );
  }

  void _runCode(BuildContext context) async {
    setState(() {
      _isSubmitting = true;
      _showOutput = false;
      _output = '';
      _isError = false;
    });
    
    try {
      final response = await http.post(
        Uri.parse('https://emkc.org/api/v2/piston/execute'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'language': 'dart',
          'version': '3.3.0',
          'files': [
            {
              'name': 'main.dart',
              'content': _codeController.text,
            }
          ]
        }),
      );

      final result = jsonDecode(response.body);
      
      if (mounted) {
        if (response.statusCode != 200 || result['run'] == null) {
          setState(() {
            _isSubmitting = false;
            _showOutput = true;
            _isError = true;
            _output = 'Execution API Error: \${result["message"] ?? "Unknown error"}';
          });
          return;
        }

        final runData = result['run'];
        final isSuccess = runData['code'] == 0;
        final stdout = runData['stdout'] ?? '';
        final stderr = runData['stderr'] ?? '';
        
        setState(() {
          _isSubmitting = false;
          _showOutput = true;
          _isError = !isSuccess;
          _output = stderr.isNotEmpty ? stderr : stdout;
          if (_output.isEmpty) _output = 'Program exited with no output.';
        });
        
        if (isSuccess) {
          await _dbService.submitCode('challenge_123', _codeController.text, 'dart', true);
          Provider.of<AppState>(context, listen: false).completeChallenge(50);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Accepted! +50 Points. Saved to database.'), backgroundColor: AppColors.success),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _showOutput = true;
          _isError = true;
          _output = 'Network Error: Failed to connect to Piston execution server.\\n\$e';
        });
      }
    }
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _codeController.text));
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
                          Row(
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.refresh, size: 18),
                                label: const Text('Reset Code'),
                                onPressed: _resetCode,
                              ),
                              IconButton(
                                icon: const Icon(Icons.copy, size: 20),
                                onPressed: _copyCode,
                                tooltip: 'Copy Code',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: isDark ? const Color(0xFF282C34) : const Color(0xFFFAFAFA),
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: _codeController,
                        maxLines: null,
                        minLines: 10,
                        keyboardType: TextInputType.multiline,
                        style: GoogleFonts.firaCode(
                          fontSize: 14,
                          color: isDark ? const Color(0xFFABB2BF) : const Color(0xFF383A42),
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8),
                        ),
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
                    _output,
                    style: GoogleFonts.firaCode(
                      fontSize: 14,
                      color: _isError
                          ? AppColors.error
                          : (isDark ? Colors.greenAccent : Colors.green[700]),
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
