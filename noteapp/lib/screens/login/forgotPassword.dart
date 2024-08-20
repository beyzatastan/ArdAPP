import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';

class Forgotpasswordscreen extends StatefulWidget {
  const Forgotpasswordscreen({super.key});

  @override
  State<Forgotpasswordscreen> createState() => _ForgotpasswordscreenState();
}

class _ForgotpasswordscreenState extends State<Forgotpasswordscreen> {
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
      ),),
      backgroundColor: HexColor(backgroundColor),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Forgot Password",
                  style: TextStyle(fontFamily: "Inter", 
                  fontSize: 27,fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10,),
                Column(
                  children: [
                      Text("Confirm your email and we’ll send",style: TextStyle(
                  fontFamily: "Inter",fontSize: 15,color: HexColor(noteColor)
                ),),
                Text("the instructions.",style: TextStyle(
                  fontFamily: "Inter",fontSize: 15,color: HexColor(noteColor)
                ),),
                  ],
                ),
                 const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                  child: Container(
                    child: TextField(decoration: InputDecoration(
                       fillColor: Colors.white,
                       filled: true,
                       hintText: "Email Adress",
                       hintStyle: TextStyle(color: HexColor(noteColor)),
                       enabledBorder: OutlineInputBorder(
                       borderSide: BorderSide(
                       color: HexColor(buttonBackground),
                       width: 1)),
                       focusedBorder: OutlineInputBorder(
                       borderSide:
                     BorderSide(color: HexColor(noteColor)))
                    ),
                    ),
                  ),
                ),
                ElevatedButton(onPressed: (){
                },
                 style: ElevatedButton.styleFrom(
                 backgroundColor: HexColor(buttonBackground),
                 foregroundColor: HexColor(buttoncolor),
                 minimumSize: const Size(327, 63),
                 shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5))),
                child: const Text("Reset Password",
                style: 
                TextStyle(fontFamily: "Inter",fontSize: 16),))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
