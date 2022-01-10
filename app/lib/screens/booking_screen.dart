import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isc/components/confirmed_booking.dart';
import 'package:isc/components/pending_booking.dart';
import 'package:isc/constants.dart';
import 'package:http/http.dart' as http;
import 'package:isc/screens/confirmed_screen.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  dynamic bookingList = [];
  bool circP = true;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    String currEmail = FirebaseAuth.instance.currentUser!.email!;
    print(currEmail);
    var response = await http
        .get(Uri.parse('http://65.0.232.165/get_bookings/${currEmail}'));
    var jsonData = await jsonDecode(response.body);
    print(jsonData);
    bookingList = jsonData["message"];
    print('yeh');
    print(bookingList[0]);
    circP = false;
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('BOOKINGS'),
        centerTitle: true,
      ),
      body: circP
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.blue,
            ))
          : ListView(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: bookingList.length,
                    itemBuilder: (context, index) {
                      return bookingList[index]['Confirm'] == 1
                          ? ConfirmBooking(
                              size: size,
                              date: bookingList[index]['Date'],
                              sportName: bookingList[index]['Game'],
                              bookingId: bookingList[index]['Booking_ID'],
                              studentName: bookingList[index]['Student_Name'],
                            )
                          : PendingBooking(
                              size: size,
                              date: bookingList[index]['Date'],
                              sportName: bookingList[index]['Game'],
                              bookingId: bookingList[index]['Booking_ID'],
                              studentName: bookingList[index]['Student_Name'],
                            );
                    })

                //PendingBooking(size: size),
              ],
            ),
    );
  }
}
