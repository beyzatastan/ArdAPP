import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
class Detailsscreen extends StatefulWidget {
  const Detailsscreen({super.key, required this.tittle, required this.description});
  final String tittle;
  final String description;
  
  @override
  State<Detailsscreen> createState() => _DetailsscreenState();
}

class _DetailsscreenState extends State<Detailsscreen> {
  

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 40),
              child: Column(
                children: [
                   Text(widget.tittle,style: const TextStyle(fontFamily: "Inter",fontSize: 22,color: Colors.black),),
                  const SizedBox(height: 40,)
                  ,Text(widget.description,style: TextStyle(fontFamily: "Inter",fontSize: 16,color: HexColor(noteColor)),)
                ],
              ),
            ),
          ),
        ),
    );
  }
}