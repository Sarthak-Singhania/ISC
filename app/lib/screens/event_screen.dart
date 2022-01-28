import 'dart:convert';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:isc/components/bottom_navi_bar.dart';
import 'package:isc/components/event_card.dart';
import 'package:isc/constants.dart';
import 'package:isc/user-info.dart';

import 'notification_screen.dart';

class EventScreen extends StatefulWidget {
  EventScreen();

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List sports = [];
  List imgUri = [];
  bool isInternet = true;
  bool circP = true;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    StudentInfo.emailId = FirebaseAuth.instance.currentUser!.email!;
    StudentInfo.jwtToken =
        await FirebaseAuth.instance.currentUser!.getIdToken();
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(StudentInfo.emailId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      StudentInfo.name = data?['Name']; // <-- The value you want to retrieve.
      // Call setState if needed.
    }


    var response = await http.get(
      Uri.parse(kIpAddress + '/games'),
    );
    Map<String, dynamic> jsonData = await jsonDecode(response.body);
    print(response.statusCode);
    jsonData.forEach((k, v) {
      sports.add(k);
      imgUri.add(v);
    });
    // print(Sports);
    circP = false;
    print(StudentInfo.jwtToken);
    //print(ImgUri[2]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //getData();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: circP
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.blue,
            ))
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.purple[600]),
                    width: size.width,
                    height: size.height * 0.3,
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NotificationScreen()));
                            },
                            icon: Icon(
                              Icons.notifications,
                              size: 25,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                        Text(
                          "SELECT YOUR SPORT",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        GridView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio:
                                      StudentInfo.isAdmin ? 0.79 : 1,
                                  crossAxisCount: 2),
                          itemCount: sports.length,
                          itemBuilder: (context, index) {
                            return EventCard(
                              title: sports[index],
                              uri: imgUri[index],
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
      bottomNavigationBar: BottomNaviBar('event'),
    );
  }
}
