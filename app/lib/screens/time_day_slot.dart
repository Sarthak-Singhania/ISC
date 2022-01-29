import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:isc/components/roundedbutton.dart';
import 'package:isc/components/slot.dart';

import '../constants.dart';

class TimeDaySlot extends StatefulWidget {
  const TimeDaySlot({Key? key}) : super(key: key);

  @override
  _TimeDaySlotState createState() => _TimeDaySlotState();
}

class _TimeDaySlotState extends State<TimeDaySlot> {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          child: Text(
                            'M',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.purple,
                        ),
                        CircleAvatar(
                          child: Text(
                            'T',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.purple,
                        ),
                        CircleAvatar(
                          child: Text(
                            'W',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.purple,
                        ),
                        CircleAvatar(
                          child: Text(
                            'Th',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.purple,
                        ),
                        CircleAvatar(
                          child: Text(
                            'F',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.purple,
                        ),
                        CircleAvatar(
                          child: Text(
                            'St',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.purple,
                        ),
                        CircleAvatar(
                          child: Text(
                            'S',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.purple,
                        ),
                      ],
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
                  margin: EdgeInsets.only(top: size.height * 0.05),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Spacer(flex: 1),
                          Icon(Icons.arrow_left_outlined),
                          Spacer(flex: 1),
                          Text("Monday", style: TextStyle(fontSize: 20)),
                          Spacer(flex: 1),
                          Icon(Icons.arrow_right_outlined),
                          Spacer(flex: 1),
                        ],
                      ),
                      Container(
                        height: size.height * 0.49,
                        // width: size.width * 0.9,
                        child: ListView(
                          children: [
                            SlotCard(
                                slotTime: "2:00-3:00",
                                color: Colors.green,
                                slotAvailable: 20),
                            SlotCard(
                                slotTime: "2:00-3:00",
                                color: Colors.green,
                                slotAvailable: 20),
                            SlotCard(
                                slotTime: "2:00-3:00",
                                color: Colors.green,
                                slotAvailable: 20),
                            SlotCard(
                                slotTime: "2:00-3:00",
                                color: Colors.green,
                                slotAvailable: 20),
                            SlotCard(
                                slotTime: "2:00-3:00",
                                color: Colors.green,
                                slotAvailable: 20),
                          ],
                        ),
                      ),
                      Container(
                        width: size.width * 0.8,
                        height: size.height * 0.07,
                        child: Center(
                          child: Text("Confirm",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
