// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/local_storage.dart';
import 'package:jara_market/config/routes.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:overlay_kit/overlay_kit.dart';
// import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   // await InAppWebViewController.setWebContentsDebuggingEnabled(true); // Optional
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  DataBase dataBase = Get.put(DataBase());
  var token = await dataBase.getToken();
  String initialRoute = token.isNotEmpty ? '/main_screen' : '/splash_screen';
  runApp(MyApp(initialRoute: initialRoute));

  //   .then((value) {
  // Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
  ;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.initialRoute}) : super(key: key);
  final String initialRoute;
  @override
  Widget build(BuildContext context) {
    return OverlayKit(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Auth App',
        theme: ThemeData(
          primaryColor: const Color(0xFFFFAA00),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Roboto',
          //fontFamilyFallback: ['Roboto'],
        ),
        // home: const SplashScreen(),
        initialRoute: initialRoute,
        getPages: AppRoutes.pages,
      ),
    );
  }
}
