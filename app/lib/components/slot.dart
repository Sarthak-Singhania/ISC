import 'package:flutter/material.dart';
import 'package:isc/routes.dart';
import 'package:isc/screens/admin_slot_screen.dart';
import 'package:isc/screens/detail_screen.dart';
import 'package:isc/user-info.dart';

class SlotCard extends StatelessWidget {
  String slotTime;
  Color? color;
  var slotAvailable;

  SlotCard({required this.slotTime, this.color, this.slotAvailable});

  static int maxSlot = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        StudentInfo.slotChoosen = slotTime;
        maxSlot = slotAvailable;
        if (StudentInfo.isAdmin) {
          Navigator.pushReplacementNamed(context, AppRoutes.adminSlot);
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
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.white70.withOpacity(0.5),
            //     spreadRadius: 5,
            //     blurRadius: 50,
            //     offset: Offset(0, 17), // changes position of shadow
            //   ),
            // ],
          ),
          child: Row(
            children: [
              Spacer(
                flex: 1,
              ),
              Text(
                slotTime.toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              Spacer(),
              Icon(
                Icons.navigate_next,
                color: Colors.white,
              )
            ],
          )),
    );
  }
}
