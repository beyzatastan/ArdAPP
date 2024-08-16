import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/extensions/user_tile.dart';
import 'package:noteapp/screens/ChatApp/convosScreen.dart';
import 'package:noteapp/services/chats/chat_services.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatServices.getUsersStream(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Map<String, dynamic>> users = snapshot.data ?? [];
        return ListView(
          children: users
              .where((userData) => userData["email"] != getCurrentUser()?.email)
              .map((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    return UserTile(
      text: userData["name"],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Convosscreen(
              receiverName: userData["name"],
              receiverId: userData["id"],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: HexColor(backgroundColor),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: HexColor(noteColor), size: 40),
                ),
                SizedBox(width: 16),
                Text(
                  getCurrentUser()?.displayName ?? "Username",
                  style: TextStyle(fontSize: 20, fontFamily: "Inter"),
                ),
              ],
            ),
          ),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }
}
