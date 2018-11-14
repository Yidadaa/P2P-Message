import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:p2pmessage/utils/navigate.dart';
import 'package:p2pmessage/utils/api.dart' as api;

import './components/avatar.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({Key key}) : super(key: key);

  @override
  _ContactsPageState createState() => new _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with WidgetsBindingObserver {
  List<Map> friends = [];
  Map myProfile;

  Map<String, List<Map>> friendGroup = {};

  List<String> sortedKeys = [];

  void addFriend(Map f) {
    setState(() {
      // do something
    });
  }

  void loadContacts() async {
    if (myProfile == null) return;
    List contacts = await api.collectContacts(myProfile['id']);
    setState(() {
      this.friends = contacts;
    });
    this.groupFriends();
  }

  void groupFriends() {
    Map<String, List<Map>> newGroup = {};

    for (var f in friends) {
      var name = f['name'];
      if (name.length > 0) {
        if (newGroup.containsKey(name[0])) {
          newGroup[name[0]].add(f);
        } else {
          newGroup[name[0]] = [f];
        }
      }
    }

    setState(() {
      friendGroup = newGroup;
      sortedKeys = newGroup.keys.toList()..sort();
    });
  }

  List<Widget> _buildFriendGroup(String key, List<Map> fl) {
    return [
      new ListTile(
        leading: new DefaultTextStyle(
          style: new TextStyle(fontSize: 16.0, color: Colors.black),
          child: new Text(key),
        ),
      ),
    ]..addAll(fl.map((Map f) {
        return new InkWell(
          onTap: () {
            navigateTo(context, '/user', f);
          },
          child: new ListTile(
            leading: buildAvatar(f['avatar'], 50.0),
            title: new DefaultTextStyle(
              style: new TextStyle(fontSize: 18.0, color: Colors.black),
              child: new Text(f['name']),
            ),
            subtitle: new DefaultTextStyle(
              style: new TextStyle(fontSize: 14.0, color: Colors.grey),
              child: new Text('几小时前'),
            ),
          ),
        );
      }).toList());
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      String userProfileStr = prefs.getString('user');
      if (userProfileStr == null) redirectTo(context, '/login', null);
      else {
        setState(() {
          Map userProfileJson = jsonDecode(userProfileStr);
          myProfile = userProfileJson;
        });
        this.loadContacts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> lists = [];
    for (var key in sortedKeys) {
      lists.addAll(this._buildFriendGroup(key, friendGroup[key]));
    }
    return new Scaffold(
        body: new ListView(
          children: lists,
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            // Todo: 添加朋友
          },
          child: new Icon(Icons.add),
        ));
  }
}
