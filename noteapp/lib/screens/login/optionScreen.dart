import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/ChatApp/chatScreen.dart';
import 'package:noteapp/screens/NoteApp/notesScreen.dart';
import 'package:noteapp/screens/NoteApp/profileScreen.dart';
import 'package:noteapp/screens/login/loginScreen.dart';
import 'package:noteapp/screens/News/newsScreen.dart';

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
            padding: EdgeInsets.symmetric(vertical: 100, horizontal: 40),
            child: Column(
              children: [
                 ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const Newsscreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor(buttonBackground),
                      foregroundColor: HexColor(buttoncolor),
                      minimumSize: const Size(200, 170),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.newspaper,
                        size: 60,
                      ),
                      const SizedBox(height: 20), // Space between icon and text
                      Text(
                        "News",
                        style: TextStyle(fontFamily: "Inter", fontSize: 30),
                      ),
                    ],
                  ),
                ),SizedBox(height: 40,),
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
                      minimumSize: const Size(200, 170),
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
                  height: 40,
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
                      minimumSize: const Size(200, 170),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.edit_note_sharp,
                        size: 65,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Note",
                        style: TextStyle(fontFamily: "Inter", fontSize: 30),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder:(context) => Profilescreen()));
                        },
                        child:  Text(
                          "Edit Profile",
                          style: TextStyle(
                              color: HexColor(buttonBackground),
                              fontFamily: "Inter",
                              fontSize: 23),
                        )),
                         SizedBox(height: 5,),
                    TextButton(
                        onPressed: () {signOut();},
                        child: const Text(
                          "Sign Out",
                          style: TextStyle(
                              color: Colors.red,
                              fontFamily: "Inter",
                              fontSize: 18),
                        )),
                       
                        
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signOut() async {
    try {
      FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context) => Loginscreen(),)
      ,   (Route<dynamic> route) => false,);
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
