import 'package:cost_control/data/notifiers.dart';
import 'package:cost_control/views/pages/home_page.dart';
import 'package:cost_control/views/pages/welcome_page.dart';
import 'package:cost_control/views/pages/widget_tree.dart';
import 'package:cost_control/widgets/navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeMode,
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            primaryColor: Color(0xFF3EA2B5),
            textTheme: GoogleFonts.poppinsTextTheme(),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xff43AABD),
              brightness: themeMode.value ? Brightness.light : Brightness.dark,
            ),
          ),

          home: WelcomePage(),
        );
      },
    );
  }
}
