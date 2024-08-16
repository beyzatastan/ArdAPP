import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/extensions/user_tile.dart';
import 'package:noteapp/screens/ChatApp/convosScreen.dart';
import 'package:noteapp/screens/ChatApp/searchScreen.dart';
import 'package:noteapp/screens/login/optionScreen.dart';
import 'package:noteapp/services/chats/chat_services.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Optionscreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
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
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: _buildUserList()),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.chat_bubble_sharp)),
                IconButton(onPressed: () {}, icon: Icon(Icons.chat_bubble_sharp)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future deleteChat(String chatId) async {
  }

//build a list of users except current user
Widget _buildUserList(){
  return StreamBuilder(stream: _chatServices.getUsersStream(), builder:(context, snapshot) {
    if(snapshot.hasError){
      return Text("error");
    }if(snapshot.connectionState == ConnectionState.waiting){
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: snapshot.data!.map<Widget>((userData)=>_buildUserListItem(userData,context)).toList(),
    );
  },);
}
Widget _buildUserListItem(Map<String,dynamic> userData,BuildContext context){
 if(userData["email"] != getCurrentUser()!.email){
   //display all users except
  return UserTile(text: userData["name"],
  onTap: (){
    Navigator.push(context, MaterialPageRoute(builder:(context) => Convosscreen(receiverName: userData["name"] , receiverId: userData["id"]),));
  },);
 }
 else{
  return Container();
 }
}

}
