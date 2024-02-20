import 'package:assingment/Authentication/login.dart';
import 'package:assingment/Authentication/register.dart';
import 'package:assingment/widget/style.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: 450,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/webhome.jpg',
                          ),
                          fit: BoxFit.fill)),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: blue),
                  ),
                  child: DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize: const Size.fromHeight(300),
                        child: Column(children: [
                          _space(10),
                          Text("Project Management Information System",
                              style: headline5White),
                          Text(" EV Monitoring ", style: headline5White),
                          _space(5),
                          Text("Login to access your account below!",
                              style: subtitle1White60),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'assets/Green.jpeg',
                                  height: 70,
                                  width: 70,
                                ),
                                Image.asset(
                                  'assets/sustainable.jpeg',
                                  height: 70,
                                  width: 70,
                                ),
                              ],
                            ),
                          ),
                          _space(5),
                          TabBar(
                            labelColor: green,
                            labelStyle: buttonWhite,
                            unselectedLabelColor: Colors.black,

                            //indicatorSize: TabBarIndicatorSize.label,
                            indicator: MaterialIndicator(
                              horizontalPadding: 24,
                              bottomLeftRadius: 8,
                              bottomRightRadius: 8,
                              color: almostblack,
                              paintingStyle: PaintingStyle.fill,
                            ),

                            tabs: const [
                              Tab(
                                text: "Sign In",
                              ),
                              Tab(
                                text: "Register",
                              ),
                            ],
                          ),
                        ]),
                      ),
                      body: const TabBarView(children: [
                        SignInPage(),
                        RegisterPage(),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _space(double i) {
    return SizedBox(
      height: i,
    );
  }
}
