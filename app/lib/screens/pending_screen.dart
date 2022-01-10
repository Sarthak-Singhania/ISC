import 'dart:ui';

import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import 'package:simple_shadow/simple_shadow.dart';
import 'package:flutter/material.dart';


class PendingScreen extends StatelessWidget {
  const PendingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // TableRow tableRow1 = TableRow(children: [
    //   Padding(
    //     padding: EdgeInsets.fromLTRB(2, 15, 2, 15),
    //     child: Text(
    //       'S No.',
    //       style: TextStyle(fontSize: 20),
    //       textAlign: TextAlign.center,
    //     ),
    //   ),
    //   Padding(
    //     padding: EdgeInsets.fromLTRB(2, 15, 2, 15),
    //     child: Text(
    //       'Name',
    //       style: TextStyle(fontSize: 20),
    //       textAlign: TextAlign.center,
    //     ),
    //   ),
    // ]);
    // TableRow tableRow2 = TableRow(children: [
    //   Padding(
    //     padding: EdgeInsets.fromLTRB(2, 15, 2, 15),
    //     child: Text(
    //       '1.',
    //       style: TextStyle(fontSize: 20),
    //       textAlign: TextAlign.center,
    //     ),
    //   ),
    //   Padding(
    //     padding: EdgeInsets.fromLTRB(2, 15, 2, 15),
    //     child: Text(
    //       'Modiji',
    //       style: TextStyle(fontSize: 20),
    //       textAlign: TextAlign.center,
    //     ),
    //   ),
    // ]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(
          color: Color(0xffFF6109),
        ),
        title: Text(
          'Pending',
          style: TextStyle(color: Color(0xffFF6109), fontSize: 25),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.fromLTRB(0, 60, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Booking Id: 9999999",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  Spacer(),
                  Text(
                    "Date:69/68/1969",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.fromLTRB(0, 15, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Badminton",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Text(
                    "6:00AM - 7:00AM",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height * 0.1,
                      width: size.width * 0.2,
                      child: Center(
                          child: Text(
                        'S No.',
                        style: TextStyle(fontSize: 20),
                      )),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(15))),
                    ),
                    Container(
                      child: Center(
                          child: Text(
                        'Name',
                        style: TextStyle(fontSize: 20),
                      )),
                      height: size.height * 0.1,
                      width: size.width * 0.7,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(15))),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('1', style: TextStyle(fontSize: 20)),
                          Text('2', style: TextStyle(fontSize: 20)),
                          Text('3', style: TextStyle(fontSize: 20)),
                          Text('4', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      height: size.height * 0.35,
                      width: size.width * 0.2,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15))),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Tushar Mishra', style: TextStyle(fontSize: 20)),
                          Text('Tushar Mishra', style: TextStyle(fontSize: 20)),
                          Text('Tushar Mishra', style: TextStyle(fontSize: 20)),
                          Text('Tushar Mishra', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      height: size.height * 0.35,
                      width: size.width * 0.7,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15))),
                    )
                  ],
                ),
              ],
            ),

            Expanded(
              child: Container(
                height: size.height * 0.5,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 15,
                      left: 25,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: size.width * 0.8,
                        height: size.width * 0.17,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(-10.0, 5.0), //(x,y)
                                blurRadius: 10.0,
                              ),
                            ],
                            color: Color(0xFF5A62B0),
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(10, 10))),
                        child: Center(
                          child: Text(
                            'Sarthak Singhania has added you to the booking',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      left: 40,
                      child: ClipPath(
                        clipper: TriangleClipper(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF5A62B0),
                          ),
                          height: 15,
                          child: Text('    '),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Stack(alignment: Alignment.center, children: [
            //   Container(
            //     decoration: BoxDecoration(
            //         color: Color(0xFFFFFF),
            //         borderRadius: BorderRadius.only(
            //           topLeft: Radius.elliptical(10, 10),
            //           topRight: Radius.elliptical(10, 10),
            //           bottomLeft: Radius.elliptical(0, 0),
            //           bottomRight: Radius.elliptical(10, 10),
            //         )),
            //     margin: EdgeInsets.only(top: 5, left: 12),
            //     //padding: EdgeInset.only(left: 5, right: 10),
            //     alignment: Alignment.topLeft,
            //     child: SimpleShadow(
            //       child: SvgPicture.network(
            //           'lib/assets/images/Group 1.png'), //Image.asset('lib/assets/images/Group 3.png'),
            //       opacity: 0.8, // Default: 0.5
            //       color: Colors.black, // Default: Black
            //       offset: Offset(5, 5), // Default: Offset(2, 2)
            //       sigma: 7, // Default: 2
            //     ),
            //   ),
            //   Container(
            //     alignment: Alignment.topLeft,
            //     width: size.width * 0.8,
            //     child: Text('Sarthak Singhania has added you to the booking',
            //         style: TextStyle(color: Colors.white, fontSize: 15)),
            //   ),
            // ]),

            SizedBox(
              height: size.height * 0.01,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: size.height * 0.08,
                    child: Center(
                      child: Text(
                        'Deny',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0XFFFF0000),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, -3.0), //(x,y)
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: size.height * 0.08,
                    child: Center(
                      child: Text(
                        'Accept',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0XFF00FF19),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, -3.0), //(x,y)
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
