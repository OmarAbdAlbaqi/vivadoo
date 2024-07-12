import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivadoo/providers/auth/sign_in_provider.dart';
import 'package:http/http.dart' as http;


class MyGoogleAuthProvider with ChangeNotifier{
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithGoogle(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if(googleSignInAccount != null){
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        UserCredential userCredential =  await _firebaseAuth.signInWithCredential(credential);
        String? accessToken = userCredential.credential?.accessToken;
        if(accessToken != null){
        }
      }
    } catch (e) {
      print("Error $e");
    }
  }
}