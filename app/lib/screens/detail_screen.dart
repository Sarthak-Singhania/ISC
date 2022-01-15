import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isc/components/event_card.dart';
import 'package:isc/components/roundedbutton.dart';
import 'package:isc/components/slot.dart';
import 'package:isc/constants.dart';
import 'package:isc/screens/profile_screen.dart';
import 'booking_screen.dart';
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
  TextEditingController? firstNameController;
  String firstName = '';
  bool circP = true;
  TextEditingController? firstEmailController;
  String currEmail = '';
  int length = 1;
  int? maxLength;
  dynamic rollNo;
  String date = '';
  List<TextEditingController> _controller =
      List.generate(6, (i) => TextEditingController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    print(SlotCard.maxSlot);
  }

  void postData() async {
    String JWTtoken = await FirebaseAuth.instance.currentUser!.getIdToken();
    Map<String, dynamic> mp = {};
    mp.putIfAbsent(firstNameController!.text, () => currEmail);
    for (var i = 0; i < (length * 2) - 2; i = i + 2) {
      mp.putIfAbsent(_controller[i].text, () => _controller[i + 1].text);
    }
    TimeSlot date = TimeSlot();

    var body = jsonEncode({
      "sports_name": SlotCard.gameChoosen,
      "date": SlotCard.dateChoosen,
      "slot": SlotCard.sltChoosen,
      "student_details": mp,
    });

    print(body);
    try {
      final response = await http.post(
        Uri.parse(kIpAddress + '/book'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Access-Control-Allow-Origin': ' *',
          "x-access-token": JWTtoken,
        },
        body: body,
      );

      print(response.body);
      Fluttertoast.showToast(msg: "YOUR DETAILS HAS BEEN SUBMITTED ");
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Do you want to book more slots this sport?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => BookingScreen()));
                  },
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => TimeSlot()));
                  },
                  child: Text('Yes'),
                ),
              ],
            );
          });
    } catch (e) {
      print(e);
    }
  }

  void getData() async {
    currEmail = await FirebaseAuth.instance.currentUser!.email!;
    var response = await http.get(Uri.parse(kIpAddress + '/max-person'));
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(currEmail).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      firstName = data?['Name']; // <-- The value you want to retrieve.
      // Call setState if needed.
    }

    firstNameController = TextEditingController(text: firstName);
    firstEmailController = TextEditingController(text: currEmail);
    circP = false;
    Map<String, dynamic> jsonData = await jsonDecode(response.body);
    print(response.statusCode);
    maxLength = jsonData[SlotCard.gameChoosen];
    setState(() {});
  }

  final sNames = [
    // 'First Student Name',
    // 'SNU ID',
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
    print(currEmail);
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
                if (length == SlotCard.maxSlot) {
                  Fluttertoast.showToast(msg: "No more slots available");
                } else if (length == maxLength) {
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
        body: circP == true
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.blue,
              ))
            : ListView(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First Student Name',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 3.0),
                        ),
                      ),
                      onSaved: (value) {
                        firstNameController!.text = value!;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: TextFormField(
                      //  focusNode: FocusNode(canRequestFocus: false),
                      // enableInteractiveSelection: false,
                      readOnly: true,
                      controller: firstEmailController,
                      // initialValue: currEmail.toString(),
                      decoration: InputDecoration(
                        labelText: 'SNU ID',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 3.0),
                        ),
                      ),
                      // onSaved: (value) {
                      //   firstName.text = value!;
                      // },
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: (length * 2) - 2,
                      itemBuilder: (context, index) {
                        return StudentDetail(sNames[index], _controller[index]);
                      }),
                  RoundedButton(
                      'SUBMIT', Colors.green, Colors.white, size * 0.7, () {
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
