import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:p2pmessage/utils/navigate.dart';
import 'package:p2pmessage/utils/text.dart' as text;

import './components/avatar.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key, this.params}) : super(key: key);

  final Map params;

  @override
  _UserPageState createState() => new _UserPageState(params);
}

class _UserPageState extends State<UserPage> {
  Map userProfile;
  bool isMe = false;

  _UserPageState(Map params) {
    userProfile = params;
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      String userProfileStr = prefs.getString('user');
      if (userProfileStr == null) redirectTo(context, '/login', null);
      else {
        Map userProfileJson = jsonDecode(userProfileStr);
        setState(() {
          isMe = userProfile['id'] == userProfileJson['id'];
        });
      }
    });
  }

  Widget buildInfoList(String name, String value, Icon icon) {
    return new InkWell(
      onTap: () {},
      child: new Container(
        padding: EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
        child: new ListTile(
          leading: icon,
          title: new DefaultTextStyle(
            style: new TextStyle(fontSize: 16.0, color: Colors.grey),
            child: new Text(name),
          ),
          subtitle: new DefaultTextStyle(
            style: new TextStyle(fontSize: 20.0, color: Colors.black54),
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
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Share.share("来试试洞见密信吧，超安全的p2p聊天应用哦！我的洞见id：sfsdfdss，复制后打开洞见密信，就能加我为好友哦~");
            },
            child: new Icon(Icons.share, color: Colors.white,),
          )
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(appBarHeight),
            child: new Container(
                padding: EdgeInsets.only(bottom: 20.0),
                child: new ListTile(
                  leading: buildAvatar('', 50.0),
                  title: new DefaultTextStyle(
                    style: new TextStyle(color: Colors.white, fontSize: 18.0),
                    child: new Text(userProfile == null ? '' : userProfile['name']),
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
                    "邮箱",
                    userProfile == null ? '' : userProfile['email'] ?? '无',
                    new Icon(
                      Icons.alternate_email,
                      size: 30.0,
                    )),
                this.buildInfoList(
                    "ID",
                    userProfile == null ? '' : text.fillZero(userProfile['id'], 8),
                    new Icon(
                      Icons.code,
                      size: 30.0,
                    )),
                this.buildInfoList(
                    "住址",
                    userProfile == null ? '' : userProfile['address'] ?? '无',
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
            onPressed: () {
              if (!isMe) {
                navigateTo(context, '/chat', userProfile);
              } else {
                // do something
              }
            },
            backgroundColor: Colors.white,
            elevation: 1.0,
            child: new Icon(
              isMe ? Icons.edit : Icons.chat,
              color: Colors.blueGrey,
            ),
          ),
        )
      ],
    );
  }
}
