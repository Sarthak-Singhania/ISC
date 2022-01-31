import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isc/provider/theme_provider.dart';
import 'package:isc/routes.dart';

import 'package:isc/screens/time_slot.dart';
import 'package:http/http.dart' as http;
import 'package:isc/user-info.dart';
import 'package:provider/provider.dart';

import 'package:transparent_image/transparent_image.dart';

import '../constants.dart';

class EventCard extends StatefulWidget {
  String title;
  String uri;

  EventCard({required this.title, required this.uri});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  double opacity = 0.5;
  String JWTtoken = '';
  //String game = '';
  bool toggleValue = false;
  late bool hasInternet;

  double spreadRadius = 5;
  bool value = true;

  double blurRadius = 7;

  @override
  Widget build(BuildContext context) {
    dynamic theme = Provider.of<ThemeProvider>(context);
    return GestureDetector(
            onTap: ()  {
               StudentInfo.gameChoosen = widget.title;
                Navigator.pushNamed(context, AppRoutes.studentTime);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: theme.checkTheme(Colors.grey.withOpacity(0.5),
                        Colors.purple.shade500, context), // purple 500
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 5), // changes position of shadow
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: theme.checkTheme(
                            Colors.black, Colors.purple, context)),
                  )
                ],
              ),
            ),
          );
  }
}
