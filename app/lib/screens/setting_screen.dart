import 'package:flutter/material.dart';
import 'package:isc/constants.dart';

import 'package:isc/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    if (provider.themeMode == null) {
      provider.initalTheme();
    }

    int systemDefault = provider.themeMode == ThemeMode.system ? 1 : 0;
    int light = provider.themeMode == ThemeMode.light ? 1 : 0;
    int dark = provider.themeMode == ThemeMode.dark ? 1 : 0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:
            provider.checkTheme(Colors.white, Colors.black, context),
        leading: BackButton(color: kPrimaryColor),
        title: Text(
          'Settings',
          style: TextStyle(color: kPrimaryColor),
        ),
      ),
      body: Center(
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'System Default',
                      style: TextStyle(fontSize: 20),
                    )),
                Radio<int>(
                  value: 1,
                  groupValue: systemDefault,
                  onChanged: (val) {
                    setState(() {
                      systemDefault = 1;
                      light = 0;
                      dark = 0;
                      provider.toggleSystemTheme();
                      //MyApp.theme = ThemeMode.system;
                    });
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Light',
                      style: TextStyle(fontSize: 20),
                    )),
                Radio<int>(
                  value: 1,
                  groupValue: light,
                  onChanged: (val) {
                    setState(() {
                      systemDefault = 0;
                      light = 1;
                      dark = 0;
                      provider.toggleLightTheme();
                      //MyApp.theme = ThemeMode.system;
                    });
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Dark',
                      style: TextStyle(fontSize: 20),
                    )),
                Radio<int>(
                  value: 1,
                  groupValue: dark,
                  onChanged: (val) {
                    setState(() {
                      systemDefault = 0;
                      light = 0;
                      dark = 1;
                      provider.toggleDarkTheme();
                      //MyApp.theme = ThemeMode.system;
                    });
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
