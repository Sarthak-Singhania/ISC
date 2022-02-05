import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isc/constants.dart';
import 'package:isc/provider/theme_provider.dart';
import 'package:isc/routes.dart';
import 'package:isc/components/roundedbutton.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          themeProvider.checkTheme(Color(0xFFF2F2F2), Colors.black, context),
      // systemNavigationBarColor: themeProvider.checkTheme(
      //     Colors.white, Colors.grey, context), // navigation bar color
      // statusBarColor: Colors.pink, // status bar color
      // statusBarBrightness: Brightness.dark,//status bar brigtness
      // statusBarIconBrightness:Brightness.dark , //status barIcon Brightness
      // systemNavigationBarDividerColor: Colors.greenAccent,//Navigation bar divider color
      // systemNavigationBarIconBrightness: Brightness.dark, //navigation bar icon
    ));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(
                flex: 2,
              ),
              Image.asset(
                'lib/assets/images/runner.png',
                fit: BoxFit.cover,
                width: size.width * 0.7,
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              RoundedButton(
                  s: "LOGIN",
                  color: kPrimaryColor,
                  tcolor: Colors.white,
                  size: size,
                  func: () {
                    Navigator.pushNamed(context, AppRoutes.loginScreen);
                  }),
              RoundedButton(
                  s: "SIGN UP",
                  color: kPrimaryLightColor,
                  tcolor: Colors.black,
                  size: size,
                  func: () {
                    Navigator.pushNamed(context, AppRoutes.registrationScreen);
                  }),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
