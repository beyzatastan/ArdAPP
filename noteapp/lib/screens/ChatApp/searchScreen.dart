import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/ChatApp/addGroupChat.dart';
import 'package:noteapp/screens/ChatApp/chatScreen.dart';
import 'package:noteapp/screens/ChatApp/convosScreen.dart';
import 'package:noteapp/utils/services/chats/chat_services.dart';
import 'package:noteapp/widgets/widgets.dart';

class Searchscreen extends StatefulWidget {
  final Stream<List<Map<String, dynamic>>> usersStream;
  const Searchscreen({super.key, required this.usersStream});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  TextEditingController searchController = TextEditingController();
    // Chat & Auth Services
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<Map<String, dynamic>> filteredConvos = [];
  List<Map<String, dynamic>> allConvos = [];

  @override
  void initState() {
    super.initState();
    widget.usersStream.listen((convos) {
      String currentUserId = _firebaseAuth.currentUser!.uid;
      setState(() {
        allConvos =
            convos.where((item) => item["id"] != currentUserId).toList();
        filteredConvos = allConvos;
      });
    });
  }

  void filterSearch(String query) {
    setState(() {
      filteredConvos = allConvos
          .where((item) => item["name"]!
              .toLowerCase()
              .toUpperCase()
              .contains(query.toLowerCase().toUpperCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
  backgroundColor: HexColor(backgroundColor),
  leading: backButton(context, Chatscreen()),
  title: Padding(
    padding: const EdgeInsets.fromLTRB(0, 20, 3, 20), 
    child: Row(
      children: [
        Flexible(
          child: searchField(filterSearch,"Search for users...")
        ),
        IconButton(
          onPressed: () {
           Navigator.of(context).push(MaterialPageRoute(builder:(context) => addGroupChat(usersStream: _chatServices.getUsersStream(),)));
          },
          color: HexColor(buttonBackground),
          icon: const Icon(
            CupertinoIcons.group_solid,
            size: 30,
          ),
        ),
      ],
    ),
  ),
),
      body: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: filteredConvos.length,
                  itemBuilder: (context, index) {
                    final item = filteredConvos[index];
                    return Slidable(
                      key: Key(item["name"] ?? ""),
                      endActionPane:
                          ActionPane(motion: const DrawerMotion(), children: [
                        SlidableAction(
                          onPressed: (context) {},
                          backgroundColor: Colors.red,
                          icon: Icons.delete_outline,
                        )
                      ]),
                      child: ListTile(
                        title: Row(
                          children: [
                            CircleAvatar(
                backgroundColor: Colors.black,
                backgroundImage: item["picture"] != null && item["picture"].isNotEmpty
                    ? NetworkImage(item["picture"])
                    : const AssetImage('assets/images/1024.png')
                        as ImageProvider, // Casting for compatibility
                radius: 25,
              ),SizedBox(width: 10,),
                            Text(item["name"] ?? "",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Inter",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        contentPadding: const EdgeInsets.all(14),
                        tileColor: HexColor(backgroundColor),
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => Convosscreen(
                                      receiverName: item["name"] ?? "",
                                      receiverId: item["id"] ?? "",
                                    )), (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }

}
