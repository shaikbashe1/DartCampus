import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Record a coding submission
  Future<void> submitCode(String challengeId, String code, String language, bool isSuccess) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('submissions').add({
      'studentId': user.uid,
      'challengeId': challengeId,
      'code': code,
      'language': language,
      'isSuccess': isSuccess,
      'timestamp': FieldValue.serverTimestamp(),
    });

    if (isSuccess) {
      // Award points and update weakness detection stats safely
      final userRef = _db.collection('users').doc(user.uid);
      await _db.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);
        if (!snapshot.exists) return;

        int currentPoints = snapshot.data()?['points'] ?? 0;
        int completed = snapshot.data()?['completedChallenges'] ?? 0;

        transaction.update(userRef, {
          'points': currentPoints + 50,
          'completedChallenges': completed + 1,
          'lastActive': FieldValue.serverTimestamp(),
        });
      });
    }
  }

  // Fetch Admin Stats
  Stream<Map<String, int>> getAdminStats() {
    // In a real production app, use aggregation queries. 
    // For this prototype, we'll stream basic counts (Note: requires Firestore indexes)
    return _db.collection('users').snapshots().map((snapshot) {
      return {
        'totalStudents': snapshot.docs.where((d) => d.data()['role'] != 'admin').length,
        'activeChallenges': 12, // Mocked for now until challenge collection is built
      };
    });
  }
}
