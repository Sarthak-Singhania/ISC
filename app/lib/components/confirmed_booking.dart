import 'package:flutter/material.dart';
import 'package:isc/screens/confirmed_screen.dart';

import '../constants.dart';

class ConfirmBooking extends StatelessWidget {
  const ConfirmBooking({
    Key? key,
    required this.size,
    required this.bookingId,
    required this.sportName,
    required this.studentName,
    required this.date,
  }) : super(key: key);

  final Size size;
  final bookingId;

  final sportName;

  final studentName;

  final date;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ConfirmedScreen()));
      },
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.only(right: 10, left: 10),
        height: size.height * 0.15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "CONFIRMED",
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Booking Id: $bookingId",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  "Date: $date",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Text(
              sportName,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                  fontSize: 17),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$studentName + 69 others",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                      fontSize: 17),
                ),
              ],
            )
          ],
        ),
        width: size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: kPrimaryLightColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 2.0), //(x,y)
              blurRadius: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}
