import 'package:flutter/material.dart';
import 'package:isc/constants.dart';
import 'package:isc/screens/registration.dart';
import 'login_screen.dart';
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
                  "LOGIN", kPrimaryColor, Colors.white, size,(){Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return LoginScreen();
            }),
          );} ,context),
          
              RoundedButton(
                  "SIGN UP", kPrimaryLightColor, Colors.black, size,(){Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return RegistrationScreen();
            }),
          );} ,context)
            ],
          ),
        ),
      ),
    );
  }
}
