import 'package:flutter/material.dart';
import 'package:isc/screens/ticket_screen.dart';

import '../constants.dart';

Widget notificationCard(
      Size size, dynamic ownername, dynamic game, dynamic bookingId,BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => TicketScreen(bookingId)));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        width: size.width * 0.8,
        height: size.height * 0.09,
        child: Center(
            child: Text(
          '$ownername has invited you to play $game',
          style: TextStyle(fontSize: 15),
        )),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: kPrimaryLightColor,
              spreadRadius: 5,
              blurRadius: 8,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }

