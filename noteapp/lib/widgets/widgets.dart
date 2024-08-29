import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';

Widget backButton(BuildContext context, Widget screen) {
  return IconButton(
    icon: const Icon(Icons.arrow_back_ios),
    onPressed: () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen),
        (Route<dynamic> route) => false,
      );
    },
  );
}
Widget optionsButton({
  required String name,
  required IconData icon,
  required BuildContext context,
  required Widget screen,
}) {
  return ElevatedButton(
    onPressed: () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen),
        (Route<dynamic> route) => false,
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: HexColor(buttonBackground),
      foregroundColor: HexColor(buttoncolor),
      minimumSize: const Size(200, 170),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 60,
        ),
        const SizedBox(height: 20), // Space between icon and text
        Text(
          name,
          style: const TextStyle(fontFamily: "Inter", fontSize: 30),
        ),
      ],
    ),
  );
}
Widget textField(TextEditingController controller,
   String hintText,){
  return TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: hintText,
                      hintStyle: TextStyle(color: HexColor(noteColor)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor(noteColor), width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor(buttonBackground)))));
               
}

Widget textFieldFull(TextEditingController controller){
  return TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: TextStyle(color: HexColor(noteColor)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor(noteColor), width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor(buttonBackground)))));
               
}Widget searchField(Function(String) func,String hinttext) {
  return TextField(
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      hintText: hinttext,
      contentPadding: const EdgeInsets.only(left: 15, bottom: 8),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: HexColor(noteColor),
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.5),
          width: 1,
        ),
      ),
    ),
    onChanged: (value) {
      func(value); 
    },
  );
}