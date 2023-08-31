import 'package:baseballcodebreaker/services/ad_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globalVariables.dart';
import 'navigation/myHome.dart';

void main() async {
  // SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitUp,
  //   ],
  // );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(0, 0, 0, 1),
      // statusBarColor: Color.fromRGBO(255, 0, 0, 1),
      // systemNavigationBarColor: Color.fromRGBO(0, 0, 0, 1),
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  await Firebase.initializeApp();
  obtainSharedPreferences();
  final adState = AdState(initFuture);

  // Set Ads behaviour data stored in storage
  // Use it here - Don't remove anyway
  final prefs = await SharedPreferences.getInstance();
  initialiseAdsData(prefs); // Controlled By firebase

  runApp(
    Provider.value(
      value: adState,
      builder: (context, child) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baseball Codebreaker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: MyHome(),
      ),
    );
  }
}
