import 'package:flutter/material.dart';
import 'package:isc/provider/theme_provider.dart';
import 'package:provider/provider.dart';

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
    dynamic theme = Provider.of<ThemeProvider>(context);
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
            color: theme.checkTheme(
                Colors.grey.shade100, Colors.purple.shade700, context)),
        child: Row(children: [
          Icon(
            icon,
            color: theme.checkTheme(
                kPrimaryColor, Colors.purple.shade100, context),
            size: size.width * 0.08,
          ),
          Expanded(
            child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 20,
                      color: theme.checkTheme(
                          Colors.black, Colors.white, context)),
                )),
          ),
          Icon(
            Icons.navigate_next_outlined,
            color: theme.checkTheme(
                kPrimaryColor, Colors.purple.shade100, context),
            size: size.width * 0.09,
          ),
        ]),
      ),
    );
  }
}
