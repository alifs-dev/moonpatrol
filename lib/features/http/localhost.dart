import 'dart:io';

import 'package:moonpatrol/utils/logger/debug_log.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    DebugLog.info('Activate localhost');
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
