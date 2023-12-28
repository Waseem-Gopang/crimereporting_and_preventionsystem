import 'package:crimereporting_and_preventionsystem/home.dart';
import 'package:crimereporting_and_preventionsystem/login_register/screens/forget_password.dart';
import 'package:crimereporting_and_preventionsystem/login_register/screens/login_screen.dart';
import 'package:crimereporting_and_preventionsystem/login_register/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// // ...
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //firebase
  //await Firebase.initializeApp();

  //awesome notifications
  // AwesomeNotifications().initialize(null,
  //     [NotificationChannel(
  //           channelKey: 'basic_channel',
  //           channelName: 'Basic notifications',
  //           channelDescription: 'Notification channel for basic tests',
  //           )],);

  runApp(const MyApp());
}

_init() async {
  // var log = logger();
  // log.i('App init');
  // var global = Global();
  // await global.init();
  // // to suppress the code check warning which requires return a string
  // return Future.value(null);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  asyncInit() async {
    await _init();
  }

  @override
  initState() {
    super.initState();
    asyncInit();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Crime Reporting And Prevention System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        // '/':(context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forget password': (context) => const ForgetPassword(),
        // '/account':(context) => const AccountScreen(),
        // '/crimeAlert':(context) => const CrimeAlertsScreen(),
        // '/crimeReport':(context) => const CrimeReportScreen(),
        // '/postFeed':(context) => const PostFeedScreen(),
        // '/editProfile':(context) => const EditProfile(),
        // '/manageContact':(context) => const ManageEmergencyContact(),
        // '/postList':(context) => const PostFeedScreen(),
        // '/editSOS':(context) => const EditSOSContent(),
        // '/myPost':(context) => const MyPostScreen(),
        // '/helpCenter':(context) => const HelpCenterScreen(),
        // '/guide':(context) => const GuideWebview()
      },
    );
  }
}
