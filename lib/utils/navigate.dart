import 'package:flutter/widgets.dart';

import '../pages/home.dart';
import '../pages/user.dart';
import '../pages/chat.dart';
import '../pages/login.dart';

Map routes = {
  '/home': (context, params) => new MyHomePage(params: params),
  '/user': (context, params) => new UserPage(params: params),
  '/chat': (context, params) => new ChatPage(params: params),
  '/login': (context, params) => new LoginPage()
};

// 导航至指定页面
void navigateTo(BuildContext context, String path, Map params) {
  if (routes.containsKey(path)) {
    Navigator.of(context).push(new PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
      return routes[path](context, params);
    }));
  }
}

// 重定向至指定页面
void redirectTo(BuildContext context, String path, Map params) {
  if (routes.containsKey(path)) {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(pageBuilder:
        (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
      return routes[path](context, params);
    }));
  }
}