import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isc/components/bottom_navi_bar.dart';
import 'package:isc/constants.dart';
import 'package:isc/provider/theme_provider.dart';
import 'package:isc/screens/setting_screen.dart';
import 'package:isc/screens/user-info.dart';
import 'package:isc/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'booking_screen.dart';

class ProfileScreen extends StatefulWidget {
 
  ProfileScreen();

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //bool hasInternet = true;
  // StreamSubscription? subscription;
  @override
  void initState() {
    super.initState();

    // subscription = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) {
    //   hasInternet = result != ConnectivityResult.none;
    //   if (hasInternet) {
    //     print("internet hai");
    //   } else {
    //     print('nO internet');
    //   }
    // });
  }

  @override
  void dispose() {
    //subscription!.cancel();
    super.dispose();
  }

  Future<void> logout() async {
    print("signed out");
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    dynamic theme = Provider.of<ThemeProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.checkTheme(Colors.white, Colors.black, context),
        leading: BackButton(color: kPrimaryColor),
        centerTitle: true,
        title: Text("Profile", style: TextStyle(color: kPrimaryColor)),
      ),
      bottomNavigationBar: BottomNaviBar('profile'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.all(size.height * 0.05),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: size.width * 0.15,
                )),
            ProfileCard(
                size: size,
                text: 'Account',
                icon: Icons.account_box_outlined,
                func: () {}),
            StudentInfo.isAdmin==false?ProfileCard(
                size: size,
                text: 'Bookings',
                icon: Icons.my_library_books_sharp,
                func: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BookingScreen()));
                }):Container(),
            ProfileCard(
                size: size,
                text: 'Settings',
                icon: Icons.settings,
                func: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingScreen()));
                }),
            ProfileCard(
              size: size,
              text: 'Log Out',
              icon: Icons.login_outlined,
              func: () {
                logout();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

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
