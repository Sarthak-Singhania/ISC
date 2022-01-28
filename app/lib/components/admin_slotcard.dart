import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isc/user-info.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class AdminSlotCard extends StatelessWidget {
  const AdminSlotCard(
      {Key? key,
      required this.size,
      required this.bookingId,
      required this.studentName,
      required this.snuId})
      : super(key: key);

  final Size size;
  final studentName;
  final snuId;
  final bookingId;

  Future<void> attendance(String attendance) async {
    var body = jsonEncode({
      "name":studentName,
      "snu_id": snuId,
      "booking_id": bookingId,
    });

    try {
      final response = await http.post(
        Uri.parse(kIpAddress + '/$attendance'),
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
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(left: 10, right: 10),
      width: size.width * 0.9,
      height: size.height * 0.1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Student Name : $studentName',
                style: TextStyle(fontSize: 15),
              ),
              GestureDetector(
                onTap: () {
                  attendance("present");
                  Fluttertoast.showToast(
                      msg: "Student has been marked present ");
                },
                child: Text(
                  'Present',
                  style: TextStyle(fontSize: 15, color: Colors.green),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SNU ID: $snuId',
                style: TextStyle(fontSize: 15),
              ),
              GestureDetector(
                onTap: () {
                  attendance("absent");
                  Fluttertoast.showToast(msg: "Student has been marked absent");
                },
                child: Text(
                  'Absent',
                  style: TextStyle(fontSize: 15, color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: kPrimaryLightColor,
            spreadRadius: 5,
            blurRadius: 8,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
