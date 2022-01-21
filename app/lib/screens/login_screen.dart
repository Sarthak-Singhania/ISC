import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isc/constants.dart';
import 'package:isc/components/roundedbutton.dart';
import 'package:isc/provider/theme_provider.dart';
import 'package:isc/screens/profile_screen.dart';

import 'package:isc/screens/registration.dart';
import 'package:isc/screens/time_slot.dart';
import 'package:provider/provider.dart';

import 'event_screen.dart';
import 'notification_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool passwordVisible = false;

  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;
  

  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        bool adminCheck=true;
        final snapShot = await FirebaseFirestore.instance.collection('admin-users').doc(email).get();

   if (snapShot.exists){
        adminCheck=true;
   }
   else{
        adminCheck=false;
   }
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                  if(adminCheck){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => EventScreen(adminCheck: true,))),
                  }
                  else{
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => EventScreen(adminCheck: false,))),
                  }
                  
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    dynamic theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Container(
        child: Center(
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: theme.checkTheme(
                          kPrimaryLightColor, Colors.purple.shade300, context),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                        autofocus: false,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: [AutofillHints.email],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter Your Email");
                          }
                          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please Enter a valid email");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.mail),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Email",
                        )),
                  ),
            
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: theme.checkTheme(
                          kPrimaryLightColor, Colors.purple.shade300, context),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      autofocus: false,
                      controller: passwordController,
                      obscureText: !passwordVisible,
                      autofillHints: [AutofillHints.password],
                     onEditingComplete: () {
                        TextInput.finishAutofillContext();
                      },
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return ("Password is required for login");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Password(Min. 6 Character)");
                        }
                      },
                      onSaved: (value) {
                        passwordController.text = value!;
                      },
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  RoundedButton("LOGIN", kPrimaryColor, Colors.white, size, () {
                    signIn(emailController.text, passwordController.text);
                  }, context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationScreen()));
                        },
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
