import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fssm/global/user_data.dart';
import 'package:fssm/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants/api_const.dart';
import '../constants/color_const.dart';

//Add Operation repo
Future userAddOps(String sludgeRe, String avgCa, String sourceSl, String vehNum,
    String opBool, context) async {
  SharedPreferences _sharedData = await SharedPreferences.getInstance();
  var headers = {'Authorization': 'Bearer $userToken'};
  var request = http.MultipartRequest('POST', Uri.parse(addops));
  request.fields.addAll({
    'ulbId': userUldId,
    'sludgeQuantityRecieved': sludgeRe,
    'avgCapacity': avgCa,
    'sourceOfSludge': sourceSl,
    'vehicleNumber': vehNum,
    'operatorWithPpe': opBool
  });

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: ((context) => HomeScreen()),
        ));
    print(await response.stream.bytesToString());
  } else {
    Navigator.pop(context);
    Fluttertoast.showToast(msg: "SomeThing Went wrong");

    print(response.reasonPhrase);
  }
}
