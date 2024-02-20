import 'package:assingment/Authentication/auth_service.dart';
import 'package:assingment/Authentication/login_register.dart';
import 'package:assingment/widget/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formkey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  bool _isHidden = true;

  String? firstname;
  String? lastname;
  String? phone;
  String? email;
  String? designation;
  String? department;
  String? password;
  String? confpassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: const AppBarWithBack(
        //   text: "",
        // ),
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          SingleChildScrollView(
            reverse: false,
            child: Container(
              color: Colors.white,
              child: Form(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      _space(16),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: "First Name",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'First Name is required';
                            }

                            return null;
                          },

                          // key: ValueKey('username'),
                          keyboardType: TextInputType.name,
                          style: bodyText2White60,
                          // onSaved: (value) {
                          //   _name = value!;
                          // },
                          onChanged: (value) {
                            setState(() {
                              firstname = value;
                            });
                          }),
                      const SizedBox(height: 24),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: "Last Name",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Last Name is required';
                            }

                            // if (value.length < 5 || value.length > 12) {
                            //   return 'Display Last Name must be betweem 5 and 12 characters';
                            // }

                            return null;
                          },

                          // key: ValueKey('username'),
                          keyboardType: TextInputType.name,
                          style: bodyText2White60,
                          // onSaved: (value) {
                          //   _name = value!;
                          // },
                          onChanged: (value) {
                            setState(() {
                              lastname = value;
                            });
                          }),
                      const SizedBox(height: 24),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: "Phone",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Number is required';
                            }

                            if (value.length < 10) {
                              return '10 digit number is required';
                            }

                            return null;
                          },

                          // key: ValueKey('username'),
                          keyboardType: TextInputType.number,
                          style: bodyText2White60,
                          // onSaved: (value) {
                          //   _name = value!;
                          // },
                          onChanged: (value) {
                            setState(() {
                              phone = value;
                            });
                          }),
                      const SizedBox(height: 24),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: "Email ID",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email is required';
                            }

                            if (!RegExp(
                                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }

                            return null;
                          },
                          style: bodyText2White60,
                          keyboardType: TextInputType.emailAddress,
                          // onSaved: (value) {
                          //   setState(() {
                          //     _email = value!;
                          //   });
                          // },
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          }),
                      const SizedBox(height: 24),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: "Designation",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Designation is required';
                            }

                            return null;
                          },

                          // key: ValueKey('username'),
                          keyboardType: TextInputType.name,
                          style: bodyText2White60,
                          // onSaved: (value) {
                          //   _name = value!;
                          // },
                          onChanged: (value) {
                            setState(() {
                              designation = value;
                            });
                          }),
                      const SizedBox(height: 24),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: "Department",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Department is required';
                            }

                            return null;
                          },
                          // key: ValueKey('username'),
                          keyboardType: TextInputType.name,
                          style: bodyText2White60,
                          // onSaved: (value) {
                          //   _name = value!;
                          // },
                          onChanged: (value) {
                            setState(() {
                              department = value;
                            });
                          }),
                      const SizedBox(height: 24),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                              onTap: _togglePasswordView,
                              child: _isHidden
                                  ? const Icon(Icons.visibility)
                                  : Icon(
                                      Icons.visibility_off,
                                      color: grey,
                                    )),
                          labelText: "Password",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required';
                          }
                          if (!!RegExp(
                                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                              .hasMatch(value)) {
                            return 'Password should be 8 caharecter & at least one upper case , contain alphabate , numbers & special character';
                          }
                          return null;
                        },
                        // key: ValueKey('password'),
                        obscureText: _isHidden,

                        style: bodyText2White60,
                        keyboardType: TextInputType.visiblePassword,
                        // onSaved: (value) {
                        //   setState(() {
                        //     _pass = value!;
                        //   });
                        // },
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: "Confirm Password",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Confirm Password is required';
                          }
                          if (value != password) {
                            return 'Confirm Password not matched with password';
                          }

                          // if (value.length < 5 || value.length > 20) {
                          //   return 'Confirm Password must be betweem 5 and 20 characters';
                          // }

                          return null;
                        },
                        // key: ValueKey('password'),
                        obscureText: true,
                        style: bodyText2White60,
                        keyboardType: TextInputType.visiblePassword,
                        // onSaved: (value) {
                        //   setState(() {
                        //     _pass = value!;
                        //   });
                        // },
                        onChanged: (value) {
                          setState(() {
                            confpassword = value;
                          });
                        },
                      ),
                      const SizedBox(height: 38),
                      InkWell(
                        onTap: () {
                          register();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: blue,
                          ),
                          child: Center(
                            child: Text("Register", style: button),
                          ),
                        ),
                      ),
                      _space(28),
                      _space(5),
                      Center(
                        child: Image.asset(
                          'assets/Tata-Power.jpeg',
                          height: 150,
                          width: 200,
                        ),
                      ),
                      _space(38),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _space(double i) {
    return SizedBox(
      height: i,
    );
  }

  void register() async {
    if (_formkey.currentState!.validate()) {
      showCupertinoDialog(
        context: context,
        builder: (context) => const CupertinoAlertDialog(
          content: SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
      await authService
          .registerUserWithEmailAndPassword(firstname!, lastname!, phone!,
              email!, designation!, department!, password!, confpassword!)
          .then((value) {
        if (value == true) {
          authService
              .storeDataInFirestore(
                  firstname!,
                  lastname!,
                  phone!,
                  email!,
                  designation!,
                  department!,
                  password!,
                  confpassword!,
                  firstname![0] + lastname![0] + phone!.substring(6, 10))
              .then((value) {
            if (value == true) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Registration Successfull Please Sign In'),
                backgroundColor: blue,
              ));
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginRegister()),
              );
            } else {
              Navigator.pop(context);
              //     authService.firebaseauth.signOut();
            }
          });
        } else {
          Navigator.of(context).pop();
        }
      });
    }
  }
  // void _googleLogin(BuildContext context, AuthService auth) async {
  //   showCupertinoDialog(
  //     context: context,
  //     builder: (context) => const CupertinoAlertDialog(
  //       content: SizedBox(
  //         height: 50,
  //         width: 50,
  //         child: Center(
  //           child: CircularProgressIndicator(color: Colors.white),
  //         ),
  //       ),
  //     ),
  //   );
  //   String? s = await auth.signInWithGoogle();
  //   if (s == 'Signed in With Google') {
  //     authService.storeDataInFirestore().then((value) {
  //       if (value == true) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => const HomePage(
  //                     isExtended: false,
  //                   )),
  //         );
  //       } else {
  //         Navigator.pop(context);
  //         authService.firebaseauth.signOut();
  //       }
  //     });
  //   } else {
  //     if (!mounted) return;
  //     Navigator.of(context).pop();
  //   }
  // }

  // register() async {
  //   if (_formkey.currentState!.validate()) {
  //     showCupertinoDialog(
  //       context: context,
  //       builder: (context) => const CupertinoAlertDialog(
  //         content: SizedBox(
  //           height: 50,
  //           width: 50,
  //           child: Center(
  //             child: CircularProgressIndicator(
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //       ),
  //     );
  //     await authService
  //         .registerUserWithEmailAndPassword(_name, _email, _pass)
  //         .then((value) async {
  //       if (value == true) {
  //         authService.storeDataInFirestore().then((value) {
  //           if (value == true) {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => const HomePage(
  //                         isExtended: false,
  //                       )),
  //             );
  //           } else {
  //             Navigator.pop(context);
  //             authService.firebaseauth.signOut();
  //           }
  //         });
  //       } else {
  //         Navigator.of(context).pop();
  //       }
  //     });
  //   }
  // }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
