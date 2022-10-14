import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fssm/global/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:fssm/constants/api_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/color_const.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<List> getHistory(context) async {
    var headers = {'Authorization': 'Bearer $userToken'};
    var request = http.MultipartRequest('POST', Uri.parse('$history'));
    request.fields.addAll({'ulbId': userUldId});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      return decodedMap['showHistory'];
    } else {
      print(response.reasonPhrase);
    }
    throw '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: primaryColor,
        title: Text(
          "History",
          style: TextStyle(
            color: white,
            fontFamily: 'PopM',
            fontSize: 15,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: FutureBuilder(
              future: getHistory(context),
              builder: (context, AsyncSnapshot<List> snapshot) {
                // return Text(snapshot.data.toString());
                if (!snapshot.hasData) {
                  return Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width / 2,
                      child: LinearProgressIndicator(
                        color: primaryColor,
                        backgroundColor: secondColor.withOpacity(0.3),
                      ),
                    ),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "No history available...",
                      style: TextStyle(
                        color: black,
                        fontFamily: 'PopM',
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: primaryColor,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
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
                              padding: const EdgeInsets.all(7.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Date: ",
                                        style: TextStyle(
                                          color: black,
                                          fontFamily: 'PopR',
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${snapshot.data![index]['date']}",
                                        style: TextStyle(
                                          color: black,
                                          fontFamily: 'PopM',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "ULB Name: ",
                                        style: TextStyle(
                                          color: black,
                                          fontFamily: 'PopR',
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${snapshot.data![index]['ulb_name']}",
                                        style: TextStyle(
                                          color: black,
                                          fontFamily: 'PopM',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Vehicle Number: ",
                                        style: TextStyle(
                                          color: black,
                                          fontFamily: 'PopR',
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${snapshot.data![index]['vehicleNumber']}",
                                        style: TextStyle(
                                          color: black,
                                          fontFamily: 'PopM',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Sludge Quantity: ",
                                        style: TextStyle(
                                          color: black,
                                          fontFamily: 'PopR',
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${snapshot.data![index]['sludgeQuantityRecieved']}",
                                        style: TextStyle(
                                          color: black,
                                          fontFamily: 'PopM',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Average Capacity: ",
                                        style: TextStyle(
                                          color: black,
                                          fontFamily: 'PopR',
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${snapshot.data![index]['avgCapacity']}",
                                        style: TextStyle(
                                          color: black,
                                          fontFamily: 'PopM',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Source of Septage: ",
                                        style: TextStyle(
                                          color: black,
                                          fontFamily: 'PopR',
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${snapshot.data![index]['sourceOfSludge']}",
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: black,
                                            fontFamily: 'PopM',
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Desludge Operator: ",
                                        style: TextStyle(
                                          color: black,
                                          fontFamily: 'PopR',
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${snapshot.data![index]['operatorWithPpe']}",
                                        style: TextStyle(
                                          color: black,
                                          fontFamily: 'PopM',
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
