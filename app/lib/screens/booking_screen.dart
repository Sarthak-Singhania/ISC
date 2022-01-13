import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isc/components/booking_card.dart';


import 'package:http/http.dart' as http;
import 'package:isc/constants.dart';


class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  dynamic bookingList = [];
  bool circP = true;
  bool emptyList = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    String currEmail = FirebaseAuth.instance.currentUser!.email!;
    print(currEmail);
    var response = await http
        .get(Uri.parse(kIpAddress+'/get_bookings/${currEmail}'));
    var jsonData = await jsonDecode(response.body);
    print(jsonData);
    bookingList = jsonData["message"];
    if (bookingList.length == 0) {
      circP = false;
      emptyList = true;
      setState(() {});
    } else {
      print('yeh');
      print(bookingList[0]);
      circP = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('BOOKINGS'),
        centerTitle: true,
      ),
      body: emptyList == true
          ? Center(
              child: Text(
              'No Booking found',
              style: TextStyle(fontSize: 20),
            ))
          : circP
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.blue,
                ))
              : RefreshIndicator(
                  onRefresh: getData,
                  child: ListView(
                    children: [
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: bookingList.length,
                          itemBuilder: (context, index) {
                            return 
                                 BookingCard(
                                    isConfirm:bookingList[index]['Confirm'],
                                    size: size,
                                    date: bookingList[index]['Date'],
                                    sportName: bookingList[index]['Game'],
                                    bookingId: bookingList[index]['Booking_ID'],
                                    studentName: bookingList[index]
                                        ['Student_Name'],
                                    totalCount: bookingList[index]['Count'],
                                    slotTime: bookingList[index]['Slot'],
                                  )
                              ;
                          })

                      //PendingBooking(size: size),
                    ],
                  ),
                ),
    );
  }
}
