import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth firebaseauth = FirebaseAuth.instance;

class AuthService {
  registerUserWithEmailAndPassword(
      String firstname,
      String lastname,
      String phone,
      String email,
      String designation,
      String department,
      String password,
      String confirmpassword) async {
    try {
      await firebaseauth
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(
              () => firebaseauth.currentUser?.updateDisplayName(firstname));

      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return e;
    }
  }

  Future<bool> storeDataInFirestore(
      String firstname,
      String lastname,
      String phone,
      String email,
      String designation,
      String department,
      String password,
      String confirmpassword,
      String id) async {
    FirebaseFirestore.instance
        .collection("User")
        .doc('$firstname $lastname')
        .set({
      "FirstName": firstname,
      "LastName": lastname,
      "Phone Number": phone,
      "Email": email,
      "Designation": designation,
      "Department": department,
      "Password": password,
      "ConfirmPassword": confirmpassword,
      'Employee Id': id
    });

    FirebaseFirestore.instance
        .collection('TotalUsers')
        .doc("$firstname $lastname")
        .set({
      'alphabet': firstname[0].trim().toUpperCase(),
      'position': 'unAssigned'
    });

    return true;
  }

  Future<String> getCurrentUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String data = sharedPreferences.getString('employeeId').toString();
    return data;
  }
}
