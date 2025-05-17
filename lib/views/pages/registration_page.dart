import 'package:flutter/material.dart';
import 'package:cost_control/transitions.dart';
import 'login_page.dart';
import 'package:cost_control/gradients.dart';
import 'package:cost_control/controllers/auth_controller.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _usernameCtl = TextEditingController();
  final _emailCtl    = TextEditingController();
  final _passwordCtl = TextEditingController();

  @override
  void dispose() {
    _usernameCtl.dispose();
    _emailCtl.dispose();
    _passwordCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              const Text('Create account',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Wrap(children: [
                const Text("Already have an account? ",
                    style: TextStyle(color: Colors.black54, fontSize: 17)),
                ShaderMask(
                  shaderCallback: (r) => textGradient.createShader(r),
                  blendMode: BlendMode.srcIn,
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      CreateTransitionRouteFoSi(
                          const Offset(0, 1), const LoginPage(),
                          const Duration(milliseconds: 900)),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      overlayColor: Colors.transparent,
                    ),
                    child: const Text('Sign in',
                        style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                  ),
                ),
              ]),
              const SizedBox(height: 50),

              TextField(
                controller: _usernameCtl,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Enter your username',
                  hintStyle: TextStyle(color: Colors.blueGrey),
                ),
              ),
              const SizedBox(height: 35),

              TextField(
                controller: _emailCtl,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(color: Colors.blueGrey),
                ),
              ),
              const SizedBox(height: 35),

              TextField(
                controller: _passwordCtl,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(color: Colors.blueGrey),
                ),
              ),
              const SizedBox(height: 60),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    backgroundBuilder: (c, s, child) => Ink(
                      decoration: BoxDecoration(
                        gradient: accentGradient,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: child,
                    ),
                  ),
                  onPressed: () {
                    final username = _usernameCtl.text.trim();
                    final email    = _emailCtl.text.trim();
                    final password = _passwordCtl.text.trim();
                    if (username.isEmpty ||
                        email.isEmpty ||
                        password.isEmpty) return;

                    AuthController.instance.register(email, password, username);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Sign up ',
                          style: TextStyle(
                              fontSize: 22,
                              letterSpacing: 2,
                              color: Colors.white)),
                      SizedBox(width: 6),
                      Icon(Icons.how_to_reg, color: Colors.white, size: 23),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
