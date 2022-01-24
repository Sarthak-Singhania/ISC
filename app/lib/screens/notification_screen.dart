import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isc/components/notification_card.dart';
import 'package:isc/constants.dart';
import 'package:http/http.dart' as http;
import 'package:isc/screens/ticket_screen.dart';
import 'package:isc/screens/user-info.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  dynamic pendingList = [];
  bool circP = true;
  bool emptyList = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    String currEmail = StudentInfo.emailId;
    String JWTtoken = StudentInfo.jwtToken;
    print(currEmail);
    var response =
        await http.get(Uri.parse(kIpAddress + '/pending/$currEmail'),headers: {
        "x-access-token":JWTtoken
      });
    var jsonData = await jsonDecode(response.body);
    print(jsonData);
    pendingList = jsonData["message"];
    if (pendingList.length == 0) {
      circP = false;
      emptyList = true;
      setState(() {});
    } else {
      circP = false;
      setState(() {});
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
              : Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            ListView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: pendingList.length,
                                itemBuilder: (context, index) {
                                  return notificationCard(
                                      size,
                                      pendingList[index]['First_name'],
                                      pendingList[index]['Game'],
                                      pendingList[index]['Booking_ID'],context);
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
