import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fssm/constants/color_const.dart';
import 'package:http/http.dart' as http;
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_const.dart';
import '../global/user_data.dart';
import '../home/home.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //boolean data
  bool dist = false;
  bool uld = false;

  //Data
  String _selectedDis = "Select District";
  String distID = "";

  //Data
  String _selectedDisULB = "Select District ULB";
  String distULBID = "";

  //District
  Future<List> getDis() async {
    var request = http.Request('POST', Uri.parse(disLis));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      return decodedMap['data'];
    } else {
      print(response.reasonPhrase);
    }
    throw "";
  }

  //ULB List
  Future<List> getDisULB() async {
    var request = http.MultipartRequest('POST', Uri.parse(disUlbList));
    request.fields.addAll({'districtId': distID});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      return decodedMap['ulbList'];
    } else {
      print(response.reasonPhrase);
    }

    throw "";
  }

  //ULB List
  Future loginAPI(context) async {
    var request = http.MultipartRequest('POST', Uri.parse(login));
    request.fields.addAll({'_id': distULBID});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      SharedPreferences _getData = await SharedPreferences.getInstance();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      String? _token = decodedMap['token'].toString();
      String? _distID = decodedMap['user']['districtId'].toString();
      String? _ulbID = decodedMap['user']['ulbId'].toString();
      String? _distName = decodedMap['user']['districtName'].toString();
      String? _ulbName = decodedMap['user']['ulbName'].toString();

      _getData.setString("maintoken", _token);
      _getData.setString('distID', _distID);
      _getData.setString('uldID', _ulbID);
      _getData.setString("distName", _distName);
      _getData.setString("ulbName", _ulbName);

      setState(() {
        userUldId = _ulbID;
      });

      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );

      return decodedMap;
    } else {
      Fluttertoast.showToast(msg: "${response.reasonPhrase}");
    }

    throw "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Pattana Pragati FSSM Tracker",
                            style: TextStyle(
                              color: white,
                              fontFamily: 'PopB',
                              fontSize: 20,
                            ),
                          ),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "*Please select District and ULB to have a look at the data",
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'PopM',
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: dist == true
                          ? Radius.circular(0)
                          : Radius.circular(10),
                      bottomLeft: dist == true
                          ? Radius.circular(0)
                          : Radius.circular(10),
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                  color: white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(1, 0),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(LineIcons.city),
                          SizedBox(
                            width: 10,
                          ),
                          Text(_selectedDis,
                              style: TextStyle(
                                color: _selectedDis != "Select District"
                                    ? Colors.black
                                    : Colors.grey.shade600,
                                fontFamily: 'PopM',
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          dist = !dist;
                        });
                      },
                      icon: Icon(LineIcons.chevronCircleDown),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: dist == true ? true : false,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: dist == true
                            ? Radius.circular(0)
                            : Radius.circular(10),
                        topLeft: dist == true
                            ? Radius.circular(0)
                            : Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: FutureBuilder(
                    future: getDis(),
                    builder: ((context, AsyncSnapshot<List> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Container(
                            height: 3,
                            width: MediaQuery.of(context).size.width / 3,
                            child: LinearProgressIndicator(
                              color: primaryColor,
                              backgroundColor: primaryColor.withOpacity(0.3),
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: ((context, index) {
                          return Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  LineIcons.city,
                                  color: black,
                                ),
                                title: Text(
                                  snapshot.data![index]['district_name']
                                      .toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'PopM',
                                    fontSize: 15,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedDis = snapshot.data![index]
                                            ['district_name']
                                        .toString();
                                    distID =
                                        snapshot.data![index]['_id'].toString();
                                    dist = !dist;
                                  });
                                },
                              ),
                              Divider()
                            ],
                          );
                        }),
                      );
                    }),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: uld == true
                          ? Radius.circular(0)
                          : Radius.circular(10),
                      bottomLeft: uld == true
                          ? Radius.circular(0)
                          : Radius.circular(10),
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                  color: white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(1, 0),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(LineIcons.city),
                          SizedBox(
                            width: 10,
                          ),
                          Text(_selectedDisULB,
                              style: TextStyle(
                                color: _selectedDisULB != "Select District ULB"
                                    ? Colors.black
                                    : Colors.grey.shade600,
                                fontFamily: 'PopM',
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (distID == "") {
                          Fluttertoast.showToast(
                              msg: "Please select District first");
                        } else {
                          setState(() {
                            uld = !uld;
                          });
                        }
                      },
                      icon: Icon(LineIcons.chevronCircleDown),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: uld == true ? true : false,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: uld == true
                            ? Radius.circular(0)
                            : Radius.circular(10),
                        topLeft: uld == true
                            ? Radius.circular(0)
                            : Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: FutureBuilder(
                    future: getDisULB(),
                    builder: ((context, AsyncSnapshot<List> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Container(
                            height: 3,
                            width: MediaQuery.of(context).size.width / 3,
                            child: LinearProgressIndicator(
                              color: primaryColor,
                              backgroundColor: primaryColor.withOpacity(0.3),
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: ((context, index) {
                          return Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  LineIcons.city,
                                  color: black,
                                ),
                                title: Text(
                                  snapshot.data![index]['ulb_name'].toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'PopM',
                                    fontSize: 15,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedDisULB = snapshot.data![index]
                                            ['ulb_name']
                                        .toString();
                                    distULBID =
                                        snapshot.data![index]['_id'].toString();
                                    uld = !uld;
                                  });
                                },
                              ),
                              Divider()
                            ],
                          );
                        }),
                      );
                    }),
                  ),
                ),
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
                    if (distID == "") {
                      Fluttertoast.showToast(
                          msg: "Please select District first");
                    } else if (distULBID == "") {
                      Fluttertoast.showToast(
                          msg: "Please select District ULB first");
                    } else {
                      loginAPI(context);
                    }
                  },
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: Center(
                      child: Text(
                        "Enter",
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
              height: 40,
            ),
            Image.asset('assets/images/loginliius.png')
          ],
        ),
      ),
    );
  }
}
