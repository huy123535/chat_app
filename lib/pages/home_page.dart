import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/components/my_drawer.dart';
import 'package:untitled2/components/user_tile.dart';
import 'package:untitled2/pages/search_page.dart';
import 'package:untitled2/services/database/database_service.dart';
import '../services/auth/auth_service.dart';
import '../components/widget.dart';
import '../services/chat/chat_service.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  // Method to refresh home page
  void refreshHomePage() {
    setState(() {});
  }

  void logout() {
    // get auth database
    _authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text("Home"),
          actions: [
            IconButton(
                onPressed: () {
                  nextScreen(context, const SearchPage());
                },
                icon: const Icon(Icons.search)),
          ],
        ),
        drawer: const MyDrawer(),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _chatService.getUserChatRoomsWithLastMessage(
              _authService.getCurrentUser()!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              print("Error loading chatrooms: ${snapshot.error}");
              return const Center(
                child: Text("Error loading chatrooms"),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text("No chatrooms found"),
              );
            }
            final chatRooms = snapshot.data!;

            return ListView.builder(
              itemCount: chatRooms.length,
              itemBuilder: (context, index) {
                final chatRoom = chatRooms[index];
                final chatRoomID = chatRoom['chatRoomID'];
                final List<dynamic> users = chatRoom['users'];
                // Check for null or invalid chatRoomID
                if (chatRoomID == null || chatRoomID.isEmpty || users.isEmpty) {
                  print("Invalid chat room ID: $chatRoomID");
                  return ListTile(
                    title: Text("Invalid chat room"),
                  );
                }

                final currentUserID = _authService.getCurrentUser()!.uid;
                final otherUserID =
                    users.firstWhere((id) => id != currentUserID);

                final lastMessage = chatRoom['lastMessage']?['message'];
                final lastMessageTimestamp =
                    chatRoom['lastMessage']?['timestamp'];

                return FutureBuilder<DocumentSnapshot>(
                    future: DatabaseService(uid: otherUserID).getUserData(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (userSnapshot.hasError || !userSnapshot.hasData) {
                        print("Error loading user: ${userSnapshot.error}");
                        return const ListTile(
                          title: Text("Error loading user"),
                        );
                      }
                      final userData =userSnapshot.data!.data() as Map<String, dynamic>;
                      final otherUserName = userData['username'];
                      return UserTile(
                        text: otherUserName,
                        lastMessage: lastMessage,
                        time: lastMessageTimestamp,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                        receiverID: otherUserID,
                                        receiverName: otherUserName,
                                      ))).then((value) {
                            refreshHomePage();
                          });
                        },
                      );
                    });
              },
            );
          },
        ));
  }
}
