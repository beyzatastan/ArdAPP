import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/ChatApp/setGroupChat.dart';
import 'package:noteapp/widgets/widgets.dart';

class addGroupChat extends StatefulWidget {
  final Stream<List<Map<String, dynamic>>> usersStream;
  const addGroupChat({super.key, required this.usersStream});

  @override
  State<addGroupChat> createState() => _addGroupChatState();
}

class _addGroupChatState extends State<addGroupChat> {
  TextEditingController searchController = TextEditingController();
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

  List<Map<String, dynamic>> chatRoomMemberIds = [];

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
                child: searchField(filterSearch, "Add user to group chat..."),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: [
            if (chatRoomMemberIds.isNotEmpty)
              Container(
                height: 100, // Avatarların yüksekliği
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: chatRoomMemberIds.length,
                  itemBuilder: (context, index) {
                    final member = chatRoomMemberIds[index];
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black,
                                  backgroundImage: member["picture"] != null &&
                                          member["picture"].isNotEmpty
                                      ? NetworkImage(member["picture"])
                                      : const AssetImage(
                                              'assets/images/1024.png')
                                          as ImageProvider,
                                  radius: 30,
                                ),
                                Positioned(
                                  top: -19,
                                  right: -18,
                                  child: IconButton(
                                    icon: Icon(Icons.close,
                                        size: 18,
                                        color: HexColor(buttonBackground)),
                                    onPressed: () {
                                      setState(() {
                                        chatRoomMemberIds.remove(member);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              member["name"],
                              style: const TextStyle(
                                fontFamily: "Inter",
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ));
                  },
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredConvos.length,
                itemBuilder: (context, index) {
                  final item = filteredConvos[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.all(14),
                    tileColor: HexColor(backgroundColor),
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage:
                          item["picture"] != null && item["picture"].isNotEmpty
                              ? NetworkImage(item["picture"])
                              : const AssetImage('assets/images/1024.png')
                                  as ImageProvider,
                      radius: 25,
                    ),
                    title: Text(
                      item["name"] ?? "",
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: "Inter",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      if (!chatRoomMemberIds.contains(item)) {
                        setState(() {
                          chatRoomMemberIds.add(item);
                        });
                      }
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Setgroupchat(chatRoomMemberIds: chatRoomMemberIds
                      )));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor(buttonBackground),
                    foregroundColor: HexColor(buttoncolor),
                    minimumSize: const Size(200, 63),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: const Text(
                  "Create a new group chat",
                  style: TextStyle(fontFamily: "Inter", fontSize: 20),
                )),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
