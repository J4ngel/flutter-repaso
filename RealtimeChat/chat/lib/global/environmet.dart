import 'dart:io';

class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'http://192.168.1.13:3000/api'
      : 'http://localhost:3000/api';
  static String socketUrl = Platform.isAndroid
      ? 'http://192.168.1.13:3000/'
      : 'http://localhost:3000/';

  static String URL_WP =
      'https://graph.facebook.com/v17.0/111796265333356/messages';
  static String TK =
      'EAAL5XOByQBABOzfNlm5TZCvBAi8L3A1NYdwOmLi7aN61K5cr5ZCsGQQkNXtgseZBSCvLwroUgbk3dbnTcEHZBykjTGoiiAN0pxbbZBzS9yVeGsg9WGns9pW3g2iqMtDyVWJZAE1oSKgHTNAet69HezVAx9788oWCriFt8uUF81wJr84PZBDmraaT7Bjg2P36UE8AFqGaOGlVZAMHfZCxV';
}
