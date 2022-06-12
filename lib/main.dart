import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:parents_app_flutter/common/signup.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:parents_app_flutter/admin/BasePageAdmin.dart';
import 'package:parents_app_flutter/children/main_child.dart';
import 'package:parents_app_flutter/children/main_paint.dart';
import 'package:parents_app_flutter/common/login.dart';
import 'package:parents_app_flutter/common/welcome.dart';
import 'package:parents_app_flutter/utils/connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FirbaseMessaging.dart';
import 'notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  PushNotificationsManager().init();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogin = prefs.getBool('isLogin') ?? false;
  bool isAdmin = prefs.getBool('isAdmin') ?? false;
  Conn.token = prefs.getString('token') ?? "";
  var landscape = [
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ];
  var portrait = [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown];
  if (isLogin) {
    SystemChrome.setPreferredOrientations(isAdmin ? portrait : landscape);
  } else {
    SystemChrome.setPreferredOrientations(portrait);
  }

  runApp(
    OverlaySupport(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        routes: {
          '/': (context) => isLogin
              ? isAdmin
              ? BasePageAdmin()
              : MainChild()
              : WelcomePage(),
          '/login': (context) => LoginPage(),
          '/child': (context) => Directionality(
              textDirection: TextDirection.rtl, child: MainChild()),
          '/admin': (context) => Directionality(
              textDirection: TextDirection.rtl, child: BasePageAdmin()),
          '/sign_up': (context) => SignUpPage(),
          '/main_paint': (context) => MainPaint(),
        },
      ),
    ),
  );
}
