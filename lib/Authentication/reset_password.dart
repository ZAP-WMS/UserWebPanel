import 'package:assingment/widget/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'check_otp.dart';

class ResetPass extends StatefulWidget {
  // final String email;
  ResetPass({
    Key? key,
    // required this.email,
  }) : super(key: key);

  static String verify = '';

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  FocusNode? _focusNode;
  TextEditingController textEditingController = TextEditingController();
  List docss = [];
  String? mobileNum;
  String? name;
  String? lastName;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode!.addListener(_onOnFocusNodeEvent);
    // if (RegExp(
    //         r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
    //     .hasMatch(textEditingController.text)) ;
    // textEditingController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        title: Text(
          'Reset Password',
          style: TextStyle(color: white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            CupertinoIcons.back,
            color: white,
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 2,
          height: 500,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(15),
          //   border: Border.all(color: blue),
          // ),
          child: Card(
            elevation: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(color: blue)
                // Set the border radius
                ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      'Reset Password',
                      style: headline5White,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Enter the number associated with your account and  we\'ll send an otp \n with instructions to reset your password',
                    style: bodyText2White38,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 80),
                  Container(
                    width: 500,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: textEditingController,
                      focusNode: _focusNode,
                      style: bodyText2White38,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            10), // Specify the length here
                      ],
                      decoration: InputDecoration(
                          fillColor:
                              _focusNode!.hasFocus ? Colors.white : white,
                          filled: true,
                          alignLabelWithHint: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: black,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          labelText: _focusNode!.hasFocus ? 'User ID' : null,
                          labelStyle: _focusNode!.hasFocus ? bodyText2 : null,
                          hintText: _focusNode!.hasFocus ? null : 'User ID',
                          hintStyle: bodyText2White38),
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    height: 48,
                    width: 100,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0)),
                          minimumSize: MediaQuery.of(context).size,
                          backgroundColor: blue,
                        ),
                        onPressed: () async {
                          if (textEditingController.text.isNotEmpty) {
                            getNumber(textEditingController.text)
                                .whenComplete(() async {
                              print('mobile number$mobileNum');
                              if (mobileNum != null) {
                                // verifyPhoneNumber('+91$mobileNum');
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: '+91$mobileNum',
                                    verificationCompleted:
                                        (PhoneAuthCredential credential) {},
                                    verificationFailed:
                                        (FirebaseAuthException e) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(e.toString()),
                                        backgroundColor: red,
                                      ));
                                    },
                                    codeSent: (String verificationId,
                                        int? resendToken) {
                                      ResetPass.verify = verificationId;
                                      // print('verifycode${ResetPass.verify}');
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CheckOtp(
                                                  name: name! + lastName!,
                                                  mobileNumber:
                                                      int.parse(mobileNum!))));
                                    },
                                    codeAutoRetrievalTimeout:
                                        (String verificationId) {});

                                // ignore: use_build_context_synchronously
                              } else {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: const Text(
                                      "We could not find your ID. Please check once to ensure it is correct."),
                                  backgroundColor: red,
                                ));
                              }
                            });
                          } else {
                            // ignore: prefer_const_constructors
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('User Id is required'),
                            ));
                          }
                        },
                        child: Text('Send',
                            style: TextStyle(
                                fontSize: 14,
                                color: almostWhite,
                                fontWeight: FontWeight.w500))),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getNumber(dynamic id) async {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: SizedBox(
          height: 120,
          width: 50,
          child: Center(
            child: Column(
              children: const [
                CircleAvatar(
                  child: Icon(Icons.person),
                ),
                SizedBox(height: 10),
                CircularProgressIndicator(
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text('Wait We are verifying your Id')
              ],
            ),
          ),
        ),
      ),
    );
    String? clnName;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('User').get();
    querySnapshot.docs.forEach((element) {
      clnName = element.id;
      docss.add(clnName);
    });
    for (int i = 0; i < docss.length; i++) {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(docss[i])
          .get()
          .then((value) {
        if (value.data()!['Employee Id'] == id) {
          setState(() {
            name = value.data()!['FirstName'];
            lastName = value.data()!['LastName'];
            mobileNum = value.data()!['Phone Number'];
          });
        }
      });
    }
  }

  _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }
}
