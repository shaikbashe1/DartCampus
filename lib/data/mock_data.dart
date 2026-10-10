class MockData {
  static const String userName = 'Alex';
  static const String userAvatar = 'https://i.pravatar.cc/150?img=11';
  static const int streakDays = 12;
  static const double progressPercent = 0.65;
  static const int completedLessons = 42;
  static const int totalLessons = 64;

  static const Map<String, dynamic> dailyChallenge = {
    'title': 'Reverse a List',
    'description': 'Write a function that reverses a given list of integers without using the built-in reversed method.',
    'difficulty': 'Medium',
    'points': 50,
  };

  static const List<Map<String, dynamic>> recommendedTopics = [
    {
      'title': 'Null Safety',
      'description': 'Master sound null safety in Dart 3.',
      'icon': 'shield',
      'progress': 0.8,
    },
    {
      'title': 'Async Programming',
      'description': 'Futures, Streams, and async/await.',
      'icon': 'timer',
      'progress': 0.3,
    },
    {
      'title': 'Collections',
      'description': 'Lists, Sets, and Maps in depth.',
      'icon': 'list',
      'progress': 0.0,
    },
  ];

  static const List<double> weeklyActivity = [2.0, 1.5, 3.0, 0.5, 2.5, 4.0, 1.0]; // Hours spent learning per day
}
