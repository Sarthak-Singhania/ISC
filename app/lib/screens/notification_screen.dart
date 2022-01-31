import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isc/components/notification_card.dart';
import 'package:isc/constants.dart';
import 'package:http/http.dart' as http;
import 'package:isc/screens/ticket_screen.dart';
import 'package:isc/user-info.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  dynamic pendingList = [];
  bool circP = true;
  bool emptyList = false;
  late final notificationJsonData;
  late bool tapToRefresh;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      var notificationResponse = await http.get(
          Uri.parse(kIpAddress + '/pending/${StudentInfo.emailId}'),
          headers: {"x-access-token": StudentInfo.jwtToken});
      notificationJsonData = await jsonDecode(notificationResponse.body);

      print(notificationJsonData);
      pendingList = notificationJsonData["message"];
      if (pendingList.length == 0) {
        circP = false;
        emptyList = true;
        tapToRefresh = false;
        setState(() {});
      } else {
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
        centerTitle: true,
        title: Text('Notifications'),
      ),
      body: emptyList == true
          ? Center(
              child: Text(
              'No new notifications',
              style: TextStyle(fontSize: 20),
            ))
          : circP
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.blue,
                ))
          :tapToRefresh?GestureDetector(
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
                          color: Colors.white,
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                              child: Text(
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
                    shrinkWrap: true,
                    itemCount: pendingList.length,
                    itemBuilder: (context, index) {
                      return NotificationCard(
                          username: pendingList[index]['First_name'],
                          game: pendingList[index]['Game'],
                          bookingId: pendingList[index]['Booking_ID']);
                    }),
              ),
    );
  }
}
