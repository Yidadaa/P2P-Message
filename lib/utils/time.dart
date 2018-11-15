String fromNow(int unixMills) {
  DateTime d = new DateTime.fromMillisecondsSinceEpoch(unixMills);
  DateTime now = new DateTime.now();

  var diff = now.difference(d);

  List table = [
    [diff.inSeconds, 60, '秒'],
    [diff.inMinutes, 60, '分钟'],
    [diff.inHours, 24, '小时'],
    [diff.inDays, 365, '天']
  ];

  String formatedString = '${d.year < now.year ? d.year : ''}-${d.month}-${d.day}';

  for (var t in table) {
    if (t[0] < t[1]) {
      formatedString = '${t[0]}${t[2]}前';
      break;
    }
  }

  return formatedString;
}