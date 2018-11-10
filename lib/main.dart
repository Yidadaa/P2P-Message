import 'package:flutter/material.dart';

import './pages/index.dart';
import './pages/user.dart';
import './pages/components/avatar.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => new MyHomePage(title: '主页'),
        '/user': (context) => new UserPage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: tabs.length,
      child: new Scaffold(
        appBar: new AppBar(
          elevation: 1.0,
          title: new DefaultTextStyle(
            style: new TextStyle(
              fontSize: 16.0,
              color: Colors.white
            ),
            child: new Text("益达大西瓜"),
          ),
          titleSpacing: 0.0,
          leading: new Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10.0),
            child: new InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/user');
              },
              child: buildAvatar('', 40.0),
            )
          ),
          actions: <Widget>[
            new InkWell(
              onTap: () {},
              child: new Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: new Icon(Icons.search),
              ),
            )
          ],
          bottom: new TabBar(
            tabs: tabs.map((TabWithName t) {
              return t.tab;
            }).toList(),
            isScrollable: false
          ),
        ),
        body: new TabBarView(
          children: tabs.map((TabWithName t) {
            return t.view;
          }).toList()
        ),
      ),
    );
  }
}
