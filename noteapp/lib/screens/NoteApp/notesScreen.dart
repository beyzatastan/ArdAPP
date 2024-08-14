import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/NoteApp/addScreen.dart';
import 'package:noteapp/screens/NoteApp/detailsScreen.dart';
import 'package:noteapp/screens/NoteApp/editScreen.dart';
import 'package:noteapp/screens/NoteApp/profileScreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:noteapp/screens/login/optionScreen.dart';

class Notesscreen extends StatefulWidget {
  const Notesscreen({super.key});

  @override
  State<Notesscreen> createState() => _NotesscreenState();
}

class _NotesscreenState extends State<Notesscreen> {
  final List<Map<String, String>> items = [
    {
      "title": "Lemon Cake & Blueberry",
      "description":
          "Sunshine-sweet lemon blueberry layer cake dotted with juicy berries and topped with lush cream cheese…"
    },
    {"title": "Item 2", "description": "Description for Item 2"},
    {"title": "Item 3", "description": "Description for Item 3"},
    {"title": "Item 4", "description": "Description for Item 4"},
  ];

  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = items;
  }

  void filterSearch(String query) {
    setState(() {
      filteredItems = items
          .where((item) => item["title"]!
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
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Optionscreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        actions: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(60, 10, 2, 5),
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Search...",
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 2),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: HexColor(buttonBackground), width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor(noteColor)))),
                onChanged: (value) {
                  filterSearch(value);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: IconButton(
              icon: const Icon(Icons.person_3),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Profilescreen()));
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 9),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return Slidable(
                    key: Key(item["title"] ?? ""),
                    endActionPane:
                        ActionPane(motion: const DrawerMotion(), children: [
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => Editscreen(
                                      notetitle: item["title"] ?? "",
                                      notedesc: item["description"] ?? "",
                                    )),
                          );
                        },
                        backgroundColor: HexColor(editcolor),
                        foregroundColor: Colors.white,
                        icon: Icons.mode_edit_outline_outlined,
                      ),
                      SlidableAction(
                        onPressed: (context) {},
                        backgroundColor: Colors.red,
                        icon: Icons.delete_outline,
                      )
                    ]),
                    child: ListTile(
                      title: Text(item["title"] ?? "",
                          style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "Inter",
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      subtitle: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            item["description"] ?? "",
                            style: TextStyle(
                                fontFamily: "Inter",
                                color: HexColor(noteColor)),
                          )),
                      contentPadding: const EdgeInsets.all(14),
                      tileColor: HexColor(backgroundColor),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => Detailsscreen(
                                    tittle: item["title"] ?? "",
                                    description: item["description"] ?? "",
                                  )),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const Addscreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor(buttoncolor),
                      foregroundColor: HexColor(buttonBackground),
                      minimumSize: const Size(80, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  child: const Text(
                    "+ Add Note",
                    style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
