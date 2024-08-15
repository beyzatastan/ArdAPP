import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  late final Stream<QuerySnapshot> _notesStream;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notesStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserId)
        .collection('Notes')
        .snapshots();
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
                controller: searchController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Search for notes...",
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
                  setState(() {});
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
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 9),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _notesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No notes available."));
                  }

                  // Filter notes based on search query
                  final filteredItems = snapshot.data!.docs.where((doc) {
                    final noteTitle = doc['noteTitle']?.toString() ?? '';
                    return noteTitle
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final itemId = item.id;
                      return Slidable(
                        key: Key(item["noteTitle"] ?? ""),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Editscreen(
                                      notetitle: item["noteTitle"] ?? "",
                                      notedesc: item["noteDescription"] ?? "",
                                    ),
                                  ),
                                );
                              },
                              backgroundColor: HexColor(editcolor),
                              foregroundColor: Colors.white,
                              icon: Icons.mode_edit_outline_outlined,
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                deleteNote(itemId);
                              },
                              backgroundColor: Colors.red,
                              icon: Icons.delete_outline,
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            item["noteTitle"] ?? "",
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: "Inter",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              item["noteDescription"] ?? "",
                              style: TextStyle(
                                fontFamily: "Inter",
                                color: HexColor(noteColor),
                              ),
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(14),
                          tileColor: HexColor(backgroundColor),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Detailsscreen(
                                  tittle: item["noteTitle"] ?? "",
                                  description: item["noteDescription"] ?? "",
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
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
                      builder: (context) => const Addscreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor(buttoncolor),
                  foregroundColor: HexColor(buttonBackground),
                  minimumSize: const Size(80, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "+ Add Note",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future deleteNote(String noteId) async {
    await FirebaseFirestore.instance.collection("Users").doc(currentUserId)
    .collection("Notes").doc(noteId).delete();
  }
}
