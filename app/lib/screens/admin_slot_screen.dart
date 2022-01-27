import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:isc/screens/user-info.dart';
// import 'package:switcher/core/switcher_size.dart';
// import 'package:switcher/switcher.dart';
import '../constants.dart';

class AdminSlotScreen extends StatefulWidget {
  const AdminSlotScreen({Key? key}) : super(key: key);

  @override
  _AdminSlotScreenState createState() => _AdminSlotScreenState();
}

class _AdminSlotScreenState extends State<AdminSlotScreen> {
  dynamic pendingList = [];
  bool emptyList = false;
  bool circP = true;
  bool toggleValue = false;

  TextEditingController slotNumberController =
      TextEditingController(text: '20');
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> disbaleSlot() async {
    final slotResponse = await http.get(
        Uri.parse(kIpAddress +
            "/booking-count?category=slot&game=" +
            StudentInfo.gameChoosen +
            "&date=" +
            StudentInfo.dateChoosen +
            "&slot=" +
            StudentInfo.slotChoosen),
        headers: {"x-access-token": StudentInfo.jwtToken});

    final responseJsonData = await jsonDecode(slotResponse.body);
    String slotsAvailable = responseJsonData['message'];
    bool isSlotAvailable = false;
    print("Sport ke slot = $slotsAvailable");
    if (slotsAvailable != '0') {
      isSlotAvailable = true;
    }
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: isSlotAvailable
                ? Text(
                    'There are some bookings for this slot.Do you want to still disable it?')
                : Text('Do you want to disable the slot?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  var body = jsonEncode({
                    "category": "slot",
                    "game": StudentInfo.gameChoosen,
                    "date": StudentInfo.dateChoosen,
                    "slot": StudentInfo.slotChoosen,
                  });
                  toggleValue = true;
                  setState(() {});
                  print(body);
                  try {
                    final disableResponse = await http.post(
                      Uri.parse(kIpAddress + '/stop'),
                      headers: {
                        'Content-Type': 'application/json',
                        'Accept': '*/*',
                        'Accept-Encoding': 'gzip, deflate, br',
                        'Access-Control-Allow-Origin': ' *',
                        "x-access-token": StudentInfo.jwtToken,
                        "admin-header": "YES"
                      },
                      body: body,
                    );

                    print(disableResponse.body);
                  } catch (e) {
                    print(e);
                  }
                  Navigator.of(context).pop();
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
  }

  void enableSlot() async {
    var body = jsonEncode({
      "category": "slot",
      "game": StudentInfo.gameChoosen,
      "date": StudentInfo.dateChoosen,
      "slot": StudentInfo.slotChoosen,
    });

    print(body);
    try {
      final response = await http.post(
        Uri.parse(kIpAddress + '/unstop'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Access-Control-Allow-Origin': ' *',
          "x-access-token": StudentInfo.jwtToken,
          "admin-header": "YES"
        },
        body: body,
      );
      toggleValue = false;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> getData() async {
    var response = await http.get(
        Uri.parse(kIpAddress +
            '/admin-bookings/${StudentInfo.gameChoosen}/${StudentInfo.dateChoosen}/${StudentInfo.slotChoosen}'),
        headers: {
          "x-access-token": StudentInfo.jwtToken,
          "admin-header": "YES"
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
          title: Text('BOOKINGS'),
        ),
        body: SafeArea(
          child: Center(
            child: circP
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.blue,
                  ))
                : Column(
                    children: [
                      SizedBox(height: size.height * 0.03),
                      Row(
                        children: [
                          Spacer(),
                          Container(
                            width: size.width * 0.25,
                            height: size.width * 0.15,
                            child: TextFormField(
                                controller: slotNumberController,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        color: Colors.purple, width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.purple, width: 1.5),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      left: 20), // add padding to adjust text
                                  suffixIcon: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                )),
                          ),
                          Spacer(
                            flex: 5,
                          ),
                          FlutterSwitch(
                            width: 70.0,
                            height: 35.0,
                            activeColor: Colors.red,
                            inactiveColor: Colors.green,
                            activeIcon: Icon(
                              Icons.lock_outlined,
                              size: 30,
                              color: Colors.red,
                            ),
                            inactiveIcon: Icon(
                              Icons.lock_outlined,
                              size: 30,
                              color: Colors.green,
                            ),
                            toggleSize: 25.0,
                            value: toggleValue,
                            borderRadius: 30.0,
                            padding: 5.0,
                            showOnOff: false,
                            onToggle: (state) {
                              setState(() {
                                if (state) {
                                  disbaleSlot();
                                } else {
                                  enableSlot();
                                }
                              });
                            },
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),
                      emptyList == true
                          ? Center(
                              child: Text(
                              'No bookings',
                              style: TextStyle(fontSize: 20),
                            ))
                          : Expanded(
                              child: ListView.builder(
                                  physics: ScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: pendingList.length,
                                  itemBuilder: (context, index) {
                                    return AdminSlotCard(
                                      size: size,
                                      bookingId: pendingList[index]
                                          ['Booking_ID'],
                                      studentName: pendingList[index]
                                          ['Student_Name'],
                                      snuId: pendingList[index]['SNU_ID'],
                                    );
                                  }),
                            ),
                    ],
                  ),
          ),
        ));
  }
}

class AdminSlotCard extends StatelessWidget {
  const AdminSlotCard(
      {Key? key,
      required this.size,
      required this.bookingId,
      required this.studentName,
      required this.snuId})
      : super(key: key);

  final Size size;
  final studentName;
  final snuId;
  final bookingId;

  Future<void> attendance(String attendance) async {
    var body = jsonEncode({
      "name":studentName,
      "snu_id": snuId,
      "booking_id": bookingId,
    });

    try {
      final response = await http.post(
        Uri.parse(kIpAddress + '/$attendance'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Access-Control-Allow-Origin': ' *',
          "x-access-token": StudentInfo.jwtToken,
          "admin-header": "YES"
        },
        body: body,
      );
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(left: 10, right: 10),
      width: size.width * 0.9,
      height: size.height * 0.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Student Name : $studentName',
                style: TextStyle(fontSize: 15),
              ),
              GestureDetector(
                onTap: () {
                  attendance("present");
                  Fluttertoast.showToast(
                      msg: "Student has been marked present ");
                },
                child: Text(
                  'Present',
                  style: TextStyle(fontSize: 15, color: Colors.green),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SNU ID: $snuId',
                style: TextStyle(fontSize: 15),
              ),
              GestureDetector(
                onTap: () {
                  attendance("absent");
                  Fluttertoast.showToast(msg: "Student has been marked absent");
                },
                child: Text(
                  'Absent',
                  style: TextStyle(fontSize: 15, color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: kPrimaryLightColor,
            spreadRadius: 5,
            blurRadius: 8,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
