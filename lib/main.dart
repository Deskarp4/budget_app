import 'package:cost_control/data/notifiers.dart';
import 'package:cost_control/views/pages/welcome_page.dart';
import 'package:cost_control/views/pages/login_page.dart';
import 'package:cost_control/views/pages/registration_page.dart';
import 'package:cost_control/views/pages/widget_tree.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cost_control/repositories/user_repository.dart';
import 'package:cost_control/controllers/auth_controller.dart';
import 'package:cost_control/bindings/auth_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('en', null);
  Get.put(UserRepository());
  Get.put(AuthController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeMode,
      builder: (context, value, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialBinding: AuthBinding(),
          theme: ThemeData(
            primaryColor: Color(0xFF3EA2B5),
            textTheme: GoogleFonts.poppinsTextTheme(),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xff43AABD),
              brightness: themeMode.value ? Brightness.light : Brightness.dark,
            ),
          ),

          initialRoute: '/welcome',
          getPages: [
            GetPage(name: '/welcome',  page: () => const WelcomePage()),
            GetPage(name: '/login',    page: () => const LoginPage()),
            GetPage(name: '/register', page: () => const RegistrationPage()),
            GetPage(name: '/home',     page: () => const WidgetTree()),
          ],



          home: WelcomePage(),
        );
      },
    );
  }
}
