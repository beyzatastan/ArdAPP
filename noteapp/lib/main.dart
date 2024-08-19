import 'package:flutter/material.dart';
import 'package:noteapp/firebase_options.dart';
import 'package:noteapp/screens/login/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noteapp/screens/login/optionScreen.dart';
import 'package:noteapp/utils/services/news/api_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _isSignedIn;

  @override
  void initState() {
    super.initState();
    _isSignedIn = checkSignInStatus();
  }

  Future<bool> checkSignInStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null; 
  }

  

  @override
  Widget build(BuildContext context) {
    ApiServices apiServices = ApiServices();
    apiServices.getNews();
    return FutureBuilder<bool>(
      future: _isSignedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            debugShowCheckedModeBanner: false,
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          return const MaterialApp(
            home:Optionscreen(), 
            debugShowCheckedModeBanner: false,
          );
        } else {
          return const MaterialApp(
            home: Loginscreen(), 
            debugShowCheckedModeBanner: false,
          );
        }
      },
    );
  }
}
