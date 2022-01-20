import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:isc/screens/time_slot.dart';
import 'package:http/http.dart' as http;
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';
import 'package:transparent_image/transparent_image.dart';

import '../constants.dart';

class EventCard extends StatefulWidget {
  String title;
  String uri;
  bool checkAdmin;

  EventCard({required this.checkAdmin, required this.title, required this.uri});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  double opacity = 0.5;
  //String game = '';

  double spreadRadius = 5;
  bool value = true;

  double blurRadius = 7;
  void disbaleSlot() async {
    String JWTtoken = await FirebaseAuth.instance.currentUser!.getIdToken();

    TimeSlot date = TimeSlot();

    var body = jsonEncode({
       "category": "game",
      "game": widget.title,
    });

    print(body);
    try {
      final response = await http.post(
        Uri.parse(kIpAddress + '/stop'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Access-Control-Allow-Origin': ' *',
          "x-access-token": JWTtoken,
          "admin-header": "YES"
        },
        body: body,
      );
    } catch (e) {
      print(e);
    }
  }

  void enableSlot() async {
    String JWTtoken = await FirebaseAuth.instance.currentUser!.getIdToken();

    TimeSlot date = TimeSlot();

    var body = jsonEncode({
      "category": "game",
      "game": widget.title,
      
    });

    print(body);
    try {
      final response = await http.post(
        Uri.parse(kIpAddress + '/unstop'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Access-Control-Allow-Origin': ' *',
          "x-access-token": JWTtoken,
          "admin-header": "YES"
        },
        body: body,
      );
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return widget.checkAdmin == true
        ? GestureDetector(
            onLongPress: () {},
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return TimeSlot(
                    game: widget.title,
                    adminCheck: widget.checkAdmin,
                  );
                }),
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 17), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Switcher(
                    value: false,
                    size: SwitcherSize.medium,
                    switcherButtonRadius: 70,
                    enabledSwitcherButtonRotate: true,
                    iconOff: Icons.lock_open,
                    iconOn: Icons.lock,
                    colorOff: Colors.green,
                    colorOn: Colors.red,
                    onChanged: (bool state) {
                      if (state) {
                        disbaleSlot();
                      } else {
                        enableSlot();
                      }
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: FadeInImage.memoryNetwork(
                        image: widget.uri,
                        placeholder: kTransparentImage,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  )
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return TimeSlot(
                    game: widget.title,
                    adminCheck: widget.checkAdmin,
                  );
                }),
              );
            },
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 17), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: FadeInImage.memoryNetwork(
                      image: widget.uri,
                      placeholder: kTransparentImage,
                    ),
                  ),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )
                ],
              ),
            ),
          );
  }
}
