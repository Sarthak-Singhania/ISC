import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isc/routes.dart';

import '../constants.dart';

class BookingCard extends StatelessWidget {
  const BookingCard(
      {Key? key,
      required this.isConfirm,
      required this.size,
      required this.bookingId,
      required this.sportName,
      required this.studentName,
      required this.date,
      required this.totalCount,
      required this.slotTime})
      : super(key: key);

  final Size size;
  final bookingId;
  final isConfirm;
  final slotTime;

  final sportName;

  final studentName;
  final totalCount;
  final date;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        bool hasInternet = await InternetConnectionChecker().hasConnection;
          Navigator.pushReplacementNamed(context, AppRoutes.ticketScreen,
              arguments: bookingId);
      },
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.only(right: 10, left: 10),
        height: size.height * 0.15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            isConfirm == 1
                ? AutoSizeText(
                    "CONFIRMED",
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  )
                : AutoSizeText(
                    "PENDING",
                    style: TextStyle(
                        color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  "Booking Id: $bookingId",
                  style: TextStyle(color: Colors.grey),
                ),
                AutoSizeText(
                  "Date: $date",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  sportName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MediaQuery.of(context).platformBrightness == Brightness.light?
                          kPrimaryColor: Colors.white, //kPrimaryColor
                      fontSize: 17),
                ),
                AutoSizeText(
                  slotTime,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MediaQuery.of(context).platformBrightness == Brightness.light?
                          kPrimaryColor: Colors.white,
                      fontSize: 16),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  totalCount == 1
                      ? "$studentName"
                      : totalCount == 2
                          ? "$studentName +1 other"
                          : "$studentName +${int.parse(totalCount) - 1} others",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MediaQuery.of(context).platformBrightness == Brightness.light?
                          kPrimaryColor: Colors.white,
                      fontSize: 17),
                ),
              ],
            )
          ],
        ),
        width: size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: MediaQuery.of(context).platformBrightness == Brightness.light?kPrimaryLightColor: Colors.purple.shade600,
               //kPrimaryLightColor
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
