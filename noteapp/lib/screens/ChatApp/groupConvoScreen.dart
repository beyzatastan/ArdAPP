import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/ChatApp/chatScreen.dart';
import 'package:noteapp/widgets/widgets.dart';

class Groupconvoscreen extends StatefulWidget {
  const Groupconvoscreen({super.key});

  @override
  State<Groupconvoscreen> createState() => _GroupconvoscreenState();
}

class _GroupconvoscreenState extends State<Groupconvoscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
        leading: backButton(context, Chatscreen()),
        backgroundColor: HexColor(backgroundColor),
      ),
    );
  }
}
