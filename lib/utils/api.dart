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

collectMessages(int userid) async {
  var res = await post('/messages', { 'userid': userid.toString() });
  if (res['success']) {
    List ms = res['data'];
    return ms.map((m) {
      return {
        'id': m['id'],
        'status': m['status'],
        'content': m['content'],
        'user': {
          'id': m['user']['id'],
          'avatar': m['user']['avatar'],
          'name': m['user']['name'],
          'address': m['user']['address'],
          'email': m['user']['email']
        }
      };
    }).toList();
  }
  return [];
}

collectContacts(int userid) async {
  var res = await post('/contacts', { 'userid': userid.toString() });
  List<String> keys = ['id', 'name', 'avatar', 'address', 'email'];
  if (res['success']) {
    List ms = res['data'];
    return ms.map((m) {
      Map u = {};
      for (var k in keys) {
        u[k] = m[k];
      }
      return u;
    }).toList();
  }
  return [];
}

send(int fromUserid, int toUserid, String content, String ts) async {
  var res = await post('/send', {
    'from_userid': fromUserid.toString(),
    'to_userid': toUserid.toString(),
    'content': content,
    'ts': ts
  });

  return res['success'];
}