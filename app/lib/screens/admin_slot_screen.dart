import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:isc/components/slot.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';
import '../constants.dart';

class AdminSlotScreen extends StatefulWidget {
  const AdminSlotScreen({Key? key}) : super(key: key);

  @override
  _AdminSlotScreenState createState() => _AdminSlotScreenState();
}

class _AdminSlotScreenState extends State<AdminSlotScreen> {
  dynamic pendingList = [];
  bool emptyList = false;
  bool circP = true;
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    String currEmail = FirebaseAuth.instance.currentUser!.email!;
    String JWTtoken = await FirebaseAuth.instance.currentUser!.getIdToken();
    print(currEmail);
    print(SlotCard.dateChoosen);
    print(SlotCard.gameChoosen);
    print(SlotCard.sltChoosen);
    var response = await http.get(
        Uri.parse(kIpAddress +
            '/admin-bookings/${SlotCard.gameChoosen}/${SlotCard.dateChoosen}/${SlotCard.sltChoosen}'),
        headers: {"x-access-token": JWTtoken, "admin-header": "YES"});
    var jsonData = await jsonDecode(response.body);
    print(jsonData);
    pendingList = jsonData["message"];

    if (pendingList.length == 0) {
      circP = false;
      emptyList = true;
      setState(() {});
    } else {
      circP = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('BOOKINGS'),
          actions: [
            Switcher(
              value: false,
              size: SwitcherSize.small,
              switcherButtonRadius: 70,
              enabledSwitcherButtonRotate: true,
              iconOff: Icons.lock_open,
              iconOn: Icons.lock,
              colorOff: Colors.green,
              colorOn: Colors.red,
              onChanged: (bool state) {
                //
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: emptyList == true
                ? Center(
                    child: Text(
                    'No bookings',
                    style: TextStyle(fontSize: 20),
                  ))
                : circP
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Colors.blue,
                      ))
                    : Column(
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                ListView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: pendingList.length,
                                    itemBuilder: (context, index) {
                                      return AdminSlotCard(
                                        size: size,
                                        studentName: pendingList[index]
                                            ['Student_Name'],
                                        snuId: pendingList[index]['SNU_ID'],
                                      );
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
          ),
        ));
  }
}

class AdminSlotCard extends StatelessWidget {
  const AdminSlotCard(
      {Key? key,
      required this.size,
      required this.studentName,
      required this.snuId})
      : super(key: key);

  final Size size;
  final studentName;
  final snuId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: size.width * 0.9,
      height: size.height * 0.1,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Student Name : $studentName',
              style: TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'SNU ID: $snuId',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      )),
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
