
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
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
      body: Padding(
        padding: const EdgeInsets.only(top: 9),
        child: StreamBuilder(
          stream: _chatServices.getUsersStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            var convos = snapshot.data ?? [];
            String currentUserId = _firebaseAuth.currentUser!.uid;
            convos = convos.where((item) => item["id"] != currentUserId).toList();

            return ListView.builder(
              itemCount: convos.length,
              itemBuilder: (context, index) {
                final item = convos[index];
                return Slidable(
                  key: Key(item["name"] ?? ""),
                  endActionPane:
                      ActionPane(motion: const DrawerMotion(), children: [
                    SlidableAction(
                      onPressed: (context) {
                        //silme
                      },
                      backgroundColor: Colors.red,
                      icon: Icons.delete_outline,
                    )
                  ]),
                  child: ListTile(
                    title: Text(item["name"] ?? "",
                        style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Inter",
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  
                    contentPadding: const EdgeInsets.all(14),
                    tileColor: HexColor(backgroundColor),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => Convosscreen(
                                  receiverName: item["name"] ?? "",
                                  receiverId:item["id"] ?? ""
                                 
                                )),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
