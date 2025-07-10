import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/login/loginScreen.dart';
import 'package:noteapp/screens/login/verifyScreen.dart';
import 'package:noteapp/utils/auth.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  final TextEditingController nameCont = TextEditingController();
  final TextEditingController emailCont = TextEditingController();
  final TextEditingController passwordCont = TextEditingController();
  final TextEditingController rePasswordCont = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? errorMessage;
  File? _imageFile; 
  final ImagePicker _picker = ImagePicker(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Form(
              key: _formKey, // Form key kullanımı
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Register",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Register or sign in to continue using our app.",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 15,
                      color: HexColor(noteColor),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HexColor(noteColor),
                    ),
                    child: _imageFile == null
                        ? IconButton(
                            onPressed: _pickImage,
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 40.0,
                            ),
                          )
                        : ClipOval(
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                              width: 130,
                              height: 130,
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameCont,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Name",
                              hintStyle: TextStyle(color: HexColor(noteColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: HexColor(noteColor), width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: HexColor(buttonBackground)))),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: emailCont,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Email Address",
                              hintStyle: TextStyle(color: HexColor(noteColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: HexColor(noteColor), width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: HexColor(buttonBackground)))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email cannot be empty';
                            } else if (!value.contains('@')) {
                              return 'Email must contain @';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordCont,
                          obscureText: true,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Password",
                              hintStyle: TextStyle(color: HexColor(noteColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: HexColor(noteColor), width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: HexColor(buttonBackground)))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot be empty';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: rePasswordCont,
                          obscureText: true,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Re-Password",
                              hintStyle: TextStyle(color: HexColor(noteColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: HexColor(noteColor), width: 1)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: HexColor(buttonBackground)))),
                          validator: (value) {
                            if (value != passwordCont.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await createUser();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) =>
                                  Verifyscreen(email: emailCont.text),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: HexColor(buttonBackground),
                          foregroundColor: HexColor(buttoncolor),
                          minimumSize: const Size(327, 63),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      child: const Text(
                        "Register",
                        style: TextStyle(fontFamily: "Inter", fontSize: 20),
                      )),
                  SizedBox(
                    height: 100,
                    child: Align(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(fontFamily: "Inter", fontSize: 16),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Loginscreen()),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontFamily: "Inter",
                                    fontSize: 16,
                                    color: HexColor(buttonBackground)),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createUser() async {
    try {
      final UserCredential userCredential =
          await Auth().signUpWitEmailandPassword(
        emailCont.text,
        passwordCont.text,
        nameCont.text,
      );

      final String userId = userCredential.user!.uid;
      await userCredential.user!.sendEmailVerification();

      String? profilePictureUrl;
      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child(userId + '.jpg');

        await storageRef.putFile(_imageFile!);
        profilePictureUrl = await storageRef.getDownloadURL();
      }

      // Kullanıcı bilgilerini Firestore'a kaydet
      await FirebaseFirestore.instance.collection('Users').doc(userId).set({
        'email': emailCont.text,
        "id": userId,
        'name': nameCont.text,
        "picture": profilePictureUrl
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage =
              'An account already exists for that email. Please use a different email or try logging in.';
          break;
        case 'weak-password':
          errorMessage =
              'The password provided is too weak. Please choose a stronger password.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is badly formatted.';
          break;
        default:
          errorMessage = 'An unexpected error occurred. Please try again.';
      }
      print('FirebaseAuthException: $errorMessage');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      print('Unexpected error: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('An unexpected error occurred. Please try again.')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
}
