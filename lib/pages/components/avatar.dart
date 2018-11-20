import 'package:flutter/material.dart';

Widget buildAvatar(String s, num size) {
  // 如果s不是网址，则设置为默认头像
  bool isImg = s.startsWith('http') || s.startsWith('https');

  return new ClipRRect(
    borderRadius: const BorderRadius.all(const Radius.circular(100.0)),
    child: isImg
    ? new Image.network(
      s, width: size, height: size,
    )
    : new Container(
      width: size,
      height: size,
      color: Colors.black12,
    ),
  );
}
