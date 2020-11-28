import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuth {
  Future<User> signIn(String email, String password);

  Future<User> signUp(String email, String password);

  User getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  bool isEmailVerified();

  bool isSignedIn();
}

class Auth implements IAuth {
  Auth() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  FirebaseAuth _firebaseAuth;

  Future<User> signIn(String email, String password) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final user = result.user;
    return user;
  }

  Future<User> signUp(String email, String password) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = result.user;
    return user;
  }

  User getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() {
    final user = _firebaseAuth.currentUser;
    return user.sendEmailVerification();
  }

  bool isEmailVerified() {
    final user = _firebaseAuth.currentUser;
    return user.emailVerified;
  }

  bool isSignedIn() => _firebaseAuth.currentUser != null;
}
