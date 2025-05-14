// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/local_storage.dart';
import 'package:jara_market/config/routes.dart';
// import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auth App',
      theme: ThemeData(
        primaryColor: const Color(0xFFFFAA00),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Poppins',
      ),
      // home: const SplashScreen(),
      initialRoute: initialRoute,
      getPages: AppRoutes.pages,
    );
  }
}
