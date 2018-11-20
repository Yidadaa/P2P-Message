import 'dart:io';
import 'dart:convert';

class P2PClient {
  Map<String, List> events = {}; // 用于响应监听的事件
  int udpSendPort = 1234;
  int udpRecvPort = 4321;

  var sendSocket;
  var recvSocket;

  void addEventListener(String eventName, Function callback) {
    if (events.containsKey(eventName)) {
      events[eventName].add(callback);
    } else {
      events[eventName] = [callback];
    }
  }

  void removeEventListener(String eventName, Function callback) {
    if (events.containsKey(eventName)) {
      events[eventName].remove(callback);
    }
  }

  void send(String targetIP, int targetPort, String msg) {
    sendSocket.then((socket) {
      socket.send(Utf8Encoder().convert(msg), InternetAddress(targetIP), targetPort);
    });
  }

  P2PClient () {
    sendSocket = RawDatagramSocket.bind(InternetAddress.LOOPBACK_IP_V4, udpSendPort);
    recvSocket = RawDatagramSocket.bind(InternetAddress.LOOPBACK_IP_V4, udpRecvPort);

    recvSocket.then((socket) {
      // 监听套接字事件
      socket.listen((event) {
        if (event == RawSocketEvent.READ) {
          String s = Utf8Decoder().convert(socket.receive().data);
          try {
            Map data = jsonDecode(s);
            if (events.containsKey(data['name'])) {
              for (var f in events[data['name']]) {
                f(data['payload']);
              }
            }
          } catch (e) {
            print('Error on ' + s);
          }
        }
      });
    });
  }
}