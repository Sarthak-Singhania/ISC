import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:isc/components/roundedbutton.dart';
import 'package:isc/components/slot_card.dart';
import 'package:isc/components/student_detail.dart';
import 'package:isc/constants.dart';
import 'package:isc/routes.dart';

import 'package:isc/user-info.dart';
import 'booking_screen.dart';

import 'package:http/http.dart' as http;
import 'admin_time_slot.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController? firstNameController;
  final _formKey = GlobalKey<FormState>();
  String firstName = '';
  bool circP = true;
  TextEditingController? firstEmailController;
  String currEmail = '';
  late int maxLength;
  dynamic rollNo;
  String date = '';
  var _controller = List.generate(StudentInfo.dayChoosen.length,
      (i) => List.generate(8, (j) => TextEditingController()),
      growable: false);
  var length = List<int>.filled(StudentInfo.dayChoosen.length, 1);
  var slotsRemaining = List<int>.filled(StudentInfo.dayChoosen.length, 0);
  var downArrow = List<bool>.filled(StudentInfo.dayChoosen.length, true);
  // List<TextEditingController> _controller = List.generate(
  //     8,
  //     (i) =>
  //         TextEditingController()); //TODO: dynamica krna acooridng to sum of max slots allowed

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void postData() async {
    for (var i = 0; i < length.length; i++) {
      for (var j = 0; j < length[j] * 2; j++) {
        print(_controller[i][j].text);
        print(_controller[i][j + 1].text);
      }
    }

    // String JWTtoken = StudentInfo.jwtToken;
    // Map<String, dynamic> mp = {};
    // mp.putIfAbsent(firstNameController!.text, () => currEmail);
    // for (var i = 0; i < (length * 2); i = i + 2) {
    //   mp.putIfAbsent(_controller[i].text, () => _controller[i + 1].text);
    // }

    // var body = jsonEncode({
    //   "sports_name": StudentInfo.gameChoosen,
    //   "date": StudentInfo.dateChoosen,
    //   "slot": StudentInfo.slotChoosen,
    //   "student_details": mp,
    // });

    // print(body);
    // try {
    //   final response = await http.post(
    //     Uri.parse(kIpAddress + '/book'),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': '*/*',
    //       'Accept-Encoding': 'gzip, deflate, br',
    //       'Access-Control-Allow-Origin': ' *',
    //       "x-access-token": JWTtoken,
    //     },
    //     body: body,
    //   );
    //   print("Hello ${response.statusCode}");
    //   Map jsonData = await jsonDecode(response.body);
    //   print("details");
    //   print(jsonData);
    //   circP = false;
    //   setState(() {});
    //   if (jsonData['status'] == 'confirmed') {
    //     Fluttertoast.showToast(msg: "YOUR DETAILS HAS BEEN SUBMITTED ");
    //     Future.delayed(Duration(milliseconds: 2000), () {});
    //     Navigator.pushReplacementNamed(context, AppRoutes.bookingsScreen);
    //   } else if (jsonData['status'] == 'duplicate') {
    //     Fluttertoast.showToast(msg: "YOU HAVE ALREADY A BOOKING FOR THIS GAME");
    //   } else {
    //     Fluttertoast.showToast(msg: "YOU HAVE BEEN BLACKLISTED FOR THIS GAME");
    //   }
    // } catch (e) {
    //   circP = false;
    //   bool hasInternet = await InternetConnectionChecker().hasConnection;
    //   if (!hasInternet) {
    //     Fluttertoast.showToast(msg: "Please check your internet connection");
    //   } else {
    //     Fluttertoast.showToast(msg: "Something went wrong.Please retry;");
    //   }
    //   print(e);
    //   setState(() {});
    // }
  }

  void getData() async {
    var response = await http.get(Uri.parse(kIpAddress + '/max-person'));
    print(StudentInfo.dayChoosen);
    int i = 0;
    for (var item in StudentInfo.dayChoosen) {
      slotsRemaining[i] = StudentInfo.gameData[item][StudentInfo.slotChoosen];
      i++;
    }
    currEmail = StudentInfo.emailId;
    firstName = StudentInfo.name;

    firstNameController = TextEditingController(text: firstName);
    firstEmailController = TextEditingController(text: currEmail);
    circP = false;
    Map<String, dynamic> jsonData = await jsonDecode(response.body);
    print(response.statusCode);
    maxLength = jsonData[StudentInfo.gameChoosen];
    setState(() {});
  }

  final sNames = [
    'First Student Name',
    'SNU ID',
    'Second Student Name',
    'SNU ID',
    'Third Student Name',
    'SNU ID',
    'Fourth Student Name',
    'SNU ID'
  ];

  @override
  Widget build(BuildContext context) {
    print(currEmail);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Please fill in your details'),
          centerTitle: true,
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.01,
                ),
                Form(
                  key: _formKey,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: (StudentInfo.dayChoosen.length),
                    itemBuilder: (context, i) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              IconButton(
                                  onPressed: () {
                                    downArrow[i] = !downArrow[i];
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    downArrow[i]
                                        ? Icons.keyboard_arrow_down
                                        : Icons.keyboard_arrow_right,
                                    size: 30,
                                  )),
                              SizedBox(
                                width: size.width * 0.03,
                              ),
                              Text(
                                StudentInfo.dayChoosen[i],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    if (length == slotsRemaining[i]) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Sorry no more slots are available");
                                    } else if (length == maxLength) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Sorry you cannot book more than $length slots for this game");
                                    } else {
                                      length[i]++;
                                      setState(() {});
                                    }
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    size: 30,
                                  )),
                              SizedBox(
                                width: size.width * 0.08,
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (length[i] == 1) {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Minimum 1 student credetials should be there");
                                    } else {
                                      length[i]--;
                                      setState(() {});
                                    }
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    size: 30,
                                  )),
                              SizedBox(
                                width: size.width * 0.05,
                              ),
                            ],
                          ),
                          downArrow[i]
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: (length[i]) * 2,
                                  itemBuilder: (context, j) {
                                    return StudentDetail(
                                        title: sNames[j],
                                        controller: _controller[i][j],
                                        index: j);
                                  })
                              : Container(),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      postData();
                    }
                  },
                  child: Container(
                    width: size.width * 0.9,
                    height: size.height * 0.05,
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
              ],
            ),
          ),
          circP == true
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.blue,
                ))
              : Container()
        ]));
  }
}
