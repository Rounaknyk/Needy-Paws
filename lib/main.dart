import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:needy_paw/Screens/add_animal_screen.dart';
import 'package:needy_paw/Screens/add_clinic_screen.dart';
import 'package:needy_paw/Screens/main_screen.dart';
import 'package:needy_paw/Screens/login_screen.dart';
import 'package:needy_paw/Screens/signup_screen.dart';
import 'package:needy_paw/Screens/splash_screen.dart';
import 'package:needy_paw/Screens/welcome_screen.dart';
import 'package:needy_paw/constants.dart';
import 'package:needy_paw/my_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:needy_paw/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: kBackgroundColor
      ),
      initialRoute: MyRoutes.splash,
      routes: {
        MyRoutes.splash: (context) => SplashScreen(),
        MyRoutes.login: (context) => LoginScreen(),
        MyRoutes.signup: (context) => SignupScreen(),
        MyRoutes.welcome: (context) => WelcomeScreen(),
        MyRoutes.main: (context) => MainScreen(data: MyRoutes.myData),
        MyRoutes.add_animal: (context) => AddAnimalScreen(),
        MyRoutes.add_clinic: (context) => AddClinicScreen(),
      },
    );
  }
}
