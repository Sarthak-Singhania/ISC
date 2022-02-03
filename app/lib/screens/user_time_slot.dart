import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:isc/components/roundedbutton.dart';
import 'package:isc/components/slot_card.dart';

import '../constants.dart';

class UserTimeSlot extends StatefulWidget {
  const UserTimeSlot({Key? key}) : super(key: key);

  @override
  _UserTimeSlotState createState() => _UserTimeSlotState();
}

final timeSlots = [
  '1:00-3:00',
  '2:00-3:00',
  '2:00-3:00',
  '2:00-3:00',
  '2:00-3:00',
  '2:00-3:00'
];
var detail = {
  'M': false,
  'T': false,
  'W': false,
  'Th': false,
  'F': false,
  'St': false,
  'S': false,
};
var list1 = ['M', 'W', 'F', 'T', 'Th', 'St', 'S'];
var list2 = ['M', 'W', 'F', 'T', 'Th', 'St', 'S'];
var selected = [];

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
        child: Column(
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Container(
                      // width: size.width * 1,
                      height: size.height * 0.1,
                      child: Center(
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: detail.length,
                            itemBuilder: (context, index) {
                              return Weekday(
                                  weekday: detail.keys.elementAt(index),
                                  isSelected: detail.values.elementAt(index),
                                  func: () {
                                    setState(() {}); //PASSING SET STATE
                                  });
                            }),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: size.width * 0.5,
                      height: size.height * 0.05,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          'Show Results',
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
                      itemCount: timeSlots.length,
                      itemBuilder: (context, index) {
                        return SlotCard(
                          slotTime: timeSlots[index],
                          color: Colors.green,
                          slotAvailable: 20,
                        );
                      },
                    ),
                  ),
                  // Container(
                  //   width: size.width * 0.8,
                  //   height: size.height * 0.07,
                  //   child: Center(
                  //     child: Text("Confirm",
                  //         style:
                  //             TextStyle(color: Colors.white, fontSize: 20)),
                  //   ),
                  //   decoration: BoxDecoration(
                  //       color: kPrimaryColor,
                  //       borderRadius: BorderRadius.circular(20)),
                  // ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}

class Weekday extends StatelessWidget {
  const Weekday({
    Key? key,
    required this.weekday,
    required this.isSelected,
    required this.func,
  }) : super(key: key);
  final weekday;
  final bool isSelected;
  final Function func;
  // final List selected;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        func();
        if (!detail[weekday]!) {
          if (selected.length == 0) {
            selected.insert(0, weekday);
            detail[weekday] = true;
          } else {
            var alreadySelectedDay = selected[0];
            if (list1.contains(alreadySelectedDay) && list1.contains(weekday)) {
              selected.insert(0, weekday);
              detail[weekday] = true;
            } else if (list2.contains(alreadySelectedDay) &&
                list2.contains(weekday)) {
              selected.insert(0, weekday);
              detail[weekday] = true;
            }
          }
        } else {
          detail[weekday] = false;
          selected.remove(weekday);
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: isSelected ? Colors.green : Colors.purple,
          child: Text(
            weekday,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
