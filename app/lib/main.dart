import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isc/constants.dart';
import 'package:isc/provider/notification_provider.dart';
import 'package:isc/routes.dart';
import 'package:isc/screens/admin_detail_screen.dart';
import 'package:isc/screens/booking_screen.dart';
import 'package:isc/screens/faq_screen.dart';
import 'package:isc/screens/user_detail_screen.dart';
import 'package:isc/screens/email_verfification.dart';
import 'package:isc/screens/event_screen.dart';
import 'package:isc/screens/login_screen.dart';
import 'package:isc/screens/notification_screen.dart';
import 'package:isc/screens/registration.dart';
import 'package:isc/screens/ticket_screen.dart';
import 'package:isc/screens/admin_time_slot.dart';
import 'package:isc/screens/user_time_slot.dart';
import 'package:isc/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create:(_)=>NotificationProvider()),
    ],
    child: MyApp()));
}

class MyApp extends StatefulWidget {
  static ThemeMode theme = ThemeMode.system;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement initState

    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    // final isBackground = state == AppLifecycleState.detached;

    if (state == AppLifecycleState.detached) {
      await FirebaseAuth.instance.signOut();
      print("band");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ISC',
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(color: kPrimaryColor),
          brightness: Brightness.light),
      darkTheme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(color: kPrimaryColor),
          brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.homeScreen,
      routes: {
        AppRoutes.homeScreen: (context) => WelcomeScreen(),
        AppRoutes.loginScreen: (context) => LoginScreen(),
        AppRoutes.registrationScreen: (context) => RegistrationScreen(),
        AppRoutes.eventScreen: (context) => EventScreen(),
        AppRoutes.adminTime: (context) => TimeSlot(),
        AppRoutes.adminDetail: (context) => AdminSlotScreen(),
        AppRoutes.studentTime: (context) => UserTimeSlot(),
        AppRoutes.studentDetail: (context) => DetailScreen(),
        AppRoutes.bookingsScreen: (context) => BookingScreen(),
        // AppRoutes.bottomNavigationScreen: (context) => BottomNaviBar(),
        AppRoutes.ticketScreen: (context) => TicketScreen(
              bookingId: ModalRoute.of(context)!.settings.arguments,
            ),
        AppRoutes.emailVerification: (context) => EmailVerification(),
        AppRoutes.notificationScreen: (context) => NotificationScreen(),
        AppRoutes.faqscreen: (context) => FaqScreen(),
      },
    );
  }
}
