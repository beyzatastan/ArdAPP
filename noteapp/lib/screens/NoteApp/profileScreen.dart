import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/NoteApp/notesScreen.dart';
import 'package:noteapp/screens/login/loginScreen.dart';
import 'package:noteapp/services/auth.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
              fontFamily: "Inter", fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: HexColor(backgroundColor),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
             padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Name",
                      hintStyle: TextStyle(color: HexColor(noteColor)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor(buttonBackground), width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor(noteColor)))),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Email Adress",
                      hintStyle: TextStyle(color: HexColor(noteColor)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor(buttonBackground), width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor(noteColor)))),
                ),
                const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          //yığını da temizleyip gönderiyorum
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const Notesscreen()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: HexColor(buttonBackground),
                            foregroundColor: HexColor(buttoncolor),
                            minimumSize: const Size(327, 63),
                            shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(5))),
                        child: const Text(
                          "Save",
                          style: TextStyle(fontFamily: "Inter", fontSize: 20),
                        )
                        ),
                        const SizedBox(height: 20,),
                        TextButton(onPressed: (){
                          signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const Loginscreen()),
                            (Route<dynamic> route) => false,
                          );

                        }, child: const Text("Sign Out",
                        style: TextStyle(color: Colors.red,fontFamily: "Inter",fontSize: 15),)) 

              ],
            ),
          ),
        ),
      ),
    );
  }
  Future <void> signOut()async{
   try{
    await Auth().signOut();
   }on FirebaseAuthException catch(e){
    setState(() {
  errorMessage=e.message;    
    });
   }
  }
}
