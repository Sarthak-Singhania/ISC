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
  int calendarRange = 0;
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

  void getData() async {
    String JWTtoken = await FirebaseAuth.instance.currentUser!.getIdToken();
    //print(JWTtoken);
    response = await http.get(
        Uri.parse(kIpAddress + '/slots' + '/' + widget.game),
        headers: {"x-access-token": JWTtoken});
    jsonData = await jsonDecode(response!.body);
  }

  Future<void> getSlot(String day) async {
    print("game name=" + widget.game);
    sport = jsonData[widget.game][day];
    print(response!.statusCode);
    print(sport);
    slotAvailable.clear();
    sport.forEach((k, v) {
      slotAvailable.add(k);
    });

    // print(Sports[3]);
    // circP = false;

    // print(ImgUri[2]);
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
                        onTap: () {
                          selectDate(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width * 0.4,
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(color: Colors.red),
                          child: Text(
                            'Disable',
                            style: TextStyle(color: Colors.white, fontSize: 14),
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
