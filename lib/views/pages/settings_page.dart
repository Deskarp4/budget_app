import 'package:cost_control/transitions.dart';
import 'package:cost_control/views/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'welcome_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          FilledButton(
            onPressed:
                () => Navigator.pushAndRemoveUntil(
                  context,
                  CreateTransitionRouteFoSi(
                    Offset(-1, 0),
                    WelcomePage(),
                    Duration(milliseconds: 900),
                  ),
                  (predicate) => false,
                ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
