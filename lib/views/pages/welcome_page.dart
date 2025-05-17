import 'package:cost_control/views/pages/login_page.dart';
import 'package:cost_control/views/pages/registration_page.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:cost_control/transitions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cost_control/gradients.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: Lottie.asset(
                  animate: false,
                  'assets/lotties/Animation - pig.json',
                  controller: _controller,
                  width: 500,
                  onLoaded: (composition) {
                    _controller.duration = composition.duration;
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Track your income, expenses, \nplan budgets',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xff364850),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 100, left: 20, right: 20),
                child: Column(
                  children: [
                    FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CreateTransitionRouteFoSi(
                            Offset(0, 1),
                            LoginPage(),
                            Duration(milliseconds: 900),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundBuilder: (context, states, child) {
                          return Ink(
                            decoration: BoxDecoration(
                              gradient: accentGradient,
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            child: child,
                          );
                        },
                        minimumSize: Size(double.infinity, 60),
                      ),

                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 22, letterSpacing: 3),
                      ),
                    ),

                    SizedBox(height: 15),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CreateTransitionRouteFoSi(
                            Offset(0, 1),
                            RegistrationPage(),
                            Duration(milliseconds: 900),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size(double.infinity, 60),
                      ),

                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback:
                            (bounds) => textGradient.createShader(bounds),
                        child: Text(
                          'Get started',
                          style: TextStyle(fontSize: 21, letterSpacing: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            top: 440,
            right: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'Start controlling your budget',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.green[0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
