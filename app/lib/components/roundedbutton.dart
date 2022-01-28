import 'package:flutter/material.dart';
import 'package:isc/constants.dart';
import 'package:isc/screens/login_screen.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {Key? key, this.s, this.color, this.tcolor, this.func, this.size})
      : super(key: key);
  final s;
  final color;
  final tcolor;
  final func;
  final size;

  @override
  Widget build(BuildContext context) {
  
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
}
