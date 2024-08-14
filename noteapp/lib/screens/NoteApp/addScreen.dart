import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/NoteApp/notesScreen.dart';
class Addscreen extends StatefulWidget {
  const Addscreen({super.key});

  @override
  State<Addscreen> createState() => _AddscreenState();
}

class _AddscreenState extends State<Addscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: HexColor(backgroundColor),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios)),
        
      ),
      backgroundColor: HexColor(backgroundColor),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.centerLeft,
          child:Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Column(
              children: [
                 TextField(decoration: InputDecoration(
                         fillColor: Colors.white,
                         filled: true,
                         hintText: "Note Title",
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
                      const SizedBox(height: 40,),
                       TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                         fillColor: Colors.white,
                         filled: true,
                         hintText: "Note Description",
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
                      const SizedBox(height: 60,),
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
                          "Save Note",
                          style: TextStyle(fontFamily: "Inter", fontSize: 20),
                        )
                        ),
              ],
            ),
          ) ,
        ),
      ),
    );
  }
}