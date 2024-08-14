import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/services/auth.dart';
import 'package:noteapp/services/chats/chat_services.dart';
class Convosscreen extends StatefulWidget {
  const Convosscreen({super.key, required this.name});
  final String name;


  @override
  State<Convosscreen> createState() => _ConvosscreenState();
}

class _ConvosscreenState extends State<Convosscreen> {
  final TextEditingController messageCont = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final Auth _auth = Auth();

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
                widget.name,
                style: const TextStyle(fontFamily: "Inter", fontSize: 24),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: messageCont,
            onSaved: (newValue) {
              messageCont.text= newValue!;
            },
          ),
          IconButton(onPressed: (){
            if(messageCont.text.isNotEmpty){
              FirebaseFirestore.instance.collection("Messages").doc().set({
                "message": messageCont.text.trim(),
                "time":DateTime.now(),
                "name":widget.name
              });
              messageCont.clear();
            }
          }, icon: Icon(Icons.abc_outlined))
        ],
      ),
    );
  }

  

  
    
}
