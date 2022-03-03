import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
    required this.size,
    required this.text,
    required this.icon,
    required this.func,
  }) : super(key: key);

  final Size size;
  final String text;
  final IconData icon;
  final Function func;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        func();
      },
      //  theme == ThemeMode.light ? Colors.grey[100] : Colors.purple[700],
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        width: size.width * 0.9,
        height: size.height * 0.07,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: MediaQuery.of(context).platformBrightness == Brightness.light?
                Colors.grey.shade100: Colors.purple.shade700),
        child: Row(children: [
          Icon(
            icon,
            color:MediaQuery.of(context).platformBrightness == Brightness.light?
                kPrimaryColor: Colors.purple.shade100,
            size: size.width * 0.08,
          ),
          Expanded(
            child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: AutoSizeText(
                  text,
                  style: TextStyle(
                      fontSize: 20,
                      color:MediaQuery.of(context).platformBrightness == Brightness.light?
                          Colors.black: Colors.white),
                )),
          ),
          Icon(
            Icons.navigate_next_outlined,
            color:MediaQuery.of(context).platformBrightness == Brightness.light?
                kPrimaryColor: Colors.purple.shade100,
            size: size.width * 0.09,
          ),
        ]),
      ),
    );
  }
}
