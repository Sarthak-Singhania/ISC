import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isc/routes.dart';
import 'package:isc/screens/ticket_screen.dart';

import '../constants.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({Key? key, this.username, this.game, this.bookingId})
      : super(key: key);
  final game;
  final username;
  final bookingId;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async {
        bool hasInternet = await InternetConnectionChecker().hasConnection;
        if (hasInternet) {
          Navigator.pushReplacementNamed(context, AppRoutes.ticketScreen,arguments: bookingId);
        } else {
          Fluttertoast.showToast(msg: "Please check your internet connection");
        }
      },
      child: Container(
        margin: EdgeInsets.all(10),
        width: size.width * 0.8,
        height: size.height * 0.09,
        child: Center(
            child: Text(
          '$username has invited you to play $game',
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
}
