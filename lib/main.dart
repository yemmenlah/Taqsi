import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:taqsi/firebase_options.dart';
import 'package:taqsi/screens/splash_screen.dart';
import 'package:taqsi/shared/colors.dart';
import 'package:taqsi/theme/theme_not.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint(" Firebase initialization failed: $e");
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ✅ Light Theme
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: backgroundcolor,
        bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black),
      ),

      // ✅ Dark Theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkBackgroundColor,
        cardColor: darkCardColor,
        bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black),
      ),

      themeMode: themeNotifier.currentMode,
      home: const SplashScreen(),
    );
  }
}
