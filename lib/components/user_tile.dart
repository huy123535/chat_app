import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserTile extends StatefulWidget {
  final String text;
  final void Function()? onTap;
  final String? lastMessage;
  final Timestamp? time;

  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
    this.lastMessage,
    this.time,
  });

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    String formattedTime = widget.time != null
        ? DateFormat('hh:mm a MMM.d.yyyy').format(widget.time!.toDate())
        : "";
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 20),
                // username
                Text(widget.text),
                Spacer(),
                // Time
                Text(formattedTime, style: TextStyle(color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 10),
            // last message
            Text(
              widget.lastMessage ?? "",
              style: TextStyle(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
