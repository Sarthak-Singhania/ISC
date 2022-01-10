import 'package:flutter/material.dart';
import 'package:isc/screens/pending_screen.dart';

import '../constants.dart';

class PendingBooking extends StatelessWidget {
  final bookingId;

  final sportName;

  final studentName;

  final date;

 
  
  const PendingBooking({
    Key? key,
    required this.size,
    required this.bookingId,
    required this.sportName,
    required this.studentName,
    required this.date,


  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PendingScreen()));
      },
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.only(right: 10, left: 10),
        height: size.height * 0.17,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "PENDING",
              style:
                  TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
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
            Text(
              "$studentName + 69 others",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                  fontSize: 17),
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
