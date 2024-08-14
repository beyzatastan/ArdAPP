import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/NoteApp/forgotPassword.dart';
import 'package:noteapp/screens/login/optionScreen.dart';
import 'package:noteapp/screens/login/registerScreen.dart';
import 'package:noteapp/services/auth.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController emailCont = TextEditingController();
  final TextEditingController passwordCont = TextEditingController();

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Form(
              key: _formKey, 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Login or sign up to continue using our app.",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 15,
                      color: HexColor(noteColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailCont,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Email Address",
                            hintStyle: TextStyle(color: HexColor(noteColor)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: HexColor(buttonBackground),
                                    width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: HexColor(noteColor))),
                            errorText: errorMessage != null ? 'Invalid email or password' : null,
                          ),
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
                                    color: HexColor(buttonBackground),
                                    width: 1)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: HexColor(noteColor))),
                            errorText: errorMessage != null ? 'Invalid email or password' : null,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot be empty';
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Forgotpasswordscreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                              ),
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(fontFamily: "Inter", fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        signIn();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: HexColor(buttonBackground),
                      foregroundColor: HexColor(buttoncolor),
                      minimumSize: const Size(327, 63),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontFamily: "Inter", fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 500,
                    child: Align(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(fontFamily: "Inter", fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const Registerscreen(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 17,
                                color: HexColor(buttonBackground),
                              ),
                            ),
                          ),
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> signIn() async {
    try {
      await Auth().signIn(email: emailCont.text, password: passwordCont.text);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Optionscreen()),
        (Route<dynamic> route) => false,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          errorMessage = 'Invalid email or password';
        } else {
          errorMessage = e.message;
        }
      });
    }
  }
}
/*
catch(e){
ShowDialog(
context: context
builder: (context) => AlertDialog (
title:Text(""))
)}
*/