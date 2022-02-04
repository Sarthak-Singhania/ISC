import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:isc/components/roundedbutton.dart';
import 'package:isc/components/slot_card.dart';
import 'package:isc/components/student_detail.dart';
import 'package:isc/constants.dart';
import 'package:isc/routes.dart';

import 'package:isc/user-info.dart';
import 'booking_screen.dart';

import 'package:http/http.dart' as http;
import 'admin_time_slot.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  TextEditingController? firstNameController;
  final _formKey = GlobalKey<FormState>();
  String firstName = '';
  bool circP = true;
  TextEditingController? firstEmailController;
  String currEmail = '';
  int length = 1;
  int? maxLength;
  dynamic rollNo;
  String date = '';
  List<TextEditingController> _controller = List.generate(
      8,
      (i) =>
          TextEditingController()); //TODO: dynamica krna acooridng to sum of max slots allowed

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void postData() async {
    String JWTtoken = StudentInfo.jwtToken;
    Map<String, dynamic> mp = {};
    mp.putIfAbsent(firstNameController!.text, () => currEmail);
    for (var i = 0; i < (length * 2); i = i + 2) {
      mp.putIfAbsent(_controller[i].text, () => _controller[i + 1].text);
    }

    var body = jsonEncode({
      "sports_name": StudentInfo.gameChoosen,
      "date": StudentInfo.dateChoosen,
      "slot": StudentInfo.slotChoosen,
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
      print("Hello ${response.statusCode}");
      Map jsonData = await jsonDecode(response.body);
      print("details");
      print(jsonData);
      circP = false;
      setState(() {});
      if (jsonData['status'] == 'confirmed') {
        Fluttertoast.showToast(msg: "YOUR DETAILS HAS BEEN SUBMITTED ");
        Future.delayed(Duration(milliseconds: 2000), () {});
        Navigator.pushReplacementNamed(context, AppRoutes.bookingsScreen);
      } else if (jsonData['status'] == 'duplicate') {
        Fluttertoast.showToast(msg: "YOU HAVE ALREADY A BOOKING FOR THIS GAME");
      } else {
        Fluttertoast.showToast(msg: "YOU HAVE BEEN BLACKLISTED FOR THIS GAME");
      }
    } catch (e) {
      circP = false;
      bool hasInternet = await InternetConnectionChecker().hasConnection;
      if (!hasInternet) {
        Fluttertoast.showToast(msg: "Please check your internet connection");
      } else {
        Fluttertoast.showToast(msg: "Something went wrong.Please retry;");
      }
      print(e);
      setState(() {});
    }
  }

  void getData() async {
    var response = await http.get(Uri.parse(kIpAddress + '/max-person'));
    print(StudentInfo.dayChoosen);
    for (var item in StudentInfo.dayChoosen) {
      print(StudentInfo.gameData[item][StudentInfo.slotChoosen]);
    }
    currEmail = StudentInfo.emailId;
    firstName = StudentInfo.name;

    firstNameController = TextEditingController(text: firstName);
    firstEmailController = TextEditingController(text: currEmail);
    circP = false;
    Map<String, dynamic> jsonData = await jsonDecode(response.body);
    print(response.statusCode);
    maxLength = jsonData[StudentInfo.gameChoosen];
    setState(() {});
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
                if (length == 4) {
                  //change this
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
        ),
        body: Stack(children: [
          ListView(
            children: [
              Form(
                key: _formKey,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: (length * 2),
                    itemBuilder: (context, index) {
                      return StudentDetail(
                          title: sNames[index],
                          controller: _controller[index],
                          index: index);
                    }),
              ),
              RoundedButton(
                  s: 'SUBMIT',
                  color: Colors.green,
                  tcolor: Colors.white,
                  size: size * 0.7,
                  func: () {
                    if (_formKey.currentState!.validate()) {
                      circP = true;
                      setState(() {});
                      postData();
                    }
                  })
            ],
          ),
          circP == true
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.blue,
                ))
              : Container()
        ]));
  }
}
