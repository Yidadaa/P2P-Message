import 'dart:convert';
import 'package:http/http.dart'as http;

final String host = "http://192.168.1.103:80";

// 通用post方法
post(String path, Map params) async {
  var resp = await http.post(host + path, body: params);
  Map error = {
    'success': false
  };
  try {
    var respJson = jsonDecode(resp.body);
    return respJson is Map ? respJson : error;
  } catch (e) {
    print(e);
    return error;
  }
}

login(String username, String pwd) async {
  return await post('/login', { 'username': username, 'password': pwd });
}

signin(String username, String pwd) async {
  return await post('/signin', { 'username': username, 'password': pwd });
}