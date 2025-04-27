import 'package:cost_control/transitions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'widget_tree.dart';
import 'registration_page.dart';
import 'package:cost_control/gradients.dart';

/// Экран входа в аккаунт
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneLogController = TextEditingController();
  final _passwordLogController = TextEditingController();

  @override
  void dispose() {
    _phoneLogController.dispose();
    _passwordLogController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // ─── Прозрачный AppBar ───────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // ─── Контент ─────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 18),

                  // Заголовок
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.black54, fontSize: 17),
                      ),
                      ShaderMask(
                        shaderCallback: (r) => textGradient.createShader(r),
                        blendMode: BlendMode.srcIn,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              CreateTransitionRouteFoSi(
                                Offset(0, 1),
                                RegistrationPage(),
                                Duration(milliseconds: 900),
                              ),
                            );
                          },

                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            overlayColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // Поле телефона
                  TextField(
                    controller: _phoneLogController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Colors.blueGrey),
                    ),
                  ),

                  const SizedBox(height: 45),

                  // Поле пароля + Forgot
                  TextField(
                    controller: _passwordLogController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(color: Colors.blueGrey),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Кнопка Login
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 60),
                            backgroundBuilder:
                                (context, states, child) => Ink(
                                  decoration: BoxDecoration(
                                    gradient: accentGradient,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: child,
                                ),
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              CreateTransitionRouteFoSi(
                                Offset(1, 0),
                                WidgetTree(),
                                Duration(milliseconds: 900),
                              ),
                              (_) => false,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 22,
                                  letterSpacing: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.login_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),

                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(letterSpacing: 1, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
//  Кастомное поле ввода с закруглёнными краями
// ──────────────────────────────────────────────────────────────
class _RoundedTextField extends StatelessWidget {
  const _RoundedTextField({
    required this.controller,
    required this.hint,
    this.icon,
    this.obscure = false,
    this.suffix,
  });

  final TextEditingController controller;
  final String hint;
  final IconData? icon;
  final bool obscure;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        prefixIcon:
            icon != null ? Icon(icon, color: Colors.black45, size: 22) : null,
        suffixIcon:
            suffix != null
                ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: suffix,
                )
                : null,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: accentGradient.colors.first, width: 2),
        ),
      ),
    );
  }
}
