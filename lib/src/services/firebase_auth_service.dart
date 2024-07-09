import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseAuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? getCurrentUser() {
    _firebaseAuth.authStateChanges();
    return _firebaseAuth.currentUser;
  }

  signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    print(email);
    print(password);
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  signOut() async {
    await _firebaseAuth.signOut();
  }
}

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});
