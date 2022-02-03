import 'package:flutter/material.dart';
import 'package:isc/constants.dart';
import 'package:isc/provider/theme_provider.dart';
import 'package:isc/screens/event_screen.dart';
import 'package:isc/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class BottomNaviBar extends StatefulWidget {
  BottomNaviBar();

  @override
  _BottomNaviBarState createState() => _BottomNaviBarState();
}

class _BottomNaviBarState extends State<BottomNaviBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final theme = Provider.of<ThemeProvider>(context);
    final screens = [EventScreen(), ProfileScreen()];
    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: kPrimaryColor,
            backgroundColor:
                theme.checkTheme(Colors.white, Colors.black, context),
            unselectedItemColor: Colors.grey,
            currentIndex: currentIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                label: 'hello',
                icon: Icon(
                  Icons.home,
                  size: size.width * 0.07,
                ),
              ),
              BottomNavigationBarItem(
                label: 'hello',
                icon: Icon(
                  Icons.person,
                  size: size.width * 0.07,
                ),
              ),
            ]));
  }
}

// Container(
//       child: SafeArea(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             IconButton(
//               onPressed: () {
//                 Navigator.pushReplacement(context,
//                     MaterialPageRoute(builder: (context) => EventScreen()));
//               },
//               icon: Icon(
//                 Icons.home,
//                 size: size.width * 0.07,
//                 color: screen == 'event' ? kPrimaryColor : Colors.grey,
//               ),
//             ),
//             IconButton(
//               onPressed: () {
//                 Navigator.pushReplacement(context,
//                     MaterialPageRoute(builder: (context) => ProfileScreen()));
//               },
//               icon: Icon(
//                 Icons.person,
//                 size: size.width * 0.07,
//                 color: screen == 'profile' ? kPrimaryColor : Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     )
