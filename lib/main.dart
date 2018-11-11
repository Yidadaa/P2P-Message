import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './pages/home.dart';
import './pages/login.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '洞间密信',
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new LogicPage(),
    );
  }
}

class LogicPage extends StatefulWidget {
  LogicPage({Key key}) : super(key: key);

  @override
  _LogicPageState createState() => new _LogicPageState();
}

class _LogicPageState extends State<LogicPage> {
  bool hasLogin = false;

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      String userProfile = prefs.getString('user');
      print(userProfile);
      setState(() {
        hasLogin = userProfile == null ? false : userProfile.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return hasLogin ? new MyHomePage() : new LoginPage();
  }
}