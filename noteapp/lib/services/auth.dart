import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final   FirebaseAuth  _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

User? get currentUser => _firebaseAuth.currentUser;

Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

Future<void> registerWithEmailAndPassword(
String email,
 String password,
 String name) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
        CollectionReference users =  _firebaseFirestore.collection('Users');
      User? user = result.user;


      await users.doc(user!.uid).set({
        'email': email,
        'id': user.uid,
        "name": name,
      });
      
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
  }
 }
  //login
  Future<UserCredential> signIn({
    required String email,
    required String password,
  })  async {
            try{
   UserCredential userCredential =  await _firebaseAuth
   .signInWithEmailAndPassword(email: email, password: password);
   return userCredential;
      } on FirebaseAuthException  catch (e){
        throw Exception (e.code);
      }
   
  }

  //sign out
  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  //Note
Future<void> createNoteCollection(
String email,
 String name,
 String note,
 String description) async {
    try {
        CollectionReference notes =  _firebaseFirestore.collection('Notes');
        User? user = currentUser;
      await notes.doc(user!.uid).set({
        'email': email,
        'id': user.uid,
        "name": name,
        "note":note,
        "description":description
      });
      
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
  }
 }
}