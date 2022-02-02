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
  'St': false
};
var list1 = ['M', 'W', 'F'];
var list2 = ['T', 'Th', 'St'];
var selected = [];

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
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                        Weekday(
                          weekday: 'M',
                          isSelected: detail['M']!,
                          func: () {
            setState(() {});      //PASSING SET STATE
          }),
                        
                        Weekday(
                          weekday: 'T',
                          isSelected: detail['T']!,
                          func: () {
            setState(() {});      //PASSING SET STATE
          }
                        ),
                        Weekday(
                          weekday: 'W',
                          isSelected: detail['W']!,
                          func: () {
            setState(() {});      //PASSING SET STATE
          }
                        ),
                        Weekday(
                          weekday: 'Th',
                          isSelected: detail['Th']!,
                          func: () {
            setState(() {});      //PASSING SET STATE
          }
                        ),
                        Weekday(
                          weekday: 'F',
                          isSelected: detail['F']!,
                          func: () {
            setState(() {});      //PASSING SET STATE
          }
                        ),
                        Weekday(
                          weekday: 'St',
                          isSelected: detail['St']!,
                          func: () {
            setState(() {});      //PASSING SET STATE
          }
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
          if(list1.contains(alreadySelectedDay)&&list1.contains(weekday)){
            selected.insert(0, weekday);
            detail[weekday] = true;
          }
          else if(list2.contains(alreadySelectedDay)&&list2.contains(weekday)){
            selected.insert(0, weekday);
            detail[weekday] = true;
          }
        }
        } else {
          detail[weekday] = false;
          selected.remove(weekday);
        }
        
      },
      child: CircleAvatar(
        backgroundColor: isSelected ? Colors.purple.shade800 : Colors.purple,
        child: Text(
          weekday,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
