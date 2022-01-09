import 'package:flutter/material.dart';
import 'package:isc/screens/detail_screen.dart';

class SlotCard extends StatelessWidget {
  String slt_time;
  Color? color;
  var slotAvailable;
  SlotCard(this.slt_time, this.color, this.slotAvailable);
  static String sltChoosen = '';
  static String dateChoosen = '';
  static int maxSlot = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        sltChoosen = slt_time;
        maxSlot = slotAvailable;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return DetailScreen();
          }),
        );
      },
      child: Container(
          margin: EdgeInsets.all(size.width * 0.05),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                slt_time,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              Icon(
                Icons.navigate_next,
                color: Colors.white,
              )
            ],
          )),
    );
  }
}
