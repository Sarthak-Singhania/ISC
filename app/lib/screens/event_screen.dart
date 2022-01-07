import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:isc/components/bottom_navi_bar.dart';
import 'package:isc/components/event_card.dart';
import 'package:isc/constants.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List Sports = [];
  List ImgUri = [];
  bool circP = true;
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var response = await http.get(Uri.parse('http://65.0.232.165/games'));
    Map<String, dynamic> jsonData = await jsonDecode(response.body);
    print(response.statusCode);
    jsonData.forEach((k, v) {
      Sports.add(k);
      ImgUri.add(v);
    });

    print(Sports[3]);
    circP = false;

    print(ImgUri[2]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: circP
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.blue,
            ))
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.purple[600]),
                    width: size.width,
                    height: size.height * 0.3,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.07,
                      ),
                      Text(
                        "SELECT YOUR SPORT",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemCount: Sports.length,
                        itemBuilder: (context, index) {
                          return EventCard(
                            title: Sports[index],
                            uri: ImgUri[index],
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
      bottomNavigationBar: BottomNaviBar('event'),
    );
  }
}
