import 'package:flutter/material.dart';

Widget buildAvatar(String s, num size) {
  // 如果s不是网址，则设置为默认头像

  return new ClipRRect(
    borderRadius: const BorderRadius.all(const Radius.circular(100.0)),
    child: new Container(
      width: size,
      height: size,
      color: Colors.black12,
    ),
  );
}
