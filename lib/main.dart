import 'package:crimereporting_and_preventionsystem/awareness/awareness_screen.dart';
import 'package:crimereporting_and_preventionsystem/crime_location/screens/crime_location_screen.dart';
import 'package:crimereporting_and_preventionsystem/crime_report/screens/crime_report_screen.dart';
import 'package:crimereporting_and_preventionsystem/drawer/screens/edit_profile_screen.dart';
import 'package:crimereporting_and_preventionsystem/drawer/screens/edit_sos_content_screen.dart';
import 'package:crimereporting_and_preventionsystem/drawer/screens/manage_screen.dart';
import 'package:crimereporting_and_preventionsystem/emergency_official/grid_dashboard.dart';
import 'package:crimereporting_and_preventionsystem/home.dart';
import 'package:crimereporting_and_preventionsystem/login_register/screens/forget_password.dart';
import 'package:crimereporting_and_preventionsystem/login_register/screens/login_screen.dart';
import 'package:crimereporting_and_preventionsystem/login_register/screens/register_screen.dart';
import 'package:crimereporting_and_preventionsystem/service/firebase.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //awesome notifications
  // AwesomeNotifications().initialize(null,
  //     [NotificationChannel(
  //           channelKey: 'basic_channel',
  //           channelName: 'Basic notifications',
  //           channelDescription: 'Notification channel for basic tests',
  //           )],);
  await FirebaseAppCheck.instance.activate();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Crime Reporting And Prevention System',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Loading indicator
          } else if (snapshot.hasData) {
            return const HomePage(); // User is logged in
          } else {
            return const LoginScreen(); // User is not logged in
          }
        },
      ),
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forget password': (context) => const ForgetPassword(),
        '/emergency Official': (context) => const GridDashboard(),
        '/crimeAlert': (context) => const CrimeAlertsScreen(),
        '/crimeReport': (context) => const CrimeReportScreen(),
        '/awareness': (context) => const Awareness(),
        '/manageContact': (context) => const ManageEmergencyContact(),
        '/editSOS': (context) => const EditSOSContent(),
        '/editProfile': (context) => const EditProfile(),
        //'/addEmergencyContact': (context)=> const AddEmergencyContact(mapEdit:false , o,)
      },
    );
  }
}
