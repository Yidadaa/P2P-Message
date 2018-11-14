String fillZero(int src, int maxLength) {
  String srcStr = src.toString();

  for (int i = 0; i < maxLength - srcStr.length; i++) {
    srcStr = '0' + srcStr;
  }

  return srcStr;
}