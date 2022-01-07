import 'package:flutter/material.dart';
import 'package:isc/constants.dart';
import 'package:isc/screens/login_screen.dart';

Container RoundedButton(String s, Color color, Color tcolor, Size size,
    Function func, BuildContext context) {
  return Container(
    margin: EdgeInsets.all(5),
    child: ElevatedButton(
        child: Text(s),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(
            size.width * 0.8,
            size.height * 0.1,
          ),
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          onPrimary: tcolor,
          primary: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        ),
        onPressed: () {
          func();
        }),
  );
}
