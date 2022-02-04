import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isc/components/slot_card.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../user-info.dart';

class UserTimeSlot extends StatefulWidget {
  const UserTimeSlot({Key? key}) : super(key: key);

  @override
  _UserTimeSlotState createState() => _UserTimeSlotState();
}

var intials = {
  'Monday': 'M',
  'Tuesday': 'T',
  'Wednesday': 'W',
  'Thursday': 'Th',
  'Friday': 'F',
  'Saturday': 'St',
  'Sunday': 'S',
};
void showInfo(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Some info',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem"),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close'))
              ],
            ),
          ),
        );
      });
}

class _UserTimeSlotState extends State<UserTimeSlot> {
  final timeSlots = [
    '1:00-3:00',
    '2:00-3:00',
    '2:00-3:00',
    '2:00-3:00',
    '2:00-3:00',
    '2:00-3:00'
  ];
  var daysAvailable = {}; //API

  var isDaySelected = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };
  var daySelected = [];
  int maxDaysAllowed = 7;
  final slotAvailable = [];
  bool circP = true;
  bool secondCircp = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    //print(JWTtoken);
    try {
      final response = await http.get(
          Uri.parse(kIpAddress +
              "/slots" +
              "?game=${StudentInfo.gameChoosen}" +
              "&pos=1"),
          headers: {
            "x-access-token": StudentInfo.jwtToken,
            "admin-header": "no"
          });
      final jsonData = await jsonDecode(response.body);
      daysAvailable = jsonData["isEnabled"];
      maxDaysAllowed = jsonData["max_days"];
      print(jsonData);
      circP = false;
      setState(() {});
    } catch (e) {
      print(e);
      circP = false;
      setState(() {});
    }
    // oldResponse = response;
  }

  Future<void> getSlot() async {
    // print(selected.toString());
    slotAvailable.clear();
    StudentInfo.dayChoosen = daySelected;
    try {
      final response = await http.get(
          Uri.parse(kIpAddress +
              "/slots" +
              "?game=${StudentInfo.gameChoosen}" +
              "&pos=2" +
              "&days=${daySelected.toString()}"),
          headers: {
            "x-access-token": StudentInfo.jwtToken,
            "admin-header": "no"
          });
      final jsonData = await jsonDecode(response.body);
      final sport = jsonData[StudentInfo.gameChoosen][daySelected[0]];
      StudentInfo.gameData = jsonData[StudentInfo.gameChoosen];
      sport.forEach((k, v) {
        slotAvailable.add(k);
      });
      print(jsonData);
      secondCircp = false;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
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
        actions: [
          IconButton(
              onPressed: () {
                showInfo(context);
              },
              icon: Icon(Icons.info_outline))
        ],
      ),
      body: Center(
        child: Stack(children: [
          !circP
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: size.height * 0.22,
                        child: Column(
                          children: [
                            Spacer(),
                            Text(
                              'Please select your days',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Container(
                              // width: size.width * 1,
                              height: size.height * 0.1,
                              child: Center(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: daysAvailable.length,
                                    itemBuilder: (context, index) {
                                      return Weekday(
                                        weekday:
                                            daysAvailable.keys.elementAt(index),
                                        isEnabled: daysAvailable.values
                                            .elementAt(index),
                                        func: () {
                                          setState(() {});
                                        },
                                        isDaySelected: isDaySelected,
                                        maxDaysAllowed: maxDaysAllowed,
                                        daySelected: daySelected,
                                      );
                                    }),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {
                                if (daySelected.length > 0) {
                                  secondCircp = true;
                                  setState(() {});
                                  await getSlot();
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please select atleast one day");
                                }
                              },
                              child: Container(
                                width: size.width * 0.5,
                                height: size.height * 0.05,
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    'Show Results',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          // margin: EdgeInsets.only(top: size.height * 0.05),
                          child: Column(
                        children: [
                          // Row(
                          //   children: [
                          //     Spacer(flex: 1),
                          //     Icon(Icons.arrow_left_outlined),
                          //     Spacer(flex: 1),
                          //     Text("Monday", style: TextStyle(fontSize: 20)),
                          //     Spacer(flex: 1),
                          //     Icon(Icons.arrow_right_outlined),
                          //     Spacer(flex: 1),
                          //   ],
                          // ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: slotAvailable.length,
                              itemBuilder: (context, index) {
                                return SlotCard(
                                  slotTime: slotAvailable[index],
                                  color: Colors.green,
                                );
                              },
                            ),
                          ),
                        ],
                      )),
                    )
                  ],
                )
              : Container(),
          circP || secondCircp
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.blue,
                ))
              : Container()
        ]),
      ),
    );
  }
}

class Weekday extends StatelessWidget {
  const Weekday({
    Key? key,
    required this.weekday,
    required this.isEnabled,
    required this.func,
    required this.daySelected,
    required this.maxDaysAllowed,
    required this.isDaySelected,
  }) : super(key: key);
  final weekday;
  final bool isEnabled;
  final Function func;
  final daySelected;
  final maxDaysAllowed;
  final isDaySelected;
  // final List selected;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isEnabled) {
          if (daySelected.contains(weekday)) {
            isDaySelected[weekday] = false;
            daySelected.remove(weekday);
          } else {
            if (daySelected.length < maxDaysAllowed) {
              isDaySelected[weekday] = true;
              daySelected.add(weekday);
            } else {
              Fluttertoast.showToast(
                  msg: "You cannot select more than $maxDaysAllowed days");
            }
          }
          func();
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: !isEnabled
              ? Colors.grey
              : isDaySelected[weekday]!
                  ? Colors.green
                  : Colors.purple,
          child: Text(
            intials[weekday] ?? " ",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
