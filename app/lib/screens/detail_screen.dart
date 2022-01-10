import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isc/components/event_card.dart';
import 'package:isc/components/roundedbutton.dart';
import 'package:isc/components/slot.dart';
import 'package:isc/screens/profile_screen.dart';
import 'event_screen.dart';
import 'welcome_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'time_slot.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int length = 1;
  int? maxLength;
  dynamic rollNo;
  String date = '';
  List<TextEditingController> _controller =
      List.generate(8, (i) => TextEditingController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    print(SlotCard.maxSlot);
  }

  void postData() async {
    Map<String, dynamic> mp = {};
    for (var i = 0; i < length * 2; i = i + 2) {
      mp.putIfAbsent(_controller[i].text, () => _controller[i + 1].text);
    }
    TimeSlot date = TimeSlot();

    var body = jsonEncode({
      "sports_name": EventCard.game,
      "date": SlotCard.dateChoosen,
      "slot": SlotCard.sltChoosen,
      "student_details": mp,
    });

    print(body);
    try {
      final response = await http.post(
        Uri.parse('http://65.0.232.165/book'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Access-Control-Allow-Origin': ' *'
        },
        body: body,
      );

      print(response.body);
      Fluttertoast.showToast(msg: "YOUR DETAILS HAS BEEN SUBMITTED ");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfileScreen()));
    } catch (e) {
      print(e);
    }
  }

  void getData() async {
    var response = await http.get(Uri.parse('http://65.0.232.165/max-person'));
    Map<String, dynamic> jsonData = await jsonDecode(response.body);
    print(response.statusCode);
    maxLength = jsonData[EventCard.game];
   
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

  String? valueChoose;

  String username = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                  onTap: () {
                    if (length == 1) {
                      Fluttertoast.showToast(
                          msg:
                              "Atleast one student credentials should be there");
                    } else {
                      length--;
                    }
                    setState(() {});
                  },
                  child: Icon(Icons.remove)),
            ),
          ],
          title: Text('Please fill in your details'),
          leading: GestureDetector(
              onTap: () {
                if(length==SlotCard.maxSlot){
                  Fluttertoast.showToast(
                      msg: "No more slots available");
                }
                else if (length == maxLength) {
                  Fluttertoast.showToast(
                      msg: "You have reached maximum no. of people");
                } else {
                  length++;
                }

                setState(() {});
              },
              child: Icon(Icons.add)),
          centerTitle: true,
          backgroundColor: Colors.purple,
        ),
        body: ListView(
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: length * 2,
                itemBuilder: (context, index) {
                  return StudentDetail(sNames[index], _controller[index]);
                }),
            RoundedButton('SUBMIT', Colors.green, Colors.white, size * 0.7, () {
              postData();
            }, context)
          ],
        ));
  }
}

class StudentDetail extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  StudentDetail(this.title, this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue, width: 3.0),
          ),
        ),
        onSaved: (value) {
          controller.text = value!;
        },
      ),
    );
  }
}
