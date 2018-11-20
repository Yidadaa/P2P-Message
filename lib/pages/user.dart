import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import 'package:p2pmessage/utils/navigate.dart';
import 'package:p2pmessage/utils/api.dart' as api;
import 'package:p2pmessage/utils/text.dart' as text;
import 'package:p2pmessage/utils/time.dart' as time;

import './components/avatar.dart';

class UserPage extends StatefulWidget {
  UserPage({Key key, this.params}) : super(key: key);

  final Map params;

  @override
  _UserPageState createState() => new _UserPageState(params);
}

class _UserPageState extends State<UserPage> {
  Map userProfile = {};
  bool isMe = false;
  bool isEdit = false;

  String avatar;
  String address;
  String email;

  _UserPageState(Map params) {
    userProfile = params;
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      String userProfileStr = prefs.getString('user');
      if (userProfileStr == null)
        redirectTo(context, '/login', null);
      else {
        Map userProfileJson = jsonDecode(userProfileStr);
        setState(() {
          isMe = userProfile['id'] == userProfileJson['id'];
          email = userProfile['email'];
          address = userProfile['address'];
          avatar = userProfile['avatar'];
        });
      }
    });
  }

  void toggleEdit(bool status) {
    setState(() {
      isEdit = status;
    });
  }

  void updateAvatar(String avatar) {
    setState(() {
      this.avatar = avatar;
    });
    print(avatar);
  }

  void updateProfile() {
    setState(() {
      userProfile['email'] = email;
      userProfile['address'] = address;
      userProfile['avatar'] = avatar;
      print(userProfile);
    });
  }
  Widget buildInfoList(String name, String value, Icon icon) {
    bool couldEdit = !(name == 'ID');

    return new InkWell(
      onTap: () {},
      child: new Container(
        padding: EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
        child: (isEdit && couldEdit)
          ? new ListTile(
            leading: icon,
            title: new TextField(
              controller: new TextEditingController(text: value),
              onChanged: (v) {
                if (name == 'email') {
                  this.email = v;
                } else {
                  this.address = v;
                }
              },
              decoration: InputDecoration(
                hintText: value,
                labelText: name
              ),
            ),
          )
          : new ListTile(
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

    var id = userProfile == null ? '' : userProfile['id'];
    var name = userProfile == null ? '' : userProfile['name'];
    var statusText = (userProfile['status'] ?? 0) == 0
      ? time.fromNow(userProfile['last_online'] ?? 0) + '在线'
      : '当前在线';

    AppBar appBar = new AppBar(
        title: new Text("个人主页"),
        elevation: 1.0,
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Share.share(
                isMe
                ? "来试试洞见密信吧，超安全的p2p聊天应用哦！我的洞见id：$id，复制后打开洞见密信，就能加我为好友哦~"
                : "向您分享洞见用户$name (洞见id：$id )，复制后打开洞见密信即可添加~");
            },
            child: new Icon(
              Icons.share,
              color: Colors.white,
            ),
          )
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(appBarHeight),
            child: new Container(
                padding: EdgeInsets.only(bottom: 20.0),
                child: new ListTile(
                  leading: InkWell(
                    child: buildAvatar(avatar ?? '', 50.0),
                    onTap: () async {
                      if (!isMe) return;
                      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                      var res = await api.uploadImg(userProfile['id'], image);
                      if (res['success']) {
                        this.updateAvatar(res['img_url']);
                      } else {
                        print('出错了: ' + res['msg']);
                      }
                    },
                  ),
                  title: new DefaultTextStyle(
                    style: new TextStyle(color: Colors.white, fontSize: 18.0),
                    child: new Text(
                        userProfile == null ? '' : userProfile['name']),
                  ),
                  subtitle: new DefaultTextStyle(
                    style: new TextStyle(color: Colors.white70, fontSize: 15.0),
                    child: new Text(statusText),
                  ),
                ))));

    return new Stack(
      children: <Widget>[
        new Scaffold(
            appBar: appBar,
            body: new ListView(
              children: <Widget>[
                this.buildInfoList(
                    "ID",
                    userProfile == null
                        ? ''
                        : text.fillZero(userProfile['id'], 8),
                    new Icon(
                      Icons.code,
                      size: 30.0,
                    )),
                this.buildInfoList(
                    "email",
                    userProfile == null ? '' : userProfile['email'] ?? '无',
                    new Icon(
                      Icons.alternate_email,
                      size: 30.0,
                    )),
                this.buildInfoList(
                    "address",
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
              } else if (!isEdit) {
                toggleEdit(true);
              } else {
                // 弹窗确认
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('确认'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text('确认修改您的信息？')
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        FlatButton(child: Text('确认'), onPressed: () async {
                          // TODO: 发送请求
                          var res = await api.updateUser(userProfile['id'], {
                            'email': email,
                            'address': address,
                            'avatar': avatar
                          });
                          if (res['success']) {
                            this.updateProfile();
                            Navigator.of(context).pop();
                          } else {
                            print('出错了');
                          }
                          toggleEdit(false);
                        },),
                        FlatButton(child: Text('算了'), onPressed: () {
                          Navigator.of(context).pop();
                          toggleEdit(false);
                        },)
                      ],
                    );
                  },
                );
              }
            },
            backgroundColor: Colors.white,
            elevation: 1.0,
            child: new Icon(
              isMe ? isEdit ? Icons.check : Icons.edit : Icons.chat,
              color: Colors.blueGrey,
            ),
          ),
        )
      ],
    );
  }
}
