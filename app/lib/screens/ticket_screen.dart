import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isc/constants.dart';
import 'package:isc/provider/theme_provider.dart';
import 'package:isc/user-info.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class TicketScreen extends StatefulWidget {
  TicketScreen({this.bookingId});
  final bookingId;

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late String currEmail;
  late String jwtToken;
  bool circP = true;
  bool secondCircP = false;
  late bool hasInternet;
  late bool tapToRefresh;
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
    currEmail = StudentInfo.emailId;
    jwtToken = StudentInfo.jwtToken;
    try {
      var json = await http.get(
          Uri.parse(
              kIpAddress + '/get_bookings/$currEmail/${widget.bookingId}'),
          headers: {"x-access-token": jwtToken});
      response = jsonDecode(json.body);
      var list = response['name'];
      for (var i = 0; i < list.length; i++) {
        nameList[i] = list[i];
        sNo[i] = '${i + 1}';
      }
      circP = false;
      tapToRefresh = false;
      print(response);
      setState(() {});
    } catch (e) {
      circP = false;
      tapToRefresh = true;
      setState(() {});
      print(e);
    }
  }

  void acceptResponse() async {
    var body =
        jsonEncode({"snu_id": currEmail, "booking_id": widget.bookingId});
    try {
      final acceptResponse = await http.post(
        Uri.parse(kIpAddress + '/confirm'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Access-Control-Allow-Origin': ' *',
          "x-access-token": jwtToken
        },
        body: body,
      );

      print(acceptResponse.body);
      secondCircP = false;
      Fluttertoast.showToast(msg: "BOOKING CONFIRMED");
      setState(() {
        getData();
      });
    } catch (e) {
      secondCircP = false;
      bool hasInternet = await InternetConnectionChecker().hasConnection;
      if (!hasInternet) {
        Fluttertoast.showToast(msg: "Please check your internet connection");
      } else {
        Fluttertoast.showToast(msg: "Something went wrong.Please retry.");
      }
      print(e);
      setState(() {});
    }
  }

  void cancelResponse() async {
    var body =
        jsonEncode({"snu_id": currEmail, "booking_id": widget.bookingId});
    try {
      final acceptResponse = await http.post(
        Uri.parse(kIpAddress + '/cancel'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Access-Control-Allow-Origin': ' *',
          "x-access-token": jwtToken
        },
        body: body,
      );
      print(acceptResponse.body);
      secondCircP = false;
      Fluttertoast.showToast(msg: "BOOKING CANCELLED");

      Navigator.of(context).pop();
    } catch (e) {
      secondCircP = false;
      bool hasInternet = await InternetConnectionChecker().hasConnection;
      if (!hasInternet) {
        Fluttertoast.showToast(msg: "Please check your internet connection");
      } else {
        Fluttertoast.showToast(msg: "Something went wrong.Please retry.");
      }
      print(e);
      setState(() {});
    }
  }

  void rejectResponse() async {
    var body =
        jsonEncode({"snu_id": currEmail, "booking_id": widget.bookingId});
    try {
      final acceptResponse = await http.post(
        Uri.parse(kIpAddress + '/reject'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Access-Control-Allow-Origin': ' *',
          "x-access-token": jwtToken
        },
        body: body,
      );

      print(acceptResponse.body);
      secondCircP = false;
      Fluttertoast.showToast(msg: "BOOKING REQUEST REJECTED");
      Navigator.pop(context);
    } catch (e) {
      secondCircP = false;
      bool hasInternet = await InternetConnectionChecker().hasConnection;
      if (!hasInternet) {
        Fluttertoast.showToast(msg: "Please check your internet connection");
      } else {
        Fluttertoast.showToast(msg: "Something went wrong.Please retry.");
      }
      print(e);
      setState(() {});
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
              AutoSizeText(
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
                      color: Color(0xFF5A62B0),
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(10, 10))),
                  child: Center(
                    child: AutoSizeText(
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
                              secondCircP = true;
                              setState(() {});
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
                  child: AutoSizeText(
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
              onTap: () async {
                secondCircP = true;
                setState(() {});
                rejectResponse();
              },
              child: Container(
                height: size.height * 0.08,
                child: Center(
                  child: AutoSizeText(
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
              onTap: () async {
                secondCircP = true;
                setState(() {});
                acceptResponse();
              },
              child: Container(
                height: size.height * 0.08,
                child: Center(
                  child: AutoSizeText(
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
    ThemeProvider theme = Provider.of<ThemeProvider>(context);

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
                      ? AutoSizeText(
                          'Confirmed',
                          style:
                              TextStyle(color: Color(0xff289800), fontSize: 25),
                        )
                      : AutoSizeText(
                          'Pending',
                          style:
                              TextStyle(color: Color(0xffFF6109), fontSize: 25),
                        ),
                  backgroundColor:
                      theme.checkTheme(Colors.white, Colors.black, context),
                ),
                body: Stack(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.fromLTRB(0, 60, 0, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  "Booking Id: ${widget.bookingId}",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                ),
                                Spacer(),
                                AutoSizeText(
                                  "Date:${response['date']}",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
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
                                AutoSizeText(
                                  '${response['game']}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Spacer(),
                                FadeInImage.memoryNetwork(
                                  image: '${response['url']}',
                                  placeholder: kTransparentImage,
                                ),
                                AutoSizeText(
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
                                        child: AutoSizeText(
                                      'S No.',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: theme.checkTheme(
                                                Colors.black,
                                                Colors.white,
                                                context),
                                            width: 1),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15))),
                                  ),
                                  Container(
                                    child: Center(
                                        child: AutoSizeText(
                                      'Name',
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    height: size.height * 0.1,
                                    width: size.width * 0.7,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: theme.checkTheme(
                                                Colors.black,
                                                Colors.white,
                                                context),
                                            width: 1),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        AutoSizeText(sNo[0],
                                            style: TextStyle(fontSize: 20)),
                                        AutoSizeText(sNo[1],
                                            style: TextStyle(fontSize: 20)),
                                        AutoSizeText(sNo[2],
                                            style: TextStyle(fontSize: 20)),
                                        AutoSizeText(sNo[3],
                                            style: TextStyle(fontSize: 20)),
                                      ],
                                    ),
                                    height: size.height * 0.35,
                                    width: size.width * 0.2,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: theme.checkTheme(
                                                Colors.black,
                                                Colors.white,
                                                context),
                                            width: 1),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(15))),
                                  ),
                                  Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        AutoSizeText(nameList[0],
                                            style: TextStyle(fontSize: 20)),
                                        AutoSizeText(nameList[1],
                                            style: TextStyle(fontSize: 20)),
                                        AutoSizeText(nameList[2],
                                            style: TextStyle(fontSize: 20)),
                                        AutoSizeText(nameList[3],
                                            style: TextStyle(fontSize: 20)),
                                      ],
                                    ),
                                    height: size.height * 0.35,
                                    width: size.width * 0.7,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: theme.checkTheme(
                                                Colors.black,
                                                Colors.white,
                                                context),
                                            width: 1),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(15))),
                                  )
                                ],
                              ),
                            ],
                          ),
                          secondLast(context),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          lastWidget(context),
                        ],
                      ),
                    ),
                    secondCircP == true
                        ? Center(
                            child: CircularProgressIndicator(
                            color: Colors.blue,
                          ))
                        : Container()
                  ],
                ));
  }
}
