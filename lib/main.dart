import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:p2pmessage/pages/home.dart';
import 'package:p2pmessage/pages/login.dart';
import 'package:p2pmessage/utils/api.dart' as api;

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

class _LogicPageState extends State<LogicPage> with WidgetsBindingObserver {
  bool hasLogin = false;

  void firstStart() async {
    await api.initDB();
    SharedPreferences.getInstance().then((prefs) {
      String userProfile = prefs.getString('user');
      setState(() {
        hasLogin = userProfile == null ? false : userProfile.isNotEmpty;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    this.firstStart();
  }

  @override
  Widget build(BuildContext context) {
    return hasLogin ? new MyHomePage() : new LoginPage();
  }
}