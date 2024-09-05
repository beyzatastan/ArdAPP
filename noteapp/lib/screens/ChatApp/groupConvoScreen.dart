import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/ChatApp/chatScreen.dart';
import 'package:noteapp/utils/services/chats/groupChatServices.dart';
import 'package:noteapp/utils/services/chats/grupChatDisplayMessage.dart';
import 'package:noteapp/widgets/widgets.dart';

class Groupconvoscreen extends StatefulWidget {
  final String groupName;
  final String groupId;
  final String groupDesc;
  final List<String> members;
  const Groupconvoscreen({super.key,required this.groupName,required this.members,required this.groupId,required this.groupDesc});

  @override
  State<Groupconvoscreen> createState() => _GroupconvoscreenState();
}

class _GroupconvoscreenState extends State<Groupconvoscreen> {
  TextEditingController messageCont =TextEditingController();
  final Groupchatservices groupchatservices = Groupchatservices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
        leading: backButton(context, Chatscreen()),
        backgroundColor: HexColor(backgroundColor),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                widget.groupName,
                style: const TextStyle(
                    fontFamily: "Inter", fontSize: 25, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: GroupDisplayMessage(members:widget.members,groupId:widget.groupId,)
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add_circle,size: 26,color: HexColor(buttonBackground),),
                  onPressed: () {},
                ),
                Expanded(
                    child: TextFormField(
                  controller: messageCont,
                  onSaved: (newValue) {
                    messageCont.text = newValue!;
                  },
                  style: const TextStyle(
                    fontFamily: "Inter",
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Message...",
                    enabled: true,
                    contentPadding: const EdgeInsets.only(left: 15, bottom: 8),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: HexColor(buttonBackground),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                  ),
                  validator: (value) {
                    return null;
                  },
                )),
                TextButton(
                    onPressed: (){
                      groupchatservices.sendMessagetoGroup(widget.groupId, messageCont.text);
                      messageCont.clear();
                    },
                    child: Text(
                      "Send",
                      style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: HexColor(buttonBackground)),
                    ))
              ],
            ),
          )
        ],
      )),
    );
  }
}
