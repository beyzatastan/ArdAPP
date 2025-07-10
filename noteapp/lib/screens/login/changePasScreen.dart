/*
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/login/optionScreen.dart';
class Changepasscreen extends StatefulWidget {
  const Changepasscreen({super.key});

  @override
  State<Changepasscreen> createState() => _ChangepasscreenState();
}

class _ChangepasscreenState extends State<Changepasscreen> {
  TextEditingController passwordCont = TextEditingController();
  TextEditingController newpasswordCont1 = TextEditingController();
  TextEditingController newpasswordCont2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   backgroundColor: HexColor(backgroundColor),
   appBar: AppBar(
    backgroundColor: HexColor(backgroundColor),
    leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), 
          onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder:(context) => Optionscreen()));  },
      )
   ),
  body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding( padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                child: Column(
                  children: [
                    TextField(
controller: passwordCont,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Old Password...",
                    hintStyle: TextStyle(color: HexColor(noteColor)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: HexColor(noteColor), width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor(buttonBackground)))),
                
                    ),const SizedBox(
                  height: 15,
                ),TextField(
                  controller: newpasswordCont1,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "New Password...",
                    hintStyle: TextStyle(color: HexColor(noteColor)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: HexColor(noteColor), width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor(buttonBackground)))),
                ),
                const SizedBox(
                  height: 15,
                ),
                 TextField(
                  controller: newpasswordCont2,
                  decoration: InputDecoration(
                       fillColor: Colors.white,
                       filled: true,
                       hintText: "New Password Again...",
                       hintStyle: TextStyle(color: HexColor(noteColor)),
                       enabledBorder: OutlineInputBorder(
                       borderSide: BorderSide(
                       color: HexColor(noteColor),
                       width: 1)),
                       focusedBorder: OutlineInputBorder(
                       borderSide:
                     BorderSide(color: HexColor(buttonBackground)))
                    ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(onPressed: (){},
                 style: ElevatedButton.styleFrom(
                 backgroundColor: HexColor(buttonBackground),
                 foregroundColor: HexColor(buttoncolor),
                 minimumSize: const Size(327, 63),
                 shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5))),
                child: const Text("Reset Password",
                style: 
                TextStyle(fontFamily: "Inter",fontSize: 16),))
                    
              ]
              
              ),

                )
                    ],
   ),
    ))));
  }
}
*/