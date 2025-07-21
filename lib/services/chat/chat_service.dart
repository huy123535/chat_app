import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/models/message.dart';
import 'package:untitled2/services/database/database_service.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individual user
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverID, String message) async {
    //get current user
    final String currentUserID = _auth.currentUser!.uid;

    //fetch current user's username
    final currentUserName =
        await DatabaseService(uid: currentUserID).getUserData();
    final String CurrentUserName = currentUserName['username'];

    //fetch receiver's username
    final receiverUserName =
        await DatabaseService(uid: receiverID).getUserData();
    final String receiverName = receiverUserName['username'];

    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderName: CurrentUserName,
      receiverID: receiverID,
      receiverName: receiverName,
      message: message,
      timestamp: timestamp,
    );

    // construct a chat room
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // sort the ids (chatroomID is the same for 2 users)
    String chatRoomID = ids.join("_");

    DocumentSnapshot chatRoomDoc =
        await _firestore.collection("chat_rooms").doc(chatRoomID).get();
    if (!chatRoomDoc.exists) {
      await _firestore.collection("chat_rooms").doc(chatRoomID).set({
        "users": ids,
      });
    }

    // add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    // construct a chat room
    List<String> ids = [userID, otherUserID];
    ids.sort(); // sort the ids (chatroomID is the same for 2 users)
    String chatRoomID = ids.join("_");
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Stream<List<Map<String, dynamic>>> getUserChatRoomsWithLastMessage(
      String userID) async* {
    final chatRoomsStream = _firestore
        .collection("chat_rooms")
        .where("users", arrayContains: userID)
        .snapshots()
        .map((snapshots) => snapshots.docs.map((doc) {
              final chatRoomData = doc.data();
              chatRoomData['chatRoomID'] = doc.id;
              return chatRoomData;
            }).toList());

    await for (final chatRooms in chatRoomsStream) {
      final chatRoomsWithLastMessage =
          await Future.wait(chatRooms.map((chatRoom) async {
        final chatRoomID = chatRoom['chatRoomID'];
        final lastMessageSnapshot = await _firestore
            .collection("chat_rooms")
            .doc(chatRoomID)
            .collection("messages")
            .orderBy("timestamp", descending: true)
            .limit(1)
            .get();
        if (lastMessageSnapshot.docs.isNotEmpty) {
          final lastMessage = lastMessageSnapshot.docs.first.data();
          chatRoom['lastMessage'] = lastMessage;
        } else {
          chatRoom['lastMessage'] = null;
        }
        return chatRoom;
      }).toList());

      // sort chatRoomsWithLastMessage by the timestamp of the last message
      chatRoomsWithLastMessage.sort((a, b) {
        final aTimestamp =
            a['lastMessage'] != null ? a['lastMessage']['timestamp'] : null;
        final bTimestamp =
            b['lastMessage'] != null ? b['lastMessage']['timestamp'] : null;
        return bTimestamp!.compareTo(aTimestamp!);
      });

      yield chatRoomsWithLastMessage;
    }
  }


}
