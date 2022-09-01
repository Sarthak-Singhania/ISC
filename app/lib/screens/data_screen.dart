import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../constants.dart';
import '../user-info.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({Key? key}) : super(key: key);

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  var questionAnswer = {};
  var isExpanded = List<bool>.filled(2, false);
  DateTime? intialDate;
  DateTime? endingDate;
  bool circP = false;
  bool tapToRefresh = false;
  bool isInitialDate = false;
  List<bool> categoryFilter = [
    false,
    false,
    false,
  ];

  List<String> sportName = StudentInfo.getDataSport;
  var sportFilter = List<bool>.filled(StudentInfo.getDataSport.length, false);
  int rangeStartingDate = 365;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();
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
      circP = false;
      tapToRefresh = true;
      setState(() {});
    } catch (e) {
      circP = false;
      tapToRefresh = true;
      setState(() {});
      print(e);
    }
  }

  Future<void> postData() async {
    var body = jsonEncode({
      "category": "slot",
      "game": StudentInfo.gameChoosen,
      "date": StudentInfo.dateChoosen,
      "slot": StudentInfo.slotChoosen,
    });

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
      setState(() {});
    } catch (e) {
      if (!(await InternetConnectionChecker().hasConnection)) {
        Fluttertoast.showToast(msg: "Please check you internet connection");
      } else {
        Fluttertoast.showToast(msg: "Please try again.");
      }
      print(e);
    }
  }

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 365))) &&
        day.isBefore(DateTime.now().add(Duration(days: 0))))) {
      return true;
    }
    return false;
  }

  selectintialDate(context) async {
    // rangeStartingDate = 365;
    final todayDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: todayDate,
        firstDate: DateTime(todayDate.year - 1),
        lastDate: DateTime(todayDate.year + 1),
        selectableDayPredicate: _decideWhichDayToEnable);
    if (newDate != null) {
      // isInitialDate = true;
      intialDate = newDate;
      // rangeStartingDate = todayDate.difference(newDate).inDays;
      setState(() {});
    }
  }

  selectfinalDate(context) async {
    final todayDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: todayDate,
        firstDate: DateTime(todayDate.year - 1),
        lastDate: DateTime(todayDate.year + 1),
        selectableDayPredicate: _decideWhichDayToEnable);
    if (newDate != null) {
      endingDate = newDate;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: circP
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.blue,
            ))
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
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              selectintialDate(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: size.width * 0.4,
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(color: kPrimaryColor),
                              child: AutoSizeText(
                                intialDate == null
                                    ? "Starting Date"
                                    : '${intialDate!.day}-${intialDate!.month}-${intialDate!.year}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //  if (isInitialDate) {
                              selectfinalDate(context);
                              // } else {
                              //   Fluttertoast.showToast(
                              //       msg: "Please select starting date");
                              // }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: size.width * 0.4,
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(color: kPrimaryColor),
                              child: AutoSizeText(
                                endingDate == null
                                    ? "Ending Date"
                                    : '${endingDate!.day}-${endingDate!.month}-${endingDate!.year}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Cateogry",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: Colors.pink,
                                    value: categoryFilter[0],
                                    onChanged: (value) {
                                      setState(() {});
                                      categoryFilter[0] = value!;
                                    }),
                                Text('Present'),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: Colors.pink,
                                    value: categoryFilter[1],
                                    onChanged: (value) {
                                      setState(() {});
                                      categoryFilter[1] = value!;
                                    }),
                                Text('Absent'),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: Colors.pink,
                                    value: categoryFilter[2],
                                    onChanged: (value) {
                                      setState(() {});
                                      categoryFilter[2] = value!;
                                    }),
                                Text('Cancelled'),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Sports",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: sportName.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: Colors.green,
                                          value: sportFilter[index],
                                          onChanged: (value) {
                                            setState(() {});
                                            sportFilter[index] = value!;
                                          }),
                                      Text(sportName[index]),
                                    ],
                                  );
                                })
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (intialDate != null && endingDate != null) {
                            if (endingDate!.difference(intialDate!).inDays >=
                                0) {
                              print("hello");
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "Ending Date should be after Starting Date");
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please select respective dates");
                          }
                        },
                        child: Container(
                          width: size.width * 0.9,
                          height: size.height * 0.05,
                          decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: AutoSizeText(
                              "SUBMIT",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                    ],
                  ),
                ),
    ));
  }
}
