import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String host = "http://192.168.1.100:80";
Database db;

// 初始化数据库
void initDB() async {
  var dbPath = await getDatabasesPath();
  dbPath = join(dbPath, 'app.db');

  await deleteDatabase(dbPath);

  db = await openDatabase(
    dbPath,
    version: 1,
    onCreate: (Database dataBase, int version) async {
      // MESSAGE
      //    status: 0:发送失败，1:已发送，2: 已阅读
      print('Init DataBase');
      await dataBase.execute(
        """
        CREATE TABLE MESSAGE (
            id          INTEGER UNIQUE
                                PRIMARY KEY ASC AUTOINCREMENT,
            from_userid INTEGER REFERENCES USER (id)
                                NOT NULL,
            to_userid   INTEGER REFERENCES USER (id)
                                NOT NULL,
            status      INT     DEFAULT (1),
            content     TEXT,
            ts          INTEGER
        );
        """
      );
    }
  );
}

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

  Map unReadMap = {};
  List unReadList = [];
  List toMergeList = [];

  if (res['success']) {
    List ms = res['data'];

    for (var m in ms) {
      toMergeList.add([m['id'], m['user']['id'], userid, m['content'], m['ts']]);

      if (unReadMap.containsKey(m['user']['id'])) {
        unReadMap[m['user']['id']]['latestMsgContent'] = m['content'];
        unReadMap[m['user']['id']]['latestMsgTs'] = m['ts'];
        unReadMap[m['user']['id']]['unReadCount'] ++;
      } else {
        unReadMap[m['user']['id']] = Map<String, dynamic>.from({
          'user': {
            'id': m['user']['id'],
            'avatar': m['user']['avatar'],
            'name': m['user']['name'],
            'address': m['user']['address'],
            'email': m['user']['email'],
            'last_online': m['user']['last_online'],
            'status': m['user']['status']
          },
          'latestMsgContent': m['content'],
          'latestMsgTs': m['ts'],
          'unReadCount': 1
        });
      }
    }
    // 将数据保存到本地数据库
    mergeMessageToDB(toMergeList);
    // 将map中的数组取出来
    for (var key in unReadMap.keys) {
      unReadList.add(unReadMap[key]);
    }
    unReadList.sort((a, b) => b['latestMsgTs'] - a['latestMsgTs']);
  }

  return unReadList;
}

collectContacts(int userid) async {
  var res = await post('/contacts', { 'userid': userid.toString() });
  List<String> keys = ['id', 'name', 'avatar', 'address', 'email', 'last_online', 'status'];
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

  if (res['success']) {
    var id = res['id'];
    mergeMessageToDB([[id, fromUserid, toUserid, content, int.parse(ts)]]);
  }

  return res['success'];
}

collectMessageFromDB(int userid) async {
  // 从本地数据库中读取聊天记录
  List<Map> list = await db.rawQuery(
    """
    SELECT * FROM MESSAGE WHERE from_userid = ${userid} OR to_userid = ${userid}
    """
  );

  return list.map((m) => new Map<String, dynamic>.from(m)).toList();
}

mergeMessageToDB(List msgs) async {
  // 将未读消息合并到本地数据库
  var sql = '''
    INSERT OR REPLACE INTO MESSAGE (id, from_userid, to_userid, content, ts)
    VALUES (?, ?, ?, ?, ?)
  ''';
  var batch = db.batch();
  for (var msg in msgs) {
    batch.rawInsert(sql, msg);
  }
  await batch.commit();
}