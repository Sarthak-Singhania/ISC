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
  bool circP = true;
  bool emptyList = false;
  late bool tapToRefresh;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    String currEmail = StudentInfo.emailId;
    String JWTtoken = StudentInfo.jwtToken;
    print(currEmail);
    try {
      var response = await http.get(
          Uri.parse(kIpAddress + '/get_bookings/$currEmail'),
          headers: {"x-access-token": JWTtoken});
      print("new ${response.statusCode}");
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
        tapToRefresh = false;
        setState(() {});
      }
    } catch (e) {
      circP = false;
      tapToRefresh = true;
      setState(() {});
      print(e);
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
              child: AutoSizeText(
              'No Booking found',
              style: TextStyle(fontSize: 20),
            ))
          : circP
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.blue,
                ))
              : tapToRefresh
                  ? GestureDetector(
                      onTap: () async {
                        if (!(await InternetConnectionChecker()
                            .hasConnection)) {
                          Fluttertoast.showToast(
                              msg: "Please check your internet connection");
                        } else {
                          circP = true;
                          tapToRefresh = false;
                          setState(() {});
                          getData();
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
                    )
                  : RefreshIndicator(
                      onRefresh: getData,
                      child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: bookingList.length,
                          itemBuilder: (context, index) {
                            return BookingCard(
                              isConfirm: bookingList[index]['Confirm'],
                              size: size,
                              date: bookingList[index]['Date'],
                              sportName: bookingList[index]['Game'],
                              bookingId: bookingList[index]['Booking_ID'],
                              studentName: bookingList[index]['Student_Name'],
                              totalCount: bookingList[index]['Count'],
                              slotTime: bookingList[index]['Slot'],
                            );
                          }),
                    ),
    );
  }
}
