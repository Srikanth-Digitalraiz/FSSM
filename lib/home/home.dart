import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fssm/auth/changepwd.dart';
import 'package:fssm/auth/login.dart';
import 'package:fssm/constants/color_const.dart';
import 'package:fssm/global/user_data.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_const.dart';
import 'form.dart';
import 'history.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userData();
    vehAndSlucount(context);
  }

  void _userData() async {
    SharedPreferences _data = await SharedPreferences.getInstance();
    String? to = _data.getString('maintoken');
    String? uld = _data.getString('uldID');
    String? ulbName = _data.getString('ulbName');
    String? distname = _data.getString('distName');
    String? distID = _data.getString('distID');

    setState(() {
      userToken = to!;
      userUldId = uld!;
      uldNAME = ulbName!;
      distNAME = distname!;
      distsID = distID!;
    });
  }

  //Vehicle Count
  Future vehAndSlucount(context) async {
    var headers = {'Authorization': 'Bearer $userToken'};
    var request = http.MultipartRequest('POST', Uri.parse(countAPI));
    request.fields.addAll({'ulbId': userUldId});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print("Response for vehCo:   " + response.statusCode.toString());

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      setState(() {
        todayVehCount = decodedMap['todayvehiclesCount'].toString();
        todaySludgeQty = decodedMap['todayTotalSludge'].toString();
      });
    } else if (response.statusCode == 400) {
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
              child: const Center(
                  child: Text(
                "Token Expired please Login Again...",
                style: TextStyle(color: Colors.white),
              )),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => LoginScreen(),
          ),
          (route) => false);
    } else {
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
              child: const Center(
                  child: Text(
                "Something went wrong...Logout and Try Logging in again.",
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

  //Date
  var dt = DateTime.now();

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          titleSpacing: 0,
          backgroundColor: primaryColor,
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: _menu(context),
                          );
                        });
                  },
                  icon: Icon(Icons.menu, color: white)),
              SizedBox(
                width: 10,
              ),
              Text(
                "FSSM Tracker",
                style: TextStyle(
                  color: white,
                  fontFamily: 'PopM',
                  fontSize: 15,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: "FSSM Form",
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => FSSMForm(),
                  ),
                );
              },
              icon: Icon(
                Icons.article,
                color: white,
              ),
            ),
            IconButton(
              tooltip: "Profile",
              onPressed: () {
                showModalBottomSheet(
                    isDismissible: false,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: _profileSection(context),
                      );
                    });
              },
              icon: Icon(
                Icons.account_circle,
                color: white,
              ),
            ),
            IconButton(
              tooltip: "History",
              onPressed: () async {
                // SharedPreferences log = await SharedPreferences.getInstance();
                // log.clear();
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => HistoryScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.history,
                color: white,
              ),
            )
          ],
        ),
        body: PageView(
          children: <Widget>[_totalVehicleCount(), _totalSludgeCount()],
        ),
      ),
    );
  }

  _totalVehicleCount() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Color(0xFFededed),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Vehicle \n Count",
                    style: TextStyle(
                      color: black,
                      fontFamily: 'PopB',
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          Jiffy(dt).yMMMMd,
                          style: const TextStyle(
                            fontFamily: 'PopM',
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          uldNAME,
                          style: const TextStyle(
                            fontFamily: 'PopM',
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: MediaQuery.of(context).size.height / 3),
                  Text(
                    "Trucks",
                    style: TextStyle(
                      color: black,
                      fontFamily: 'PopM',
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "$todayVehCount",
                    style: TextStyle(
                      color: black,
                      fontFamily: 'PopB',
                      fontSize: 78,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 210,
            right: -180,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(300),
                gradient: LinearGradient(
                  colors: [secondColor, primaryColor],
                  begin: Alignment.topLeft,
                  // end: Alignment.bottomRight,
                  tileMode: TileMode.mirror,
                ),
              ),
            ),
          ),
          Positioned(
            top: 170,
            right: -100,
            child: Transform.scale(
              scaleX: -1,
              child: Image.asset(
                'assets/images/truck.gif',
                height: 380,
                width: 380,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Swipe left to see sluge quantity ->",
                style: TextStyle(
                  color: black,
                  fontFamily: 'PopM',
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _totalSludgeCount() {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Color(0xFFededed),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Sludge \n Quantity",
                    style: TextStyle(
                      color: black,
                      fontFamily: 'PopB',
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          Jiffy(dt).yMMMMd,
                          style: const TextStyle(
                            fontFamily: 'PopM',
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        uldNAME,
                        style: const TextStyle(
                          fontFamily: 'PopM',
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(height: MediaQuery.of(context).size.height / 3),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Sludge",
                      style: TextStyle(
                        color: black,
                        fontFamily: 'PopM',
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "$todaySludgeQty",
                        style: TextStyle(
                          color: black,
                          fontFamily: 'PopB',
                          fontSize: 78,
                        ),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 28.0),
                        child: Text(
                          "Liters",
                          style: TextStyle(
                            color: black,
                            fontFamily: 'PopR',
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 210,
            left: -180,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(300),
                gradient: LinearGradient(
                  colors: [primaryColor, secondColor],
                  begin: Alignment.topLeft,
                  // end: Alignment.bottomRight,
                  tileMode: TileMode.mirror,
                ),
              ),
            ),
          ),
          Positioned(
            top: 170,
            left: -100,
            child: Transform.scale(
              scaleX: 1,
              child: Image.asset(
                'assets/images/truck.gif',
                height: 380,
                width: 380,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "<- Swipe right to see number of vehicles",
                style: TextStyle(
                  color: black,
                  fontFamily: 'PopM',
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _profileSection(context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 18,
                ),
                Expanded(
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      color: white,
                      fontFamily: 'PopM',
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: white,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    image: DecorationImage(
                        image: NetworkImage(
                          "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&w=1000&q=80",
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "ULB Name: ",
                        style: const TextStyle(
                          fontFamily: 'PopB',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        uldNAME,
                        style: const TextStyle(
                          fontFamily: 'PopM',
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 11, left: 10, right: 10),
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "District Name: ",
                        style: const TextStyle(
                          fontFamily: 'PopB',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        distNAME,
                        style: const TextStyle(
                          fontFamily: 'PopM',
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  _menu(context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.1,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              color: primaryColor,
            ),
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          color: white),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            image: DecorationImage(
                                image: NetworkImage(
                                  "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHw%3D&w=1000&q=80",
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        uldNAME,
                        style: const TextStyle(
                          fontFamily: 'PopB',
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        distNAME,
                        style: const TextStyle(
                          fontFamily: 'PopM',
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences _shared =
                        await SharedPreferences.getInstance();
                    _shared.clear();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                        (route) => false);
                    // Navigator.pushReplacement(
                    //   context,
                    //   CupertinoPageRoute(
                    //     builder: (context) => LoginScreen(),
                    //   ),
                    // );
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80), color: white),
                    child: Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ),
          SizedBox(
            height: 3,
          ),
          ListTile(
            leading: Icon(
              Icons.article,
              color: black,
            ),
            title: Text(
              "FSSM Form",
              style: const TextStyle(
                fontFamily: 'PopM',
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => FSSMForm(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: black,
            ),
            title: Text(
              "Profile",
              style: const TextStyle(
                fontFamily: 'PopM',
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                  isDismissible: false,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: _profileSection(context),
                    );
                  });
            },
          ),
          ListTile(
            leading: Icon(
              Icons.history,
              color: black,
            ),
            title: Text(
              "History",
              style: const TextStyle(
                fontFamily: 'PopM',
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => HistoryScreen(),
                ),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(
          //     Icons.change_circle,
          //     color: black,
          //   ),
          //   title: Text(
          //     "Change Password",
          //     style: const TextStyle(
          //       fontFamily: 'PopM',
          //       fontSize: 15,
          //       color: Colors.black,
          //     ),
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.push(
          //       context,
          //       CupertinoPageRoute(
          //         builder: (context) => ChangePassword(),
          //       ),
          //     );
          //   },
          // ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text(
              "Logout",
              style: const TextStyle(
                fontFamily: 'PopM',
                fontSize: 15,
                color: Colors.red,
              ),
            ),
            onTap: () async {
              SharedPreferences _shared = await SharedPreferences.getInstance();
              _shared.clear();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                  (route) => false);
            },
          )
        ],
      ),
    );
  }
}

/**
 * String _name = decodedMap['userResult']['name'].toString();
 */
