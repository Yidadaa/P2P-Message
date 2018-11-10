
class FriendModel {
  String id;
  String username;
  String lastLogin;
  String avatar;

  FriendModel (String id, String username, String lastLogin, String avatar) {
    this.id = id;
    this.username = username;
    this.lastLogin = lastLogin;
    this.avatar = avatar;
  }
}

/**
 * 消息类
 */
class MessageModel {
  String id;
  String username;
  String content;
  String date;
  String avatar;
  String from;
  String to;

  MessageModel (String id, String username, String content, String date, String avatar, String from, String to) {
    this.id = id;
    this.username = username;
    this.content = content;
    this.date = date;
    this.avatar = avatar;
    this.from = from;
    this.to = to;
  }
}