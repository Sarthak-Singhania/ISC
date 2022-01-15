import 'package:flutter/material.dart';
import 'package:isc/constants.dart';
import 'package:isc/screens/event_screen.dart';
import 'package:isc/screens/profile_screen.dart';

class BottomNaviBar extends StatelessWidget {
  String? screen;
  BottomNaviBar(this.screen);

  @override
  Widget build(BuildContext context) {
    print(screen);
    final Size size = MediaQuery.of(context).size;
    return Container(
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EventScreen(adminCheck: true,)));
              },
              icon: Icon(
                Icons.home,
                size: size.width * 0.07,
                color: screen == 'event' ? kPrimaryColor : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              icon: Icon(
                Icons.person,
                size: size.width * 0.07,
                color: screen == 'profile' ? kPrimaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
