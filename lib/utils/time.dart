import 'package:p2pmessage/utils/text.dart';

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

String format(dynamic unixMills) {
  DateTime d = new DateTime.fromMillisecondsSinceEpoch(int.parse(unixMills.toString()));
  DateTime now = new DateTime.now();

  String date = '';

  if (d.year < now.year) {
    date += fillZero(d.year, 4) + '-';
  } else if (d.day < now.day) {
    date += [fillZero(d.month, 2), fillZero(d.day, 2)].join('-') + ' ';
  } else {
    date += [d.hour, d.minute, d.second]
      .map((f) => fillZero(f, 2)).toList().join(':');
  }

  return date;
}