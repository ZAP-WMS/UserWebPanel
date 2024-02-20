import 'package:assingment/Authentication/login_register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../widget/custom_appbar.dart';
import '../widget/custom_textformfield.dart';
import '../widget/style.dart';

class UpdatePassword extends StatefulWidget {
  String docName;
  UpdatePassword({
    Key? key,
    required this.docName,
  }) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  // final TextEditingController _currentPasswordController =
  //     TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
            isprogress: true,
            showDepoBar: false,
            toPlanning: true,
            cityname: '',
            text: 'Update Password',
            haveSynced: true,
          )),
      // AppBar(
      //   title: Text('Update Password'),
      // ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 2,
          height: 500,
          child: Card(
            elevation: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: blue)
                // Set the border radius
                ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Center(
                child: Form(
                  key: _formkey,
                  child: Container(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextField(
                            controller: _newPasswordController,
                            labeltext: 'New Password',
                            isSuffixIcon: true,  
                            validatortext: (value) {
                              return validatePassword(value!);
                            },
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next),
                        const SizedBox(height: 30.0),
                        CustomTextField(
                            controller: _confirmNewPasswordController,
                            labeltext: 'Confirm New Password',
                            isSuffixIcon: true,
                            validatortext: (value) {
                              return validatePassword(value!);
                            },
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next),
                        const SizedBox(height: 32.0),
                        SizedBox(
                          height: 50,
                          width: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Border radius
                              ),
                              backgroundColor: blue,
                            ),
                            onPressed: () {
                              // Add your password update logic here
                              // Validate input, check if new password and confirm new password match, etc.
                              // Then, trigger the password update action
                              updatePassword();
                            },
                            child: const Text('Update Password'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updatePassword() async {
    if (_formkey.currentState!.validate()) {
      // Implement your password update logic here
      // String currentPassword = _currentPasswordController.text;
      String newPassword = _newPasswordController.text;
      String confirmNewPassword = _confirmNewPasswordController.text;
      // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      //     .collection('User')
      //     .where('EmployeeId', isEqualTo: 'ZW3210')
      //     .get();
      // print(querySnapshot.docs.first.id);
      // Add validation and password update logic
      if (newPassword == confirmNewPassword) {
        // Perform password update action
        // For example, use FirebaseAuth.instance.currentUser.updatePassword(newPassword);
        FirebaseFirestore.instance.collection('User').doc('ZAP WMS').update({
          'Password': newPassword,
          'ConfirmPassword': confirmNewPassword,
        }).whenComplete(() {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Your password is updated Successfully')));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => LoginRegister()));
        });
        // Handle success or failure accordingly
        print('Password updated successfully');
      } else {
        // Passwords do not match, show an error message
        print('New password and confirm new password do not match');
      }
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  String? validatePassword(String value) {
    // Check if the password is empty
    if (value.isEmpty) {
      return 'Password is required';
    }

    if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(value)) {
      return 'Password should be 8 caharecter & at least one upper case , contain alphabate , numbers & special character';
    }
    return null;

    // Return null if the input is valid
  }
}
