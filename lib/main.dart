// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/routes.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    //   .then((value) {
    // Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    ;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth App',
      theme: ThemeData(
        primaryColor: const Color(0xFFFFAA00),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      // home: const SplashScreen(),
      initialRoute: '/splash_screen',
      getPages: AppRoutes.pages,
    );
  }
}