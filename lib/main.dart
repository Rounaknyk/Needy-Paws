import 'package:firebase_messaging/firebase_messaging.dart';
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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor: kBackgroundColor
      ),
      debugShowCheckedModeBanner: false,
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
