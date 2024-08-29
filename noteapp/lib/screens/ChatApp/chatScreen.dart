import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/extensions/user_tile.dart';
import 'package:noteapp/screens/ChatApp/convosScreen.dart';
import 'package:noteapp/screens/ChatApp/searchScreen.dart';
import 'package:noteapp/screens/login/optionScreen.dart';
import 'package:noteapp/utils/services/chats/chat_services.dart';
import 'package:noteapp/widgets/widgets.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {

  // Chat & Auth Services
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? getCurrentUser (){
    return _firebaseAuth.currentUser;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
        leading: backButton(context, Optionscreen()),
        backgroundColor: HexColor(backgroundColor),
        title: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Chats",
              style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => Searchscreen(usersStream: _chatServices.getUsersStream())
                  ));
                },
                color: HexColor(buttonBackground),
                icon: const Icon(
                  Icons.add_circle_outline_sharp,
                  size: 30,
                ),
              ),
            ]),
          )
        ],
      ),
      body: _buildUserList()
    );
  }

//build a list of users except current user
Widget _buildUserList() {
  return StreamBuilder<List<Map<String, dynamic>>>(
    stream: _chatServices.getUsersWithChatHistory(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text("Error: ${snapshot.error}");
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
  return Center(
    child: Column(
      mainAxisAlignment: (MainAxisAlignment.center),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.info_outline,
          size: 50,
          color: Colors.grey,
        ),
        const SizedBox(height: 10),
        const Text(
          "No users found",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: const Text(
            "You can start a new conversation by using the add button",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),],
    ),
  );
}
      final users = snapshot.data!;
       return ListView(
          children: users.map<Widget>((userData) {
            if (userData["email"] != getCurrentUser()!.email) {
              List<String> ids = [getCurrentUser()!.uid, userData["id"]];
              ids.sort();
              String chatRoomId = ids.join("_");

              return FutureBuilder<String>(
                future: _chatServices.getLastMessage(chatRoomId),
                builder: (context, messageSnapshot) {
                  if (!messageSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return UserTile(
                    text: userData["name"],
                    profile: userData["picture"],
                    chatId: chatRoomId,
                    receiverId: userData["id"],
                    lastMessage: messageSnapshot.data!,
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
                },
              );
            } else {
              return Container();
            }
          }).toList(),
        );
      },
    );
  }
}