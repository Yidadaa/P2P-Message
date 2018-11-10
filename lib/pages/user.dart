import 'package:flutter/material.dart';
import './components/avatar.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  _UserPageState createState() => new _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Widget buildInfoList(String name, String value, Icon icon) {
    return new InkWell(
      onTap: () {},
      child: new Container(
        padding: EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
        child: new ListTile(
          leading: icon,
          title: new DefaultTextStyle(
            style: new TextStyle(fontSize: 16.0, color: Colors.grey),
            child: new Text(name),
          ),
          subtitle: new DefaultTextStyle(
            style: new TextStyle(fontSize: 24.0, color: Colors.black),
            child: new Text(value),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const num appBarHeight = 100.0;

    AppBar appBar = new AppBar(
        title: new Text("个人主页"),
        elevation: 1.0,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(appBarHeight),
            child: new Container(
                padding: EdgeInsets.only(bottom: 20.0),
                child: new ListTile(
                  leading: buildAvatar('', 50.0),
                  title: new DefaultTextStyle(
                    style: new TextStyle(color: Colors.white, fontSize: 18.0),
                    child: new Text("已大大撒"),
                  ),
                  subtitle: new DefaultTextStyle(
                    style: new TextStyle(color: Colors.white70, fontSize: 15.0),
                    child: new Text("几分钟前在线"),
                  ),
                ))));

    return new Stack(
      children: <Widget>[
        new Scaffold(
            appBar: appBar,
            body: new ListView(
              children: <Widget>[
                this.buildInfoList(
                    "电话",
                    "123412312",
                    new Icon(
                      Icons.phone,
                      size: 30.0,
                    )),
                this.buildInfoList(
                    "ID",
                    "sdfsedf222",
                    new Icon(
                      Icons.code,
                      size: 30.0,
                    )),
                this.buildInfoList(
                    "住址",
                    "fsdf ",
                    new Icon(
                      Icons.location_on,
                      size: 30.0,
                    )),
              ],
            )),
        new Positioned(
          right: 30.0,
          top: appBar.preferredSize.height - 5,
          child: new FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.white,
            elevation: 1.0,
            child: new Icon(
              Icons.chat,
              color: Colors.blueGrey,
            ),
          ),
        )
      ],
    );
  }
}
