import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.text,
    required this.profile,
    required this.chatId,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

  final String text;
  final void Function()? onTap;
  final void Function()? onDelete;
  final void Function()? onEdit;
  final String chatId;
  final dynamic profile;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(text),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              deleteCollection(chatId);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: HexColor(backgroundColor),
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                backgroundImage: profile != null && profile.isNotEmpty
                    ? NetworkImage(profile)
                    : const AssetImage('assets/images/1024.png')
                        as ImageProvider,
                radius: 35,
              ),
              const SizedBox(width: 17,),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "Inter",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Future<void> deleteCollection(String chatId) async {
  try {
    var snapshots = await FirebaseFirestore.instance
        .collection("Chats")
        .doc(chatId)
        .collection("Messages")
        .get();

    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }

    await FirebaseFirestore.instance
        .collection("Chats")
        .doc(chatId)
        .delete();

    print("Collection and document successfully deleted");
  } catch (e) {
    print("Error deleting collection: $e");
  }
}
