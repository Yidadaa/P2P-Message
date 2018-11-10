import 'package:flutter/material.dart';

import './message.dart';
import './contacts.dart';

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