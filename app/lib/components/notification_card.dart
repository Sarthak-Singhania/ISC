import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:isc/routes.dart';

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
          Navigator.pushReplacementNamed(context, AppRoutes.ticketScreen,
              arguments: bookingId);
      },
      child: Container(
        margin: EdgeInsets.all(10),
        width: size.width * 0.8,
        height: size.height * 0.09,
        child: Center(
            child: AutoSizeText(
          '$username has invited you to play $game',
          style: TextStyle(
            fontSize: 15,
            color:MediaQuery.of(context).platformBrightness == Brightness.light?kPrimaryColor: Colors.white,
          ),
        )),
        decoration: BoxDecoration(
          color: MediaQuery.of(context).platformBrightness == Brightness.light?
              kPrimaryLightColor: Colors.purple.shade600,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 2.0), //(x,y)
              blurRadius: 5.0,
            ),
          ],
        ),
      ),
    );
  }
}
