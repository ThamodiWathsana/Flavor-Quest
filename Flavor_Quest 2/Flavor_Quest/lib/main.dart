import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'signinadmin.dart';
import 'signin.dart';
import 'signup.dart';
import 'welcomepage.dart';
import 'candy.dart';
import 'forgotpass.dart';
import 'roleselection.dart';
import 'candyadmin.dart';
import 'firebase_options.dart'; // Import the generated firebase_options.dart file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use the generated Firebase options
  ); // Initialize Firebase

  runApp(
    DevicePreview(
      enabled: true, // Enable mobile screen preview
      builder: (context) => const SweetSelectorApp(),
    ),
  );
}

class SweetSelectorApp extends StatelessWidget {
  const SweetSelectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,  // Ensure that Device Preview works properly
      locale: DevicePreview.locale(context),  // Use the locale from DevicePreview
      builder: DevicePreview.appBuilder,  // Wrap the app with DevicePreview
      title: 'Sweet Selector',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const WelcomePage(),
        '/signin': (context) => const RoleSelectionPage(),
        '/signup': (context) => const SignUpPage(),
        '/candy': (context) => const CandyShop(),
        '/forgotpass': (context) => const ForgotPasswordPage(),
        '/admin': (context) => const SignInAdmin(title: 'Admin signin'),
        '/customer': (context) => const SignInPage(title: 'Customer signin'),
        '/signinadmin': (context) => const CandyAdmin(title: 'Candy Manage'),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
