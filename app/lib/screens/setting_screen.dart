import 'package:flutter/material.dart';
import 'package:isc/constants.dart';
import 'package:isc/main.dart';
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
    bool systemDefault = provider.themeMode == ThemeMode.system ? true : false;
    bool light = provider.themeMode == ThemeMode.light ? true : false;
    bool dark = provider.themeMode == ThemeMode.dark ? true : false;
    dynamic theme = provider.themeMode;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme == ThemeMode.light ? Colors.white : Colors.black,
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
                Switch(
                  value: systemDefault,
                  onChanged: (value) {
                    if (systemDefault == false) {
                      setState(() {
                        systemDefault = true;
                        light = false;
                        dark = false;
                        provider.toggleSystemTheme();
                        //MyApp.theme = ThemeMode.system;
                      });
                    }
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
                Switch(
                  value: light,
                  onChanged: (value) {
                    if (light == false) {
                      setState(() {
                        systemDefault = false;
                        light = true;
                        dark = false;
                        provider.toggleLightTheme();
                        //MyApp.theme = ThemeMode.light;
                      });
                    }
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
                Switch(
                  value: dark,
                  onChanged: (value) {
                    if (dark == false) {
                      setState(() {
                        systemDefault = false;
                        light = false;
                        dark = true;
                        provider.toggleDarkTheme();
                        //MyApp.theme = ThemeMode.dark;
                      });
                    }
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
