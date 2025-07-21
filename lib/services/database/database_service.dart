import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  // updating the userdata
  Future<void> savingUserData(String username, String email) async {
    return await userCollection.doc(uid).set({
      'username': username,
      'email': email,
      'uid': uid,
    });
  }

  // fetch user data
  Future<DocumentSnapshot> getUserData() async {
    return await userCollection.doc(uid).get();
  }
}
