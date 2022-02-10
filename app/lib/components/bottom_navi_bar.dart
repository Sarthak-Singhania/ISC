import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isc/constants.dart';
import 'package:isc/provider/theme_provider.dart';
import 'package:isc/screens/event_screen.dart';
import 'package:isc/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../routes.dart';

class BottomNaviBar extends StatefulWidget {
  BottomNaviBar();

  @override
  _BottomNaviBarState createState() => _BottomNaviBarState();
}

class _BottomNaviBarState extends State<BottomNaviBar> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: kSessionExpireTimeout), () async {
      print("hgya");
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.homeScreen, (route) => false);
    });
  }

  Future<bool?> showAlertDialog(){
     return showDialog(context: context, builder:(context){
        return AlertDialog(
          title: Text('Do you want to exit?'),
          actions: [TextButton(child: Text("CANCEL"),onPressed: (){Navigator.pop(context,false);},),
          TextButton(child: Text("YES"),onPressed: ()async{   await FirebaseAuth.instance.signOut();Navigator.pop(context,true);},)],
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final theme = Provider.of<ThemeProvider>(context);
    final screens = [EventScreen(), ProfileScreen()];
    return WillPopScope(
      onWillPop: ()async{
        final shouldPop=await showAlertDialog();
        return shouldPop??false;
      },
      child: Scaffold(
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
              ])),
    );
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
