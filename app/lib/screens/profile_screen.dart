import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isc/components/profile_card.dart';
import 'package:isc/constants.dart';
import 'package:isc/provider/theme_provider.dart';
import 'package:isc/routes.dart';
import 'package:isc/user-info.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen();

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
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
        centerTitle: true,
        title: Text("Profile", style: TextStyle(color: kPrimaryColor)),
      ),
      // bottomNavigationBar: BottomNaviBar('profile'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Container(
            //     margin: EdgeInsets.all(size.height * 0.05),
            //     child: CircleAvatar(
            //       backgroundColor: Colors.grey,
            //       radius: size.width * 0.15,
            //     )),
            // ProfileCard(
            //     size: size,
            //     text: 'Account',
            //     icon: Icons.account_box_outlined,
            //     func: () {}),
            SizedBox(
              height: size.height * 0.05,
            ),
            StudentInfo.isAdmin == false
                ? ProfileCard(
                    size: size,
                    text: 'Bookings',
                    icon: Icons.my_library_books_sharp,
                    func: () async {
                      Navigator.pushNamed(context, AppRoutes.bookingsScreen);
                    })
                : Container(),
            // ProfileCard(
            //     size: size,
            //     text: 'Settings',
            //     icon: Icons.settings,
            //     func: () {
            //       Navigator.pushNamed(context, AppRoutes.settingScreen);
            //     }),
            ProfileCard(
              size: size,
              text: 'Log Out',
              icon: Icons.login_outlined,
              func: () async {
                bool hasInternet =
                    await InternetConnectionChecker().hasConnection;
                if (hasInternet) {
                  await logout();
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.homeScreen, (route) => false);
                } else {
                  Fluttertoast.showToast(
                      msg: "Please check your internet connection");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
