import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isc/components/booking_card.dart';

import 'package:http/http.dart' as http;
import 'package:isc/constants.dart';
import 'package:isc/user-info.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  dynamic bookingList = [];

  bool emptyList = false;
  late Future myFuture;
  @override
  void initState() {
    super.initState();
    myFuture = getData();
  }

  Future<void> getData() async {
    String currEmail = StudentInfo.emailId;
    String JWTtoken = StudentInfo.jwtToken;
    print(currEmail);
    try {
      var response = await http.get(
          Uri.parse(kIpAddress + '/get_bookings/$currEmail'),
          headers: {"x-access-token": JWTtoken});
      var jsonData = await jsonDecode(response.body);
      print(jsonData);
      bookingList = jsonData["message"];
      if (bookingList.length == 0) {
        emptyList = true;
      } else {
        emptyList = false;
      }
    } catch (e) {
      print(e);
      return Future.error(e.toString());
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
        body: FutureBuilder(
            future: myFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return GestureDetector(
                  onTap: () async {
                    if (!(await InternetConnectionChecker().hasConnection)) {
                      Fluttertoast.showToast(
                          msg: "Please check your internet connection");
                    } else {
                      myFuture = getData();
                      setState(() {});
                    }
                  },
                  child: Container(
                      child: Center(
                          child: AutoSizeText(
                    "Tap To Refresh",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ))),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: Colors.purple,
                ));
              } else {
                return RefreshIndicator(
                  displacement: 100,
                  onRefresh: getData,
                  child: ListView(children: [
                    Column(children: [
                      emptyList == true
                          ? Column(
                              children: [
                                SizedBox(
                                  height: size.height * 0.4,
                                ),
                                AutoSizeText(
                                  'No Booking found',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: bookingList.length,
                              itemBuilder: (context, index) {
                                return BookingCard(
                                  isConfirm: bookingList[index]['Confirm'],
                                  size: size,
                                  date: bookingList[index]['Date'],
                                  sportName: bookingList[index]['Game'],
                                  bookingId: bookingList[index]['Booking_ID'],
                                  studentName: bookingList[index]
                                      ['Student_Name'],
                                  totalCount: bookingList[index]['Count'],
                                  slotTime: bookingList[index]['Slot'],
                                );
                              }),
                    ]),
                  ]),
                );
              }
            }));
  }
}
