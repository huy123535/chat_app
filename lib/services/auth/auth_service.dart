import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/services/database/database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // sign in
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      User user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // sign up
  Future signUpWithEmailAndPassword(
      String username, String email, String password) async {
    try {
      User user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      // call our database database to update the userdatabase
      await DatabaseService(uid: user.uid).savingUserData(username, email);

      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

// error
}
