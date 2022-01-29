import 'package:flutter/material.dart';
import 'package:isc/constants.dart';
import 'package:isc/routes.dart';
import 'package:isc/components/roundedbutton.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  })
            ],
          ),
        ),
      ),
    );
  }
}
