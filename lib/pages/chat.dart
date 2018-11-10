import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './components/avatar.dart';
import '../models/common_models.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => new _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<MessageModel> messages = [
    new MessageModel("", "", "对方发的", "", "", "", "")
  ];
  final textController = TextEditingController();

  Widget buildChatMessages(BuildContext context) {
    return new ListView(
      reverse: true,
      children: messages.map((MessageModel m) {
        bool isme = m.from == "me";
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
                    Clipboard.setData(new ClipboardData(text: m.content));
                    Scaffold.of(context).showSnackBar(s);
                  },
                  child: new Padding(
                    padding: EdgeInsets.all(10.0),
                    child: new DefaultTextStyle(
                      style: new TextStyle(
                          fontSize: 16.0,
                          color: isme ? Colors.white : Colors.black),
                      child: new Text(m.content),
                    ),
                  ),
                )),
          ),
        ));
        Widget avatar = buildAvatar(m.avatar, 50.0);
        return new Row(
          children: [message],
        );
      }).toList(),
    );
  }

  void addMessage() {
    String text = textController.text;
    if (text.length > 0) {
      setState(() {
        messages.insert(0, new MessageModel("", "", text, "", "", "me", ""));
        textController.clear();
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
              child: new Text("许启迪"),
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, "/user");
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
