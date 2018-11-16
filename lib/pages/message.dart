import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:p2pmessage/utils/navigate.dart';
import 'package:p2pmessage/utils/api.dart' as api;
import 'package:p2pmessage/utils/time.dart' as time;

import './components/avatar.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key key, this.params}) : super(key: key);

  final Map params;

  @override
  _MessagePageState createState() => new _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List messages = [];

  PersistentBottomSheetController c;
  Map myProfile;

  void updateController(PersistentBottomSheetController newc) {
    setState(() {
      c = newc;
    });
  }

  void loadMessages() async {
    if (myProfile == null) return;
    List messages = await api.collectMessages(myProfile['id']);
    setState(() {
      this.messages = messages;
    });
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      String userProfileStr = prefs.getString('user');
      if (userProfileStr == null) redirectTo(context, '/login', null);
      else {
        setState(() {
          Map userProfileJson = jsonDecode(userProfileStr);
          myProfile = userProfileJson;
        });
        this.loadMessages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      onRefresh: () async {
        return this.loadMessages();
      },
      child: new ListView(
        shrinkWrap: true,
        children: this.messages.map((m) {
          return new InkWell(
              onTap: () {
                try {
                  c.close();
                } catch (e) {}
                navigateTo(context, '/chat', m['user']);
              },
              onLongPress: () {
                PersistentBottomSheetController c = showBottomSheet(
                    context: context,
                    builder: (builder) {
                      return new InkWell(
                        onTap: () {},
                        child: new Container(
                          child: new Text("删除"),
                        ),
                      );
                    });
                this.updateController(c);
              },
              child: new Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0, color: Color(0xeeeeeeeeee)))),
                  child: new ListTile(
                    leading: buildAvatar(m['user']['avatar'], 50.0),
                    title: new DefaultTextStyle(
                      style: new TextStyle(fontSize: 18.0, color: Colors.black),
                      child: new Text(m['user']['name']),
                    ),
                    subtitle: new DefaultTextStyle(
                      style: new TextStyle(fontSize: 14.0, color: Colors.grey),
                      child: new Text(
                        m['latestMsgContent'],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: new DefaultTextStyle(
                      style: new TextStyle(fontSize: 10.0, color: Colors.grey),
                      child: new Text(time.format(m['latestMsgTs']) ?? new DateTime.now()),
                    ),
                  )));
        }).toList(),
      ),
    );
  }
}
