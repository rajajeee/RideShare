import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ride_share/Constants/constants.dart';
import 'package:ride_share/Screens/LoginScreen.dart';
import 'package:ride_share/Screens/SignUp.dart';
import 'package:ride_share/Screens/Splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login",
      theme: ThemeData(
        primaryColor: Color(0xFF3366FF),
      ),
      routes: <String, WidgetBuilder>{
        Splash_screen: (BuildContext context) => SplashScreen(),
        Sign_in: (BuildContext context) => SignInPage(),
        Sign_up: (BuildContext context) => SignUpScreen(),
      },
      initialRoute: Splash_screen,
    );
  }
}
