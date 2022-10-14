import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fssm/constants/color_const.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_const.dart';
import '../global/user_data.dart';
import '../home/home.dart';
import '../widget/loader.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool passVisible = false;

  final _formKey = GlobalKey<FormState>();

//User Login Repo

  Future userlogin(String emails, String passwords, context) async {
    SharedPreferences _sharedData = await SharedPreferences.getInstance();
    var request = http.MultipartRequest('POST', Uri.parse(login));
    request.fields.addAll({'email': emails, 'password': passwords});

    http.StreamedResponse response = await request.send();

    print(response.statusCode);

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      String userID = decodedMap['user']['_id'].toString();
      String name = decodedMap['user']['userName'].toString();
      String email = decodedMap['user']['email'].toString();
      String ulbID = decodedMap['user']['ulbId'].toString();

      String token = decodedMap['token'].toString();

      _sharedData.setString('personid', userID);
      _sharedData.setString('personemail', email);
      _sharedData.setString('maintoken', token);
      _sharedData.setString("personname", name);
      _sharedData.setString("personulbnid", ulbID);

      setState(() {
        userId = userID;
        userName = name;
        userEmail = email;
        userToken = token;
        userUldId = ulbID;
      });

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          (route) => false);

      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: ((context) => HomeScreen()),
      //     ));

      // print(await response.stream.bytesToString());
    } else {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Material(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    tileMode: TileMode.mirror,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: Text(
                decodedMap['message'].toString(),
                style: TextStyle(color: Colors.white),
              )),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 160,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondColor],
                    begin: Alignment.topLeft,
                    // end: Alignment.bottomRight,
                    tileMode: TileMode.mirror,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "FSSM",
                          style: TextStyle(
                            color: white,
                            fontFamily: 'PopB',
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "Login",
                          style: TextStyle(
                            color: white,
                            fontFamily: 'PopB',
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                right: -20,
                child: Lottie.asset(
                  'assets/animations/bubbles.json',
                  height: 130,
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: TextFormField(
                        style: TextStyle(
                          fontFamily: 'PopM',
                          fontSize: 15,
                        ),
                        controller: _emailController,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                        ],
                        decoration: InputDecoration(
                          hintText: 'your@gmail.com',
                          label: const Text("Email"),
                          labelStyle: TextStyle(
                            fontFamily: 'MonS',
                            fontSize: 13,
                            color: primaryColor,
                          ),
                          suffixIcon: Icon(
                            Icons.mobile_screen_share,
                            color: primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.teal),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                        validator: (value) => EmailValidator.validate(value!)
                            ? null
                            : "Please enter a valid email",
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 2.0),
                      child: TextFormField(
                        style: TextStyle(
                          fontFamily: 'PopM',
                          fontSize: 15,
                          letterSpacing: 1,
                        ),
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: '********',
                          label: const Text("Password"),
                          labelStyle: TextStyle(
                            fontFamily: 'MonS',
                            fontSize: 13,
                            color: primaryColor,
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                passVisible = !passVisible;
                              });
                            },
                            child: Icon(
                              passVisible == false
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: primaryColor,
                            ),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: primaryColor)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: primaryColor)),
                        ),
                        obscureText: passVisible == false ? true : false,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter valid password';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton.icon(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => ForgotVerificationPage(
                                //       title: "Forgot Password",
                                //     ),
                                //   ),
                                // );
                              },
                              icon: const Icon(
                                Icons.password,
                                color: Colors.black,
                              ),
                              label: const Text(
                                "Forgot Password",
                                style: TextStyle(
                                  fontFamily: 'MonR',
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(primaryColor),
                          ),
                          onPressed: () async {
                            String useremail = _emailController.text;
                            String password = _passwordController.text;

                            if (_formKey.currentState!.validate()) {
                              showLoaderDialog(
                                  context, "Logging you in...", 80);

                              userlogin(useremail, password, context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Material(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: Text(
                                        "Please Fill all the required details...",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    ),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                ),
                              );
                            }

                            // print("--------------> " +
                            //     fcmtoken.toString() +
                            //     " <-----------------");
                            // print("---------------->> " +
                            //     _deviceId.toString() +
                            //     " <<-------------");
                            // print("---------------->>>> " +
                            //     _deviceType.toString() +
                            //     " <<<<-------------");

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => UserSectionPage()));
                          },
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 1.4,
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: white,
                                  fontSize: 15,
                                  fontFamily: 'MonS',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset('assets/images/loginliius.png')
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
