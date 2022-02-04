import 'package:flutter/material.dart';
import 'package:isc/routes.dart';
import 'package:isc/screens/admin_detail_screen.dart';
import 'package:isc/screens/detail_screen.dart';
import 'package:isc/user-info.dart';

class SlotCard extends StatelessWidget {
  String slotTime;
  Color? color;

  SlotCard({required this.slotTime, required this.color});

  //static int maxSlot = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        StudentInfo.slotChoosen = slotTime;
        if (StudentInfo.isAdmin) {
          Navigator.pushReplacementNamed(context, AppRoutes.adminDetail);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.studentDetail);
        }
      },
      child: Container(
          margin: EdgeInsets.only(
              top: size.width * 0.05,
              bottom: size.width * 0.05,
              left: size.width * 0.1,
              right: size.width * 0.1),
          padding: EdgeInsets.all(size.width * 0.04),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: color,
          ),
          child: Center(
            child: Text(
              slotTime.toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          )),
    );
  }
}
