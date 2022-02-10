import 'dart:convert';
import 'dart:io';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isc/components/admin_eventcard.dart';
import 'package:isc/components/event_card.dart';
import 'package:isc/constants.dart';
import 'package:isc/provider/theme_provider.dart';
import 'package:isc/routes.dart';
import 'package:isc/user-info.dart';
import 'package:provider/provider.dart';

class EventScreen extends StatefulWidget {
  EventScreen();

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool isInternet = true;
  late final jsonData;
  bool circP = true;
  late bool tapToRefresh;
  int notificationListLength = 0;
  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: kSessionExpireTimeout), () async {
    //   print("hgya");
    //   await FirebaseAuth.instance.signOut();
    //   Navigator.pushNamedAndRemoveUntil(
    //       context, AppRoutes.homeScreen, (route) => false);
    // });
    getData();
  }

  void getData() async {
    StudentInfo.emailId = FirebaseAuth.instance.currentUser!.email!;
    StudentInfo.jwtToken =
        await FirebaseAuth.instance.currentUser!.getIdToken();
    print(StudentInfo.jwtToken);

    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(StudentInfo.emailId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      StudentInfo.name = data?['Name'];
    }
    String adminheader;
    if (StudentInfo.isAdmin) {
      adminheader = 'yes';
    } else {
      adminheader = 'no';
    }
    print(adminheader);
    try {
      var response = await http.get(Uri.parse(kIpAddress + '/games'), headers: {
        "x-access-token": StudentInfo.jwtToken,
        "admin-header": adminheader
      });
      jsonData = (await jsonDecode(response.body))['message'];
      print(jsonData);
      var notificationResponse = await http.get(
          Uri.parse(kIpAddress + '/pending/${StudentInfo.emailId}'),
          headers: {"x-access-token": StudentInfo.jwtToken});
      var notificationJsonData = await jsonDecode(notificationResponse.body);
      notificationListLength = notificationJsonData["message"].length;

      for (var i = 0; i < jsonData.length; i++) {
        print(jsonData[i]['info']);
        // print(jsonData[i]['url']);
      }
      circP = false;
      tapToRefresh = false;
      setState(() {});
    } catch (e) {
      circP = false;
      tapToRefresh = true;
      setState(() {});
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //getData();
    final theme = Provider.of<ThemeProvider>(context);
    Size size = MediaQuery.of(context).size;
    return circP
        ? Scaffold(
            body: Center(
                child: CircularProgressIndicator(
            color: Colors.blue,
          )))
        : tapToRefresh
            ? GestureDetector(
                onTap: () async {
                  if (!(await InternetConnectionChecker().hasConnection)) {
                    Fluttertoast.showToast(
                        msg: "Please check your internet connection");
                  } else {
                    circP = true;
                    tapToRefresh = false;
                    setState(() {});
                    getData();
                  }
                },
                child: Scaffold(
                  body: Container(
                      child: Center(
                          child: AutoSizeText(
                    "Tap To Refresh",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ))),
                ),
              )
            : Scaffold(
                body: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: Colors.purple[600]),
                        width: size.width,
                        height: size.height * 0.35,
                      ),
                      SafeArea(
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            Container(
                                child: Row(
                              children: [
                                Spacer(
                                  flex: 3,
                                ),
                                AutoSizeText(
                                  'SELECT YOUR SPORT',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                                !StudentInfo.isAdmin
                                    ? Container(
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: IconButton(
                                                color: Colors.white,
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context,
                                                      AppRoutes
                                                          .notificationScreen);
                                                },
                                                icon: Icon(
                                                  Icons.notifications,
                                                  size: size.width * 0.07,
                                                ),
                                              ),
                                            ),
                                            notificationListLength > 0
                                                ? Positioned(
                                                    top: 5,
                                                    right: 8,
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.red),
                                                      child: Center(
                                                        child: AutoSizeText(
                                                          '$notificationListLength',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10),
                                                        ),
                                                      ),
                                                    ))
                                                : Container()
                                          ],
                                        ),
                                      )
                                    : Spacer()
                              ],
                            )),
                            SizedBox(
                              height: size.height * 0.06,
                            ),
                            GridView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio:
                                          StudentInfo.isAdmin ? 0.79 : 1,
                                      crossAxisCount: 2),
                              itemCount: jsonData.length,
                              itemBuilder: (context, index) {
                                return StudentInfo.isAdmin
                                    ? AdminEventCard(
                                        title: jsonData[index]['game'],
                                        uri: jsonData[index]['url'],
                                        isEnabled: jsonData[index]['isEnabled'],
                                      )
                                    : EventCard(
                                        title: jsonData[index]['game'],
                                        uri: jsonData[index]['url'],
                                        info: jsonData[index]['info']);
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // bottomNavigationBar: BottomNaviBar('event'),
              );
  }
}
