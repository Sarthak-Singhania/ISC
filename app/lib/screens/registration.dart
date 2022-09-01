import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:isc/constants.dart';
import 'package:isc/routes.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  final emailController = new TextEditingController();
  final nameController = new TextEditingController();
  final passwordController = new TextEditingController();
  final confirmPasswordController = new TextEditingController();
 Future? myFuture;

  Future<void> signUp(String email, String password, String name) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });

        final docUser =
            FirebaseFirestore.instance.collection('users').doc(email);
        final emailData = {'Name': name};

        await docUser.set(emailData);
        Navigator.pushReplacementNamed(context, AppRoutes.emailVerification);
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.light
                            ? kPrimaryLightColor
                            : Colors.purple.shade300,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                          autofocus: false,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          //autofillHints: [AutofillHints.email],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Please Enter Your Email");
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please Enter a valid email");
                            }
                            if (!RegExp("\b*@snu\.edu.in\$",
                                    caseSensitive: false)
                                .hasMatch(value)) {
                              return ("Please enter your SNU email id");
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
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.light
                            ? kPrimaryLightColor
                            : Colors.purple.shade300,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                          autofocus: false,
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Please Enter Your Name");
                            }
                            if (!RegExp(
                                    r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$")
                                .hasMatch(value)) {
                              return ("Please Enter a valid name");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            emailController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.perm_identity_outlined),
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Name",
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.light
                            ? kPrimaryLightColor
                            : Colors.purple.shade300,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        autofocus: false,
                        controller: passwordController,
                        obscureText: true,
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
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.lock),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Password",
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.light
                            ? kPrimaryLightColor
                            : Colors.purple.shade300,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        autofocus: false,
                        controller: confirmPasswordController,
                        // autofillHints: [AutofillHints.password],

                        obscureText: true,
                        validator: (value) {
                          if (value != passwordController.text) {
                            return ("Password don't match");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          confirmPasswordController.text = value!;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.lock),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          hintText: "Confirm Password",
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      child: ElevatedButton(
                          child: Text('REGISTER'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                              size.width * 0.8,
                              size.height * 0.1,
                            ),
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            onPrimary: Colors.white,
                            primary: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(29)),
                          ),
                          onPressed: () async {
                            if (await InternetConnectionChecker()
                                .hasConnection) {
                              myFuture= signUp(emailController.text,
                                  passwordController.text, nameController.text);
                                  setState(() {
                                  });
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please check your internet connection");
                            }
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.loginScreen);
                          },
                          child: Text(
                            "Sign In",
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
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.blue,
                  ))
                : Container(),
          ]);
        },
      )),
    );
  }
}
