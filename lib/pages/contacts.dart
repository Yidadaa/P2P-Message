import 'package:flutter/material.dart';
import '../models//common_models.dart';
import './components/avatar.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({Key key}) : super(key: key);

  @override
  _ContactsPageState createState() => new _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage>
    with WidgetsBindingObserver {
  List<FriendModel> friends = [
    new FriendModel('id', '许启迪', '一小时前', 'default'),
    new FriendModel('id', '许启迪', '一小时前', 'default'),
    new FriendModel('id', '周之龙', '一小时前', 'default')
  ];

  Map<String, List<FriendModel>> friendGroup = {};

  List<String> sortedKeys = [];

  void addFriend(FriendModel f) {
    setState(() {
      this.friends.add(f);
      this.groupFriends();
    });
  }

  void groupFriends() {
    Map<String, List<FriendModel>> newGroup = {};

    for (var f in friends) {
      var name = f.username;
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

  List<Widget> _buildFriendGroup(String key, List<FriendModel> fl) {
    return [
      new ListTile(
        leading: new DefaultTextStyle(
          style: new TextStyle(fontSize: 16.0, color: Colors.black),
          child: new Text(key),
        ),
      ),
    ]..addAll(fl.map((FriendModel f) {
        return new InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/user");
          },
          child: new ListTile(
            leading: buildAvatar(f.avatar, 50.0),
            title: new DefaultTextStyle(
              style: new TextStyle(fontSize: 18.0, color: Colors.black),
              child: new Text(f.username),
            ),
            subtitle: new DefaultTextStyle(
              style: new TextStyle(fontSize: 14.0, color: Colors.grey),
              child: new Text(f.lastLogin),
            ),
          ),
        );
      }).toList());
  }

  @override
  void initState() {
    super.initState();
    this.groupFriends();
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
            this.addFriend(new FriendModel("ds", "张yia", "两分钟前", ""));
          },
          child: new Icon(Icons.add),
        ));
  }
}
