import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isc/components/bottom_navi_bar.dart';
import 'package:isc/components/profile_card.dart';
import 'package:isc/constants.dart';
import 'package:isc/provider/theme_provider.dart';
import 'package:isc/routes.dart';
import 'package:isc/screens/setting_screen.dart';
import 'package:isc/user-info.dart';
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
            StudentInfo.isAdmin == false
                ? ProfileCard(
                    size: size,
                    text: 'Bookings',
                    icon: Icons.my_library_books_sharp,
                    func: () async {
                      // bool hasInternet =
                      //     await InternetConnectionChecker().hasConnection;
                      // if (hasInternet) {
                        Navigator.pushNamed(context, AppRoutes.bookingsScreen);
                      // } else {
                      //   Fluttertoast.showToast(
                      //       msg: "Please check your internet connection");
                      // }
                    })
                : Container(),
            ProfileCard(
                size: size,
                text: 'Settings',
                icon: Icons.settings,
                func: () {
                  Navigator.pushNamed(context, AppRoutes.settingScreen);
                }),
            ProfileCard(
              size: size,
              text: 'Log Out',
              icon: Icons.login_outlined,
              func: () async {
                bool hasInternet =
                    await InternetConnectionChecker().hasConnection;
                if (hasInternet) {
                  logout();
                  Navigator.popUntil(context, ModalRoute.withName(AppRoutes.homeScreen));
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
