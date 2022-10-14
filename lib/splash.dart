import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fssm/auth/login.dart';
import 'package:fssm/constants/color_const.dart';
import 'package:fssm/global/user_data.dart';
import 'package:fssm/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userData();
    Timer(
      Duration(seconds: 10),
      () async {
        userToken == ""
            ? await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
                (route) => false)
            : await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
                (route) => false);
      },
    );
  }

  void _userData() async {
    SharedPreferences _data = await SharedPreferences.getInstance();
    String? na = _data.getString('personname');
    String? em = _data.getString('personemail');
    String? id = _data.getString('personid');
    String? to = _data.getString('maintoken');
    String? ulI = _data.getString('personulbnid');

    setState(() {
      userName = na!;
      userEmail = em!;
      userId = id!;
      userToken = to!;
      userUldId = ulI!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondColor],
            begin: Alignment.topLeft,
            // end: Alignment.bottomRight,
            tileMode: TileMode.mirror,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(
                  'http://tsfssm.iotroncs.co.in/assets/img/govtlogo.png',
                  height: 150,
                  width: 150,
                ),
                SvgPicture.network(
                  'http://tsfssm.iotroncs.co.in/assets/img/logo2.svg',
                  height: 150,
                  width: 150,
                )
              ],
            ),
            // Center(
            //   child: Padding(
            //     padding: const EdgeInsets.all(58.0),
            //     child: Container(
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10), color: white),
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Image.asset(
            //           'assets/images/logo.png',
            //           width: 120,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
