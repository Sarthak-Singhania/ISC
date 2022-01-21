import 'package:firebase_auth/firebase_auth.dart';
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

class MyApp extends StatefulWidget {
  static ThemeMode theme = ThemeMode.system;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement initState

    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }


  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    final isBackground = state == AppLifecycleState.detached;

    if (isBackground) {
      print("band");
      await FirebaseAuth.instance.signOut();
    }
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ISC',
            theme: ThemeData(
                primaryColor: kPrimaryColor,
                scaffoldBackgroundColor: Colors.white,
                brightness: Brightness.light),
            darkTheme: ThemeData(
                primaryColor: kPrimaryColor,
                scaffoldBackgroundColor: Colors.black,
                brightness: Brightness.dark),
            themeMode: themeProvider.themeMode,
            home: WelcomeScreen(),
          );
        },
      );
}
