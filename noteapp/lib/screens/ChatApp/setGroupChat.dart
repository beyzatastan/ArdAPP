import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/ChatApp/chatScreen.dart';
import 'package:noteapp/screens/ChatApp/groupConvoScreen.dart';
import 'package:noteapp/widgets/widgets.dart';

class Setgroupchat extends StatefulWidget {
  final List<Map<String, dynamic>> chatRoomMemberIds;
  const Setgroupchat({super.key, required this.chatRoomMemberIds});

  @override
  State<Setgroupchat> createState() => _SetgroupchatState();
}

class _SetgroupchatState extends State<Setgroupchat> {
  TextEditingController groupName = TextEditingController();
  TextEditingController groupDesc = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor(backgroundColor),
        appBar: AppBar(
          backgroundColor: HexColor(backgroundColor),
          title: Text(
            "Group Chat",
            style: TextStyle(fontFamily: "Inter",fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              children: [
                textField(groupName, "Group Name..."),
                SizedBox(
                  height: 20,
                ),
                textField(groupDesc, "Group Description"),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Members",
                  style: TextStyle(fontFamily: "Inter", fontSize: 20),
                ),
                SizedBox(
                  height: 30,
                ),
                if (widget.chatRoomMemberIds.isNotEmpty)
                  Container(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.chatRoomMemberIds.length,
                      itemBuilder: (context, index) {
                        final member = widget.chatRoomMemberIds[index];
                        return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      backgroundImage:
                                          member["picture"] != null &&
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
                                            widget.chatRoomMemberIds
                                                .remove(member);
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
                if (widget.chatRoomMemberIds.isEmpty)
                  Text(
                    "No member found!",
                    style: TextStyle(),
                  ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const Groupconvoscreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor(buttonBackground),
                      foregroundColor: HexColor(buttoncolor),
                      minimumSize: const Size(227, 63),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      "Create Group",
                      style: TextStyle(fontFamily: "Inter", fontSize: 20),
                    ))
              ],
            ),
          ),
        ));
  }
}
