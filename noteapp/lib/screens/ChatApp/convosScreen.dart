import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/models/display_message.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 // final Auth _auth = Auth();

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
      body: SingleChildScrollView(
        child:Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: DisplayMessage(name:widget.name),
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              children: [Expanded(child: TextFormField(
                controller: messageCont,
                onSaved: (newValue) {
                  messageCont.text=newValue!;
                },
                decoration: const InputDecoration(
                  filled: true,
                  hintText: "Message",
                  enabled: true,
                  contentPadding: EdgeInsets.only(left: 15,bottom: 8)
                ),
                validator: (value) {
                  return null;
                },
              )),
              IconButton(onPressed: (){
                if(messageCont.text.isNotEmpty){
                  _firestore.collection("Message").doc().set({
                    "message":messageCont.text.trim(),
                    "time":DateTime.now(),
                    "name":widget.name,

                  });
                  messageCont.clear();
                }
              }, icon: Icon(Icons.airplanemode_inactive_outlined))
              ],
            ),)
          ],
        ) 
      ),
    );
  }

  

  
    
}
