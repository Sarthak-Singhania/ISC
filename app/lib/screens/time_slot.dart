import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:isc/components/event_card.dart';
import 'package:isc/constants.dart';
import 'package:isc/components/slot.dart';
import 'package:http/http.dart' as http;
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';

class TimeSlot extends StatefulWidget {
  var game;
  var adminCheck;
  TimeSlot({this.game, this.adminCheck});

  @override
  _TimeSlotState createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
  bool isDisabled = true;
  String JWTtoken = '';
  int calendarRange = 0;
  bool isLoading = false;
  bool isDateChoosen = false;
  Response? oldResponse;
  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(
            DateTime.now().add(Duration(days: 7 - calendarRange - 1))))) {
      return true;
    }
    return false;
  }

  DateTime? selectedDate;
  String slotDetail = '';
  final slotAvailable = [];
  Map<String, dynamic> sport = {};
  Map<String, dynamic> jsonData = {};
  Response? response;
  final weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void disbaleSlot() async {
    JWTtoken = await FirebaseAuth.instance.currentUser!.getIdToken();
    final slotResponse = await http.get(
        Uri.parse(kIpAddress +
            "/booking-count?category=date&game=" +
            widget.game +
            "&date=" +
            SlotCard.dateChoosen),
        headers: {"x-access-token": JWTtoken});

    final responseJsonData = jsonDecode(slotResponse.body);
    String slotsAvailable = responseJsonData['message'];
    bool isSlotAvailable = false;
    print("Sport ke slot = $slotsAvailable");
    if (slotsAvailable != '0') {
      isSlotAvailable = true;
    }
    showDialog(
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
                  Navigator.of(context).pop();
                  var body = jsonEncode({
                    "category": "date",
                    "game": widget.game,
                    "date": SlotCard.dateChoosen,
                  });

                  print(body);
                  try {
                    final disableResponse = await http.post(
                      Uri.parse(kIpAddress + '/stop'),
                      headers: {
                        'Content-Type': 'application/json',
                        'Accept': '*/*',
                        'Accept-Encoding': 'gzip, deflate, br',
                        'Access-Control-Allow-Origin': ' *',
                        "x-access-token": JWTtoken,
                        "admin-header": "YES"
                      },
                      body: body,
                    );
                    isDisabled = false;
                    print(disableResponse.body);
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
  }

  void enableSlot() async {
    JWTtoken = await FirebaseAuth.instance.currentUser!.getIdToken();

    var body = jsonEncode({
      "category": "date",
      "game": widget.game,
      "date": SlotCard.dateChoosen,
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
          "x-access-token": JWTtoken,
          "admin-header": "YES"
        },
        body: body,
      );
    } catch (e) {
      print(e);
    }
  }

  void getData() async {
    JWTtoken = await FirebaseAuth.instance.currentUser!.getIdToken();
    //print(JWTtoken);
    response = await http.get(
        Uri.parse(kIpAddress + '/slots' + '/' + widget.game),
        headers: {"x-access-token": JWTtoken});
    jsonData = await jsonDecode(response!.body);
    oldResponse = response;
  }

  Future<void> getSlot(String day) async {
    print(jsonData);
    print("game name=" + widget.game);
    sport = jsonData[widget.game][day];
    print(response!.statusCode);
    print(sport);
    slotAvailable.clear();
    bool isAllSlotZero = true;
    sport.forEach((k, v) {
      slotAvailable.add(k);
      if (v > 0) {
        isAllSlotZero = false;
      }
    });

    if (isAllSlotZero) {
      isDisabled = false;
    } else {
      isDisabled = true;
    }
    setState(() {});
  }

  selectDate(context) async {
    final initialDate = DateTime.now();
    calendarRange = initialDate.weekday;
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(initialDate.year - 5),
        lastDate: DateTime(initialDate.year + 10),
        selectableDayPredicate: _decideWhichDayToEnable);
    if (newDate != null) {
      selectedDate = newDate;
      print(weekDays[selectedDate!.weekday - 1]);
      await getSlot(weekDays[selectedDate!.weekday - 1]);
      SlotCard.dateChoosen =
          '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}';
      isDateChoosen = true;
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          title: Text(
            "Select your timeslot",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            widget.adminCheck == false
                ? GestureDetector(
                    onTap: () {
                      selectDate(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width * 0.85,
                      margin: EdgeInsets.only(top: 5),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(color: kPrimaryColor),
                      child: Text(
                        selectedDate == null
                            ? "CHOOSE YOUR DATE"
                            : '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  )
                : Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          selectDate(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width * 0.4,
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(color: kPrimaryColor),
                          child: Text(
                            selectedDate == null
                                ? "CHOOSE YOUR DATE"
                                : '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ),
                      ),
                      Spacer(flex: 4),
                      GestureDetector(
                        onTap: () async {
                          if (isDateChoosen) {
                            if (isDisabled) {
                              disbaleSlot();
                            } else {
                              enableSlot();
                              isDisabled = true;
                            }
                            // await Future.delayed(const Duration(seconds: 2),
                            //     () {
                            //   print("Printing first");
                            // });
                            // print("Printing baad me");

                            //getData();

                            //print(JWTtoken);

                            response = await http.get(
                                Uri.parse(
                                    kIpAddress + '/slots' + '/' + widget.game),
                                headers: {"x-access-token": JWTtoken});
                            jsonData = await jsonDecode(response!.body);

                            print("latest");
                            print(jsonData);

                            while (response == oldResponse) {
                              response = await http.get(
                                  Uri.parse(kIpAddress +
                                      '/slots' +
                                      '/' +
                                      widget.game),
                                  headers: {"x-access-token": JWTtoken});
                              jsonData = await jsonDecode(response!.body);
                            }

                            getSlot(weekDays[selectedDate!.weekday - 1]);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width * 0.4,
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.all(15),
                          decoration: isDisabled
                              ? BoxDecoration(color: Colors.red)
                              : BoxDecoration(color: Colors.green),
                          child: isDisabled
                              ? Text(
                                  'Disable',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                )
                              : Text(
                                  'Enable',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
            Expanded(
              child: ListView(
                children: [
                  ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: slotAvailable.length,
                      itemBuilder: (context, index) {
                        return SlotCard(
                            adminCheck: widget.adminCheck,
                            game: widget.game,
                            slt_time: slotAvailable[index],
                            color: sport[slotAvailable[index]] > 0
                                ? Colors.green
                                : Colors.grey,
                            slotAvailable: sport[slotAvailable[index]]);
                      })
                ],
              ),
            )
          ],
        ));
  }
}
