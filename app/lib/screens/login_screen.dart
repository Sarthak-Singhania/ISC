import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isc/constants.dart';
import 'package:isc/components/roundedbutton.dart';
import 'package:isc/routes.dart';

import 'package:isc/user-info.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  Future? myFuture;
  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool passwordVisible = false;

  final _auth = FirebaseAuth.instance;
  late final snapShot;
  String? errorMessage;
  @override
  void initState() {
    super.initState();
  }

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        bool userVerified;
        await _auth
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((uid) async => {
                  userVerified = _auth.currentUser!.emailVerified,
                  if (userVerified)
                    {
                      snapShot = await FirebaseFirestore.instance
                          .collection('admin-users')
                          .doc(emailController.text)
                          .get(),
                      if (snapShot.exists)
                        {
                          StudentInfo.isAdmin = true,
                        }
                      else
                        {
                          StudentInfo.isAdmin = false,
                        },
                      Fluttertoast.showToast(msg: "Login Successful"),
                      Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.eventScreen, (route) => false)
                    }
                  else
                    {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.emailVerification)
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
      } catch (e) {
        Fluttertoast.showToast(msg: 'Something went wrong. Please retry.');
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: FutureBuilder(
            future: myFuture,
            builder: (context, snapshot) {
              return Stack(children: [
                Center(
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
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? kPrimaryLightColor
                                      : Colors.purple.shade300,
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
                                  if (!RegExp(
                                          "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
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
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 15, 20, 15),
                                  hintText: "Email",
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? kPrimaryLightColor
                                      : Colors.purple.shade300,
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
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
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
                          RoundedButton(
                              s: "LOGIN",
                              color: kPrimaryColor,
                              tcolor: Colors.white,
                              size: size,
                              func: () async {
                                if (await InternetConnectionChecker()
                                    .hasConnection) {
                                  myFuture = signIn();
                                  setState(() {});
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Please check your internet connection");
                                }
                                setState(() {});
                              }),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () async {
                                  if (emailController.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "Please enter your email id");
                                  } else {
                                    try {
                                      await _auth.sendPasswordResetEmail(
                                          email: emailController.text);
                                      Fluttertoast.showToast(
                                          msg:
                                              "Passsword reset link has been sent to ${emailController.text}",
                                          toastLength: Toast.LENGTH_LONG);
                                    } catch (e) {
                                      print(e);
                                    }
                                  }
                                },
                                child: AutoSizeText(
                                  "Forgot your password?",
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Don't have an account? "),
                              GestureDetector(
                                onTap: () async {
                                  Navigator.pushReplacementNamed(
                                      context, AppRoutes.registrationScreen);
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
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Colors.purple,
                      ))
                    : Container(),
              ]);
            }),
      ),
    );
  }
}
