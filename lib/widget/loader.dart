import 'package:flutter/material.dart';

import '../constants/color_const.dart';

showLoaderDialog(BuildContext context, text, int delay) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(
          color: primaryColor,
          backgroundColor: secondColor.withOpacity(0.3),
        ),
        SizedBox(
          width: 20,
        ),
        Container(
          margin: EdgeInsets.only(left: 7),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'PopM',
              color: black,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: delay), () {
        // Navigator.of(context).pop(true);
      });
      return alert;
    },
  );
}
