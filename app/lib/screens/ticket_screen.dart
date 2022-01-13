import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:isc/constants.dart';
import 'package:transparent_image/transparent_image.dart';



class TicketScreen extends StatefulWidget {
  TicketScreen(this.bookingId);
  final bookingId;

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  String currEmail = '';
  bool circP = true;
  var response;
  var sNo;
  var nameList;
  @override
  void initState() {
    super.initState();
    sNo = ['', '', '', ''];
    nameList = ['', '', '', ''];
    getData();
  }

  void getData() async {
    currEmail = FirebaseAuth.instance.currentUser!.email!;
    print(currEmail);
    var json = await http.get(Uri.parse(
        kIpAddress+'/get_bookings/${currEmail}/${widget.bookingId}'));
    response = jsonDecode(json.body);
    var list = response['name'];
    for (var i = 0; i < list.length; i++) {
      nameList[i] = list[i];
      sNo[i] = '${i + 1}';
    }
    circP = false;
    print(response);
    setState(() {});
  }

  void acceptResponse() async {
    var body =
        jsonEncode({"snu_id": currEmail, "booking_id": widget.bookingId});
    try {
      final acceptResponse = await http.post(
        Uri.parse(kIpAddress+'/confirm'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Access-Control-Allow-Origin': ' *'
        },
        body: body,
      );

      print(acceptResponse.body);
      Fluttertoast.showToast(msg: "BOOKING CONFIRMED");
      setState(() {
        getData();
      });
    } catch (e) {
      print(e);
    }
  }

