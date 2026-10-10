import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  int _points = 0;
  int _streakDays = 12;
  int _completedLessons = 42;
  final int _totalLessons = 64;

  int get points => _points;
  int get streakDays => _streakDays;
  int get completedLessons => _completedLessons;
  int get totalLessons => _totalLessons;
  double get progressPercent => _completedLessons / _totalLessons;

  AppState() {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _points = prefs.getInt('points') ?? 250;
    _streakDays = prefs.getInt('streakDays') ?? 12;
    _completedLessons = prefs.getInt('completedLessons') ?? 42;
    notifyListeners();
  }

  Future<void> completeChallenge(int rewardPoints) async {
    _points += rewardPoints;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('points', _points);
    notifyListeners();
  }

  Future<void> completeLesson() async {
    if (_completedLessons < _totalLessons) {
      _completedLessons++;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('completedLessons', _completedLessons);
      notifyListeners();
    }
  }
}
