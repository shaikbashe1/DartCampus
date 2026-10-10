import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  
  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;

  AuthService() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _checkRole(user.uid);
      } else {
        _isAdmin = false;
        notifyListeners();
      }
    });
  }

  Future<void> _checkRole(String uid) async {
    try {
      // In a production app, checking Custom Claims via ID Token is safer:
      // final idTokenResult = await currentUser?.getIdTokenResult();
      // _isAdmin = idTokenResult?.claims?['admin'] ?? false;
      
      // For now, we fallback to a Firestore role check
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data()?['role'] == 'admin') {
        _isAdmin = true;
      } else {
        _isAdmin = false;
      }
    } catch (e) {
      _isAdmin = false;
    }
    notifyListeners();
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An unknown error occurred';
    }
  }

  Future<String?> register(String email, String password, String name) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (cred.user != null) {
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'name': name,
          'email': email,
          'role': 'student', // Default role
          'createdAt': FieldValue.serverTimestamp(),
          'points': 0,
          'streakDays': 0,
        });
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Registration failed';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