  void cancelResponse() async {
    var body =
        jsonEncode({"snu_id": currEmail, "booking_id": widget.bookingId});
    try {
      final acceptResponse = await http.post(
        Uri.parse(kIpAddress+'/cancel'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Access-Control-Allow-Origin': ' *'
        },
        body: body,
      );
      print(acceptResponse.body);
      Fluttertoast.showToast(msg: "BOOKING CANCELLED");

      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  void rejectResponse() async {
    var body =
        jsonEncode({"snu_id": currEmail, "booking_id": widget.bookingId});
    try {
      final acceptResponse = await http.post(
        Uri.parse(kIpAddress+'/reject'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Access-Control-Allow-Origin': ' *'
        },
        body: body,
      );

      print(acceptResponse.body);
      Fluttertoast.showToast(msg: "BOOKING REQUEST REJECTED");
      setState(() {
        getData();
      });
    } catch (e) {
      print(e);
    }
  }

  Widget secondLast(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (response['confirm'] == 1) {
      return Expanded(
        child: Container(
          padding: EdgeInsets.only(left: 20),
          width: size.width * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.05,
              ),
              Text(
                '       ',
                style: TextStyle(
                  fontSize: size.height * 0.03,
                  color: Colors.grey,
                ),
              )
            ], //ADD MEMBER WALI JAGAH
          ),
        ),
      );
    } else {
      return Expanded(
        child: Container(
          height: size.height * 0.5,
          child: Stack(
            children: [
              Positioned(
                bottom: 15,
                left: 25,
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: size.width * 0.8,
                  height: size.width * 0.17,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(-10.0, 5.0), //(x,y)
                          blurRadius: 10.0,
                        ),
                      ],
                      color: Color(0xFF5A62B0),
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(10, 10))),
                  child: Center(
                    child: Text(
                      '${nameList[0]} has added you to the booking',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 1,
                left: 40,
                child: ClipPath(
                  clipper: TriangleClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF5A62B0),
                    ),
                    height: 15,
                    child: Text('    '),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  Widget lastWidget(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (response['confirm'] == 1) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(
                            'Are you sure you want to cancel the booking?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                               Navigator.of(context).pop();
                              cancelResponse();
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    });
              },
              child: Container(
                height: size.height * 0.08,
                child: Center(
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0XFFFF0000),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, -3.0), //(x,y)
                      blurRadius: 5.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                rejectResponse();
              },
              child: Container(
                height: size.height * 0.08,
                child: Center(
                  child: Text(
                    'Deny',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0XFFFF0000),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, -3.0), //(x,y)
                      blurRadius: 5.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                acceptResponse();
              },
              child: Container(
                height: size.height * 0.08,
                child: Center(
                  child: Text(
                    'Accept',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0XFF00FF19),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, -3.0), //(x,y)
                      blurRadius: 5.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return circP
        ? Scaffold(
            body: Center(
                child: CircularProgressIndicator(
            color: Colors.blue,
          )))
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: response['confirm'] == 1
                  ? BackButton(
                      color: Color(0xff289800),
                    )
                  : BackButton(
                      color: Color(0xffFF6109),
                    ),
              title: response['confirm'] == 1
                  ? Text(
                      'Confirmed',
                      style: TextStyle(color: Color(0xff289800), fontSize: 25),
                    )
                  : Text(
                      'Pending',
                      style: TextStyle(color: Color(0xffFF6109), fontSize: 25),
                    ),
              backgroundColor: Colors.white,
            ),
            body: Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.fromLTRB(0, 60, 0, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Booking Id: ${widget.bookingId}",
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        Spacer(),
                        Text(
                          "Date:${response['date']}",
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${response['game']}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Spacer(),
                        FadeInImage.memoryNetwork(
                          image: '${response['url']}',
                          placeholder: kTransparentImage,
                        ),
                        Text(
                          "${response['slot']}".toUpperCase(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height * 0.1,
                            width: size.width * 0.2,
                            child: Center(
                                child: Text(
                              'S No.',
                              style: TextStyle(fontSize: 20),
                            )),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15))),
                          ),
                          Container(
                            child: Center(
                                child: Text(
                              'Name',
                              style: TextStyle(fontSize: 20),
                            )),
                            height: size.height * 0.1,
                            width: size.width * 0.7,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15))),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(sNo[0], style: TextStyle(fontSize: 20)),
                                Text(sNo[1], style: TextStyle(fontSize: 20)),
                                Text(sNo[2], style: TextStyle(fontSize: 20)),
                                Text(sNo[3], style: TextStyle(fontSize: 20)),
                              ],
                            ),
                            height: size.height * 0.35,
                            width: size.width * 0.2,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15))),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(nameList[0],
                                    style: TextStyle(fontSize: 20)),
                                Text(nameList[1],
                                    style: TextStyle(fontSize: 20)),
                                Text(nameList[2],
                                    style: TextStyle(fontSize: 20)),
                                Text(nameList[3],
                                    style: TextStyle(fontSize: 20)),
                              ],
                            ),
                            height: size.height * 0.35,
                            width: size.width * 0.7,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(15))),
                          )
                        ],
                      ),
                    ],
                  ),

                  secondLast(context),

                  // Stack(alignment: Alignment.center, children: [
                  //   Container(
                  //     decoration: BoxDecoration(
                  //         color: Color(0xFFFFFF),
                  //         borderRadius: BorderRadius.only(
                  //           topLeft: Radius.elliptical(10, 10),
                  //           topRight: Radius.elliptical(10, 10),
                  //           bottomLeft: Radius.elliptical(0, 0),
                  //           bottomRight: Radius.elliptical(10, 10),
                  //         )),
                  //     margin: EdgeInsets.only(top: 5, left: 12),
                  //     //padding: EdgeInset.only(left: 5, right: 10),
                  //     alignment: Alignment.topLeft,
                  //     child: SimpleShadow(
                  //       child: SvgPicture.network(
                  //           'lib/assets/images/Group 1.png'), //Image.asset('lib/assets/images/Group 3.png'),
                  //       opacity: 0.8, // Default: 0.5
                  //       color: Colors.black, // Default: Black
                  //       offset: Offset(5, 5), // Default: Offset(2, 2)
                  //       sigma: 7, // Default: 2
                  //     ),
                  //   ),
                  //   Container(
                  //     alignment: Alignment.topLeft,
                  //     width: size.width * 0.8,
                  //     child: Text('Sarthak Singhania has added you to the booking',
                  //         style: TextStyle(color: Colors.white, fontSize: 15)),
                  //   ),
                  // ]),

                  SizedBox(
                    height: size.height * 0.01,
                  ),

                  lastWidget(context),
                ],
              ),
            ),
          );
  }
}