import 'package:flutter/material.dart';
import '../models/common_models.dart';
import './components/avatar.dart';

class MessagePage extends StatefulWidget {
  MessagePage({ Key key }) : super(key: key);

  @override
  _MessagePageState createState() => new _MessagePageState();
}



class _MessagePageState extends State<MessagePage> {
  List<MessageModel> messages = [
    new MessageModel("123", "许启迪", "吃饭了没吃饭了没吃饭了没吃饭了没吃饭了没吃饭了没吃饭了没吃饭了没吃饭了没吃饭了没吃饭了没", "一小时前", "default"),
    new MessageModel("123", "许启迪", "吃饭了没", "一小时前", "default"),
    new MessageModel("123", "许启迪", "吃饭了没", "一小时前", "default"),
    new MessageModel("123", "许启迪", "吃饭了没", "一小时前", "default"),
    new MessageModel("123", "许启迪", "吃饭了没", "一小时前", "default"),
  ];

  int count = 1;
  PersistentBottomSheetController c;

  void addMessage (MessageModel m) {
    setState(() {
      messages.add(m);
      count ++;
    });
  }

  void updateController (PersistentBottomSheetController newc) {
    setState(() {
          c = newc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      shrinkWrap: true,
      children: this.messages.map((MessageModel m) {
        return new InkWell(
          onTap: () {
            try {
              c.close();
            } catch (e) {
            }
            this.addMessage(new MessageModel("123", "许启迪$count", "吃饭了没", "一小时前", "default"));
          },
          onLongPress: () {
            PersistentBottomSheetController c = showBottomSheet(
              context: context,
              builder: (builder) {
                return new InkWell(
                  onTap: () {},
                  child: new Container(child: new Text("删除"),),
                );
              }
            );
            this.updateController(c);
          },
          child: new Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Color(0xeeeeeeeeee))
              )
            ),
            child: new ListTile(
              leading: buildAvatar(m.avatar, 50.0),
              title: new DefaultTextStyle(
                style: new TextStyle(
                  fontSize: 18.0,
                  color: Colors.black
                ),
                child: new Text(m.username),
              ),
              subtitle: new DefaultTextStyle(
                style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey
                ),
                child: new Text(
                  m.content,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: new DefaultTextStyle(
                style: new TextStyle(
                  fontSize: 10.0,
                  color: Colors.grey
                ),
                child: new Text(m.date),
              ),
            )
          )
        );
      }).toList(),
    );
  }
}