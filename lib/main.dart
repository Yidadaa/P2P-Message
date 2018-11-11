import 'package:flutter/material.dart';

import './pages/home.dart';
import './pages/user.dart';
import './pages/chat.dart';
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
      initialRoute: '/login',
      routes: {
        '/': (context) => new MyHomePage(),
        '/user': (context) => new UserPage(),
        '/chat': (context) => new ChatPage(),
        '/login': (context) => new LoginPage()
      },
    );
  }
}

