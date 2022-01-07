import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:isc/constants.dart';
import 'package:isc/provider/theme_provider.dart';
import 'package:isc/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static ThemeMode theme = ThemeMode.system;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(create: (context)=>ThemeProvider(),builder: (context,_){
    final themeProvider= Provider.of<ThemeProvider>(context);
    return  MaterialApp(
      title: 'ISC',
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          brightness: Brightness.light),
      darkTheme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.black,
          brightness: Brightness.dark),
      themeMode:themeProvider.themeMode ,
      home: WelcomeScreen(),
    );
  },);
}
