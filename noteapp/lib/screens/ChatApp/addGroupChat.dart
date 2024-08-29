import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/utils/services/chats/chat_services.dart';
import 'package:noteapp/widgets/widgets.dart';

class addGroupChat extends StatefulWidget {
 final Stream<List<Map<String, dynamic>>> usersStream;
  const addGroupChat({super.key, required this.usersStream});

  @override
  State<addGroupChat> createState() => _addGroupChatState();
}

class _addGroupChatState extends State<addGroupChat> {
  TextEditingController searchController = TextEditingController();
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

 List<String> chatRoomMemberIds=[];

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
  title: Padding(
    padding: const EdgeInsets.fromLTRB(0, 20, 3, 20), 
    child: Row(
      children: [
        Flexible(
          child: searchField(filterSearch,"Add user to group chat..."),
        ),
      ],
    ),
  ),
),
body:  Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(right: 300),
                child:CircleAvatar(),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredConvos.length,
                  itemBuilder: (context, index) {
                    final item = filteredConvos[index];
                      return ListTile(
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
                          chatRoomMemberIds.add(item["id"]);
                        },
                      );
                    
                  },
                ),
              ),
            ],
          )),
    );
  }

}
