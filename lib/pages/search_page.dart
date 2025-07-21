import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/components/user_tile.dart';
import 'package:untitled2/components/widget.dart';
import 'package:untitled2/services/auth/auth_service.dart';
import 'chat_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _searchResult = [];
  bool _isSearching = false;
  final _authService = AuthService();

  void _searchUsers() async {
    setState(() {
      _isSearching = true;
    });
    final query = _searchController.text;
    if (query.isNotEmpty) {
      try {
        final result = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isGreaterThanOrEqualTo: query)
            .where('username', isLessThanOrEqualTo: '$query\uf8ff')
            .get();
        setState(() {
          _searchResult = result.docs;
        });
      } catch (e) {
        print('Error searching users: $e');
      }
    } else {
      setState(() {
        _searchResult = [];
      });
    }
    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Search",
          style: TextStyle(fontSize: 27),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.tertiary,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "Search users...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _searchUsers,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          _isSearching
              ? const CircularProgressIndicator()
              : Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final user =
                          _searchResult[index].data() as Map<String, dynamic>;
                      if (user['uid'] != _authService.getCurrentUser()!.uid) {
                        return UserTile(
                          text: user['username'],
                          onTap: () {
                            nextScreen(
                              context,
                              ChatPage(
                                receiverName: user['username'],
                                receiverID: user['uid'],
                              ),
                            );
                          },
                        );
                      }
                    },
                    itemCount: _searchResult.length,
                  ),
                ),
        ],
      ),
    );
  }
}
