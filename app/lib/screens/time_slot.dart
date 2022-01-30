import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:isc/constants.dart';
import 'package:isc/components/slot.dart';
import 'package:http/http.dart' as http;
import 'package:isc/provider/theme_provider.dart';
import 'package:isc/user-info.dart';
import 'package:provider/provider.dart';
// import 'package:switcher/core/switcher_size.dart';
// import 'package:switcher/switcher.dart';

class TimeSlot extends StatefulWidget {
  TimeSlot();

  @override
  _TimeSlotState createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
  bool isDisabled = true;
  int calendarRange = 0;
  bool isLoading = false;
  bool isDateChoosen = false;
  String gameChoosen = " ";
  Response? oldResponse;
  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(
            DateTime.now().add(Duration(days: 7 - calendarRange ))))) {
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
    gameChoosen = StudentInfo.gameChoosen;
    getData();
  }

  Future<void> disbaleSlot() async {
    final slotResponse = await http.get(
        Uri.parse(kIpAddress +
            "/booking-count?category=date&game=" +
            gameChoosen +
            "&date=" +
            StudentInfo.dateChoosen),
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
                    "category": "date",
                    "game": gameChoosen,
                    "date": StudentInfo.dateChoosen,
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
                        "x-access-token": StudentInfo.jwtToken,
                        "admin-header": "YES"
                      },
                      body: body,
                    );
                    isDisabled = false;
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

  Future<void> enableSlot() async {
    var body = jsonEncode({
      "category": "date",
      "game": gameChoosen,
      "date": StudentInfo.dateChoosen,
    });

    print(body);
    try {
      final enableResponse = await http.post(
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

      print(enableResponse.body);
    } catch (e) {
      print(e);
    }
  }

  void getData() async {
    //print(JWTtoken);
    response = await http.get(
        Uri.parse(kIpAddress + '/slots' + '/' + StudentInfo.gameChoosen),
        headers: {"x-access-token": StudentInfo.jwtToken});
    jsonData = await jsonDecode(response!.body);
    oldResponse = response;
  }

  Future<void> getSlot(String day) async {
    print(jsonData);
    print("game name=" + gameChoosen);
    sport = jsonData[gameChoosen][day];
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
      StudentInfo.dateChoosen =
          '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}';
      isDateChoosen = true;
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
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
            StudentInfo.isAdmin == false
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
                              await disbaleSlot();
                            } else {
                              await enableSlot();
                              isDisabled = true;
                            }
                            response = await http.get(
                                Uri.parse(
                                    kIpAddress + '/slots' + '/' + gameChoosen),
                                headers: {
                                  "x-access-token": StudentInfo.jwtToken
                                });
                            jsonData = await jsonDecode(response!.body);

                            print("latest");
                            print(jsonData);
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
              child: ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: slotAvailable.length,
                  itemBuilder: (context, index) {
                    return SlotCard(
                        slotTime: slotAvailable[index],
                        color: sport[slotAvailable[index]] > 0
                            ? theme.checkTheme(
                                Colors.green, Colors.green.shade600, context)
                            : Colors.grey,
                        slotAvailable: sport[slotAvailable[index]]);
                  }),
            )
          ],
        ));
  }
}
