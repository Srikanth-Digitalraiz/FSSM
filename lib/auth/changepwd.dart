import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fssm/auth/login.dart';
import 'package:fssm/global/user_data.dart';
import 'package:fssm/widget/loader.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_const.dart';
import '../constants/color_const.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentPass = TextEditingController();
  final TextEditingController _newPass = TextEditingController();
  final TextEditingController _conNewPass = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future _changePwd(oldPass, newPass, connewPass, context) async {
    SharedPreferences _data = await SharedPreferences.getInstance();

    var headers = {
      'Authorization': 'Bearer $userToken',
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(changepas));
    request.body = json.encode({
      "currentPassword": oldPass,
      "newPlainPassword": newPass,
      "confirmPassword": connewPass
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      _data.clear();

      Fluttertoast.showToast(msg: "Password was changed...successfully");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: ((context) => LoginScreen())));

      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 1,
        backgroundColor: primaryColor,
        title: Text(
          "Change Password",
          style: TextStyle(
            color: white,
            fontFamily: 'PopM',
            fontSize: 15,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                'assets/images/change.png',
              ),
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
                  controller: _currentPass,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                  // ],
                  decoration: InputDecoration(
                    hintText: 'Enter Current Password',
                    label: const Text("Current Password"),
                    labelStyle: TextStyle(
                      fontFamily: 'MonS',
                      fontSize: 13,
                      color: primaryColor,
                    ),
                    suffixIcon: Icon(
                      Icons.password,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid password';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextFormField(
                  style: TextStyle(
                    fontFamily: 'PopM',
                    fontSize: 15,
                  ),
                  controller: _newPass,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                  // ],
                  decoration: InputDecoration(
                    hintText: 'Enter New Password',
                    label: const Text("New Password"),
                    labelStyle: TextStyle(
                      fontFamily: 'MonS',
                      fontSize: 13,
                      color: primaryColor,
                    ),
                    suffixIcon: Icon(
                      Icons.password,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid password';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: TextFormField(
                  style: TextStyle(
                    fontFamily: 'PopM',
                    fontSize: 15,
                  ),
                  controller: _conNewPass,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.deny(RegExp(r"\s\b|\b\s"))
                  // ],
                  decoration: InputDecoration(
                    hintText: 'Confirm New Password',
                    label: const Text("Confirm Password"),
                    labelStyle: TextStyle(
                      fontFamily: 'MonS',
                      fontSize: 13,
                      color: primaryColor,
                    ),
                    suffixIcon: Icon(
                      Icons.password,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter valid password';
                    }
                    if (_conNewPass.text != _newPass.text) {
                      return 'Password and Confirm Password doesnot match...';
                    }
                    return null;
                  },
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
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                    ),
                    onPressed: () async {
                      String currPass = _currentPass.text;
                      String newPass = _newPass.text;
                      String conPass = _conNewPass.text;

                      if (_formKey.currentState!.validate()) {
                        showLoaderDialog(context, "Changing Password...", 80);
                        _changePwd(currPass, newPass, conPass, context);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Please Fill all teh required details...");
                      }
                    },
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1.4,
                      child: Center(
                        child: Text(
                          "Change Password",
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
            ],
          ),
        ),
      ),
    );
  }
}
