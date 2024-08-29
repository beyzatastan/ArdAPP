import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/NoteApp/addScreen.dart';
import 'package:noteapp/screens/NoteApp/detailsScreen.dart';
import 'package:noteapp/screens/NoteApp/editScreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:noteapp/screens/NoteApp/noteChatScreen.dart';
import 'package:noteapp/screens/login/optionScreen.dart';
import 'package:noteapp/utils/auth.dart';
import 'package:noteapp/utils/services/chats/chat_services.dart';
import 'package:noteapp/widgets/widgets.dart';

class Notesscreen extends StatefulWidget {
  const Notesscreen({super.key});

  @override
  State<Notesscreen> createState() => _NotesscreenState();
}

class _NotesscreenState extends State<Notesscreen> {
  late final Stream<QuerySnapshot> _notesStream;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notesStream = FirebaseFirestore.instance
        .collection('Notes')
        .doc(currentUserId)
        .collection("Notes")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        leading: backButton(context, Optionscreen()),
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
          const Padding(
            padding: EdgeInsets.only(right: 14, left: 10),
          )
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
                        startActionPane:
                            ActionPane(motion: const DrawerMotion(), children: [
                          SlidableAction(
                            onPressed: (context) {
                              _displayBottomSheet(context, item);
                            },
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.share_sharp,
                          ),
                        ]),
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
                                      noteId: item.id,
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
                              maxLines: 2, // Gösterilecek maksimum satır sayısı
                               overflow: TextOverflow.ellipsis, selectionColor: HexColor(noteColor),
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

  Future<void> signOut() async {
    try {
      await Auth().signOut();
    } on FirebaseAuthException catch (e) {
      throw e.code;
    }
  }

  Future deleteNote(String noteId) async {
    await FirebaseFirestore.instance
        .collection("Notes")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Notes")
        .doc(noteId)
        .delete();
  }

  Future<void> _displayBottomSheet(BuildContext context, dynamic item) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: HexColor(backgroundColor),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                "Share your note with:",
                style: TextStyle(
                  fontFamily: "Inter",
                  color: HexColor(noteColor),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              // Kullanıcıların Profil Resimleri ve İsimleri
              Container(
                height: 90,
                child: StreamBuilder(
                  stream: ChatServices().getUsersStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No users available."));
                    }

                    final users = snapshot.data!;

                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: users.map<Widget>((user) {
                        if (user["email"] != getCurrentUser()!.email) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Notechatscreen(
                                        receiverName: user["name"],
                                        receiverId: user["id"],
                                        noteTitle: item["noteTitle"],
                                        noteDesc: item["noteDescription"],
                                      )));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.black,
                                    backgroundImage: user["picture"] != null &&
                                            user["picture"].isNotEmpty
                                        ? NetworkImage(user["picture"])
                                        : const AssetImage(
                                                'assets/images/1024.png')
                                            as ImageProvider, // Casting for compatibility
                                    radius: 30,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    user["name"],
                                    style: const TextStyle(
                                      fontFamily: "Inter",
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
