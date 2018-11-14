import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p2pmessage/utils/navigate.dart';
import 'package:p2pmessage/utils/api.dart' as api;
import 'package:shared_preferences/shared_preferences.dart';

import './components/avatar.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.params}) : super(key: key);

  final Map params;

  @override
  _ChatPageState createState() => new _ChatPageState(params);
}

class _ChatPageState extends State<ChatPage> {
  List<Map> messages = [];
  final textController = TextEditingController();

  Map toUserProfile;
  Map myProfile;

  _ChatPageState(Map toUserProfile) {
    this.toUserProfile = toUserProfile;
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      String userProfileStr = prefs.getString('user');
      if (userProfileStr == null) redirectTo(context, '/login', null);
      else {
        Map userProfileJson = jsonDecode(userProfileStr);
        setState(() {
          myProfile = userProfileJson;
        });
      }
    });
  }

  Widget buildChatMessages(BuildContext context) {
    return new ListView(
      reverse: true,
      children: messages.map((Map m) {
        bool isme = m['from_userid'] == (myProfile == null ? 'me' : myProfile['id']);
        Widget message = new Flexible(
            child: new Align(
          alignment:
              isme ? FractionalOffset.centerRight : FractionalOffset.centerLeft,
          child: new Container(
            padding: isme
                ? EdgeInsets.only(left: 80.0, right: 10.0, bottom: 10.0)
                : EdgeInsets.only(left: 10.0, right: 80.0, bottom: 10.0),
            child: new Card(
                color: isme ? Colors.blueGrey : Colors.white,
                child: new InkWell(
                  onLongPress: () {
                    SnackBar s = new SnackBar(
                      content: Text("已将该条消息复制到剪切板"),
                      action: new SnackBarAction(
                        label: "知道了",
                        onPressed: () {
                          Scaffold.of(context).removeCurrentSnackBar();
                        },
                      ),
                    );
                    Clipboard.setData(new ClipboardData(text: m['content']));
                    Scaffold.of(context).showSnackBar(s);
                  },
                  child: new Padding(
                    padding: EdgeInsets.all(10.0),
                    child: new DefaultTextStyle(
                      style: new TextStyle(
                          fontSize: 16.0,
                          color: isme ? Colors.white : Colors.black),
                      child: new Text(m['content']),
                    ),
                  ),
                )),
          ),
        ));
        Widget avatar = buildAvatar(m['avatar'], 50.0);
        return new Row(
          children: [message],
        );
      }).toList(),
    );
  }

  void addMessage() {
    String ts = new DateTime.now().millisecondsSinceEpoch.toString();
    String text = textController.text;
    Map msg = {
      'from_userid': myProfile['id'],
      'to_userid': toUserProfile['id'],
      'content': text,
      'ts': ts
    };
    if (text.length > 0) {
      setState(() {
        messages.insert(0, msg);
        textController.clear();
        api.send(myProfile['id'], toUserProfile['id'], text, ts);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          titleSpacing: 0.0,
          elevation: 1.0,
          title: new Container(
            child: new DefaultTextStyle(
              style: new TextStyle(fontSize: 18.0, color: Colors.white),
              child: new Text(toUserProfile['name'] ?? ''),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                navigateTo(context, '/user', toUserProfile);
              },
              child: new Icon(
                Icons.person,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: Builder(
          builder: (context) => Column(children: <Widget>[
                new Flexible(
                  child: new Center(
                    child: messages.length == 0
                        ? new Text("暂无消息")
                        : buildChatMessages(context),
                  ),
                ),
                new Divider(
                  color: Colors.black12,
                  height: 1.0,
                ),
                new Row(
                  children: <Widget>[
                    new Flexible(
                      child: new TextField(
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          autofocus: false,
                          controller: textController,
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.black),
                          decoration: new InputDecoration(
                              hintText: "说点什么...",
                              contentPadding: EdgeInsets.all(15.0),
                              border: InputBorder.none)),
                    ),
                    new InkWell(
                      onTap: () {
                        this.addMessage();
                      },
                      child: new Padding(
                        padding: EdgeInsets.all(15.0),
                        child: new Icon(
                          Icons.send,
                          color: Colors.blueAccent,
                        ),
                      ),
                    )
                  ],
                )
              ]),
        ));
  }
}
