import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isc/routes.dart';
import 'package:isc/screens/admin_detail_screen.dart';
import 'package:isc/screens/user_detail_screen.dart';
import 'package:isc/user-info.dart';

class SlotCard extends StatelessWidget {
  String slotTime;
  Color? color;
   bool? isDisabled;
  SlotCard({required this.slotTime, required this.color,required this.isDisabled});

  //static int maxSlot = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        StudentInfo.slotChoosen = slotTime;
        if (StudentInfo.isAdmin) {
          if (isDisabled!) {
            Navigator.pushReplacementNamed(context, AppRoutes.adminDetail);
          } else {
            Fluttertoast.showToast(msg: "This slot is currently disabled");
          }
        } else {
          if (color == Colors.grey) {
            Fluttertoast.showToast(msg: "This slot is not available.");
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.studentDetail);
          }
        }
      },
      child: Container(
          height: size.height * 0.07,
          margin: EdgeInsets.only(
            top: size.width * 0.05,
            bottom: size.width * 0.05,
          ),
          padding: EdgeInsets.all(size.width * 0.04),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: color,
          ),
          child: Center(
            child: AutoSizeText(
              slotTime.toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          )),
    );
  }
}
