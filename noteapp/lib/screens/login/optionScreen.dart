import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/ChatApp/chatScreen.dart';
import 'package:noteapp/screens/NoteApp/notesScreen.dart';

class Optionscreen extends StatefulWidget {
  const Optionscreen({super.key});

  @override
  State<Optionscreen> createState() => _OptionscreenState();
}

class _OptionscreenState extends State<Optionscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 180, horizontal: 40),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const Chatscreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor(buttonBackground),
                      foregroundColor: HexColor(buttoncolor),
                      minimumSize: const Size(227, 200),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat,
                        size: 60,
                      ),
                      const SizedBox(height: 20), // Space between icon and text
                      Text(
                        "Chat",
                        style: TextStyle(fontFamily: "Inter", fontSize: 30),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 69,
                ),
                ElevatedButton(
                  onPressed: () {
                   
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const Notesscreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor(buttonBackground),
                      foregroundColor: HexColor(buttoncolor),
                      minimumSize: const Size(227, 200),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child:  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit_note_sharp, 
                        size: 65, 
                      ),
                       SizedBox(height: 20), 
                      Text(
                        "Note",
                        style: TextStyle(fontFamily: "Inter", fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
