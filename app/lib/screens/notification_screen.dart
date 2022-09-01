import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isc/components/notification_card.dart';
import 'package:isc/constants.dart';
import 'package:http/http.dart' as http;
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
  bool emptyList = false;
  // late final notificationJsonData;
  late Future myFuture;
  @override
  void initState() {
    super.initState();
    myFuture = getData();
  }

  Future<void> getData() async {
    try {
      var notificationResponse = await http.get(
          Uri.parse(kIpAddress + '/pending/${StudentInfo.emailId}'),
          headers: {"x-access-token": StudentInfo.jwtToken});
      var notificationJsonData = await jsonDecode(notificationResponse.body);

      print(notificationJsonData);
      pendingList = notificationJsonData["message"];
      print(pendingList);
      if (pendingList.length == 0) {
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
            centerTitle: true, title: Text('Notifications'), actions: []),
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
                        setState(() {
                          myFuture = getData();
                        });
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
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return  Center(
                child: CircularProgressIndicator(
                color: Colors.purple,
              ));
                    } else {
                      return RefreshIndicator(
                        onRefresh: getData,
                        child: ListView(children: [
                          emptyList == true
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.4,
                                    ),
                                    AutoSizeText(
                                      'No new notifications',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: pendingList.length,
                                  itemBuilder: (context, index) {
                                    return NotificationCard(
                                        username: pendingList[index]
                                            ['First_name'],
                                        game: pendingList[index]['Game'],
                                        bookingId: pendingList[index]
                                            ['Booking_ID']);
                                  }),
                        ]),
                      );
                    }
                  }));
  }
}
