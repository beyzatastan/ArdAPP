import 'dart:io'; // Resim dosyasını işlemek için
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart'; // Resim seçme için
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Resim yükleme için
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/NoteApp/notesScreen.dart';
import 'package:noteapp/screens/login/loginScreen.dart';
import 'package:noteapp/utils/auth.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final userId = FirebaseAuth.instance.currentUser!.uid;
  String? errorMessage;
  File? _imageFile; 
  String? _profileImageUrl;
  final ImagePicker _picker = ImagePicker(); // ImagePicker nesnesi
@override
void initState() {
  super.initState();
  _loadUserData();
}

 Future<void> _loadUserData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await _firestore.collection('Users').doc(userId).get();
      final userData = userDoc.data();
      
      if (userData != null) {
        setState(() {
          nameCont.text = userData['name'] ?? '';
          emailCont.text = userData['email'] ?? '';
          _profileImageUrl = userData['picture'];
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

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
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
              fontFamily: "Inter", fontSize: 26, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
                    onPressed: () {
                      signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const Loginscreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text(
                      "Sign Out",
                      style: TextStyle(
                          color: Colors.red, fontFamily: "Inter", fontSize: 18),
                    ))
        ],
      ),
      backgroundColor: HexColor(backgroundColor),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: HexColor(noteColor),
                  ),
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: _profileImageUrl == null
                      ? IconButton(
                          onPressed: _pickImage,
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                            size: 40.0,
                          ),
                        )
                      : ClipOval(
                          child: Image.network(
                             _profileImageUrl ?? '',
                            fit: BoxFit.cover,
                            width: 130,
                            height: 130,
                            loadingBuilder: (context, child, progress) {
                if (progress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 40.0,
                );
              },
                          ),
                        ),
                  )
                ),
                SizedBox(height: 40,),
                TextField(
                  controller: nameCont,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Name",
                    hintStyle: TextStyle(color: HexColor(noteColor)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: HexColor(buttonBackground), width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor(noteColor)))),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailCont,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Email Address",
                    hintStyle: TextStyle(color: HexColor(noteColor)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: HexColor(buttonBackground), width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor(noteColor)))),
                ),
                const SizedBox(height: 16),
                
                ElevatedButton(
                    onPressed: () {
                      updateProfile();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor(buttonBackground),
                        foregroundColor: HexColor(buttoncolor),
                        minimumSize: const Size(327, 63),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: const Text(
                      "Save",
                      style: TextStyle(fontFamily: "Inter", fontSize: 20),
                    )),
                const SizedBox(
                  height: 20,
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> signOut() async {
    try {
      await Auth().signOut();
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

 Future<void> updateProfile() async {
  try {
    String? profilePictureUrl;

    if (_imageFile != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures')
          .child(userId + '.jpg');
      
      // Resmi yükle ve URL'yi al
      await storageRef.putFile(_imageFile!);
      profilePictureUrl = await storageRef.getDownloadURL();
    }

    // Profil verilerini Firestore'da güncelle
    final userUpdateData = {
      "name": nameCont.text,
      "email": emailCont.text,
    };

    if (profilePictureUrl != null) {
      userUpdateData["picture"] = profilePictureUrl;
    }

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userId)
        .update(userUpdateData);

    // Şifreyi ve e-posta adresini güncelle
    if (passwordCont.text.isNotEmpty) {
      await FirebaseAuth.instance.currentUser!.updatePassword(passwordCont.text);
    }

    if (emailCont.text.isNotEmpty && emailCont.text != FirebaseAuth.instance.currentUser!.email) {
      await FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(emailCont.text);
    }

    // Kullanıcıyı yönlendirme
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Notesscreen()),
      (Route<dynamic> route) => false,
    );
  } catch (e) {
    print("Error updating profile: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Failed to update profile. Please try again."),
      ),
    );
  }
}
}
