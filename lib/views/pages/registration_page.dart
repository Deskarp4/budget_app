import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:cost_control/transitions.dart';
import 'widget_tree.dart';
import 'login_page.dart';
import 'package:cost_control/gradients.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _phoneRegController = TextEditingController();
  final _passwordRegController = TextEditingController();

  @override
  void dispose() {
    _phoneRegController.dispose();
    _passwordRegController.dispose();
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
                    'Create account',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    children: [
                      const Text(
                        "Already have an account? ",
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
                                LoginPage(),
                                Duration(milliseconds: 900),
                              ),
                            );
                          },

                          child: Text(
                            'Sign in',
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
                    controller: _phoneRegController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Enter your email',
                      hintStyle: TextStyle(color: Colors.blueGrey),
                    ),
                  ),

                  const SizedBox(height: 45),

                  // Поле пароля + Forgot
                  TextField(
                    controller: _passwordRegController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(color: Colors.blueGrey),
                    ),
                  ),

                  const SizedBox(height: 45),

                  TextField(
                    controller: _passwordRegController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_open),
                      hintText: 'Confirm your password',
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
                            children: [
                              Text(
                                'Sign up ',
                                style: TextStyle(
                                  fontSize: 22,
                                  letterSpacing: 2,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.how_to_reg,
                                color: Colors.white,
                                size: 23,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10),
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
