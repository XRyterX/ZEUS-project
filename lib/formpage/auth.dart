//

import 'package:firebase_auth/firebase_auth.dart';

class AuthFirebase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   // Future<String?> signUp(String email, String password) async {
//   //   UserCredential authResult = await _firebaseAuth
//   //       .createUserWithEmailAndPassword(email: email, password: password);
//   //   User? user = authResult.user;
//   //   return user?.uid;
//   // }

  Future<String?> login(String email, String password) async {
    try {
      UserCredential authResult = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = authResult.user;
      return user?.uid;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User?> getUser() async {
    User? user = await _firebaseAuth.currentUser;
    return user;
  }

  signUp(String s, String t) {}
}
