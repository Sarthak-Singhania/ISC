import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isc/constants.dart';
import 'package:isc/routes.dart';
import 'package:isc/components/roundedbutton.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          MediaQuery.of(context).platformBrightness == Brightness.light?Color(0xFFF2F2F2): Colors.black
    ));
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
