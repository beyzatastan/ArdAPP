import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/ChatApp/convosScreen.dart';

class Searchscreen extends StatefulWidget {
  final Stream<List<Map<String, dynamic>>> usersStream;
  const Searchscreen({super.key, required this.usersStream});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  TextEditingController searchController = TextEditingController();
   List<Map<String, dynamic>> filteredConvos = [];
  List<Map<String, dynamic>> allConvos = [];


  @override
  void initState() {
    super.initState();
    widget.usersStream.listen((convos) {
      setState(() {
        allConvos = convos;
        filteredConvos = convos;
      });
    });
  }

  void filterSearch(String query) {
    setState(() {
      filteredConvos = allConvos
          .where((item) => item["name"]!
              .toLowerCase()
              .toUpperCase()
              .contains(query.toLowerCase().toUpperCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50, 8, 18, 10),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Search for Users...",
                    hintStyle: const TextStyle(fontFamily: "Inter"),
                    fillColor: HexColor(search),
                    filled: true,
                    contentPadding: const EdgeInsets.fromLTRB(15, 20, 14, 2),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(
                            color: HexColor(backgroundColor), width: 1)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: HexColor(noteColor)))),
                onChanged: (value) {
                  filterSearch(value);
                },
              ),
            ),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: filteredConvos.length,
                  itemBuilder: (context, index) {
                    final item = filteredConvos[index];
                    return Slidable(
                      key: Key(item["name"] ?? ""),
                      endActionPane:
                          ActionPane(motion: const DrawerMotion(), children: [
                        SlidableAction(
                          onPressed: (context) {},
                          backgroundColor: Colors.red,
                          icon: Icons.delete_outline,
                        )
                      ]),
                      child: ListTile(
                        title: Text(item["name"] ?? "",
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "Inter",
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        contentPadding: const EdgeInsets.all(14),
                        tileColor: HexColor(backgroundColor),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => Convosscreen(
                                      name: item["name"] ?? "",
                                
                                    )),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
