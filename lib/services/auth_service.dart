import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:chat_app_flutter_firebase/screens/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> uploadProfileImage(XFile profileImage, Uint8List? webImage) async {
    const String cloudinaryUrl = "https://api.cloudinary.com/v1_1/dlfto8vov/image/upload";
    const String uploadPreset = "tripplanner_images";

    try {
      var request = http.MultipartRequest("POST", Uri.parse(cloudinaryUrl));
      request.fields["upload_preset"] = uploadPreset;

      if (kIsWeb && webImage != null) {
        String base64Image = base64Encode(webImage);
        request.fields["file"] = "data:image/png;base64,$base64Image";
      } else {
        request.files.add(await http.MultipartFile.fromPath("file", profileImage.path));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonData = json.decode(responseData);
        return jsonData["secure_url"];
      } else {
        print("Cloudinary Upload Failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<String?> signupUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String gender,
    required DateTime dob,
    XFile? profileImage,
    Uint8List? webImage,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? imageUrl;
      if (profileImage != null) {
        imageUrl = await uploadProfileImage(profileImage, webImage);
      }

      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'email': email,
        'phone': phone,
        'gender': gender,
        'dob': dob.toIso8601String(),
        'profileImage': imageUrl,
        'uid': userCredential.user!.uid,
        'createdAt': DateTime.now().toIso8601String(),
        'role': 'user',
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }
}

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> loginUser(String email, String password) async {
  try {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    return null; 
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') return "No user found for this email.";
    if (e.code == 'wrong-password') return "Incorrect password.";
    return e.message;
  } catch (e) {
    return "An unexpected error occurred.";
  }
}

}


class ForgotService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null; // Success
    } catch (e) {
      return e.toString(); // Return error message
    }
  }
}