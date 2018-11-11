import 'package:flutter/material.dart';

import './message.dart';
import './contacts.dart';
import './components/avatar.dart';

class TabWithName {
  Tab tab;
  Widget view;

  TabWithName (String name, Widget view) {
    this.tab = new Tab(text: name,);
    this.view = view;
  }
}

List<TabWithName> tabs = [
  new TabWithName("消息", new MessagePage()),
  new TabWithName("联系人", new ContactsPage())
];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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
            new FlatButton(
              onPressed: () {},
              child: new Icon(Icons.search, color: Colors.white,),
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
