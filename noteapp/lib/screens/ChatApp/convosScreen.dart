import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/utils/services/chats/chat_services.dart';
import 'package:noteapp/utils/services/chats/display_message.dart';

class Convosscreen extends StatefulWidget {
  const Convosscreen({super.key, required this.receiverName,required this.receiverId});
  final String receiverName;
  final String receiverId;

  @override
  State<Convosscreen> createState() => _ConvosscreenState();
}

class _ConvosscreenState extends State<Convosscreen> {
  final TextEditingController messageCont = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                widget.receiverName,
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
            child: DisplayMessage(receivername: widget.receiverName,receiverId: widget.receiverId),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
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
                    onPressed: sendMessage,
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

  void sendMessage()async{
    if(messageCont.text.isNotEmpty){
      await _chatServices.sendMessage(widget.receiverId,messageCont.text);
      messageCont.clear();
    }

  }
}