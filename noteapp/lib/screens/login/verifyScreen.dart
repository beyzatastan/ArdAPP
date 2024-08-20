import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
class Verifyscreen extends StatefulWidget {
  final dynamic email;

  const Verifyscreen({super.key,required this.email});

  @override
  State<Verifyscreen> createState() => _VerifyscreenState();
}

class _VerifyscreenState extends State<Verifyscreen> {
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
                  "Verify your Email",
                  style: TextStyle(fontFamily: "Inter", 
                  fontSize: 27,fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50,),
                Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Text("Please verify your email. A verification email has been ",style: TextStyle(
                  fontFamily: "Inter",fontSize: 15,color: HexColor(noteColor)
                ),),
                  Text("sent to ${widget.email}",style: TextStyle(
                  fontFamily: "Inter",fontSize: 15,color: HexColor(noteColor)
                ),)
                
                  ],
                ),
                 const SizedBox(height: 60,),
                ElevatedButton(onPressed: (){
                },
                 style: ElevatedButton.styleFrom(
                 backgroundColor: HexColor(buttonBackground),
                 foregroundColor: HexColor(buttoncolor),
                 minimumSize: const Size(327, 63),
                 shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5))),
                child: const Text("OK",
                style: 
                TextStyle(fontFamily: "Inter",fontSize: 16),))
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget verificationMessage(String email) {
  return Text(
    "Please verify your email. A verification email has been sent to $email",
    style: TextStyle(
      fontFamily: "Inter",
      fontSize: 15,
      color: HexColor(noteColor),
    ),
  );
}

}
