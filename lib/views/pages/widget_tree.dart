import 'package:cost_control/views/pages/expenses.dart';
import 'package:cost_control/views/pages/profile_page.dart';
import 'package:cost_control/views/pages/settings_page.dart';
import 'package:cost_control/views/pages/login_page.dart';
import 'home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const _Shell();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

class _Shell extends StatefulWidget {
  const _Shell({super.key});

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  int _current = 0;

  static final _pages = [
    const HomePage(),
    ExpensesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Divider(thickness: 2, indent: 30, endIndent: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.settings, size: 36),
                      SizedBox(width: 16),
                      Text('Settings', style: TextStyle(fontSize: 24)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _current, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _current,
        onTap: (i) => setState(() => _current = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Expenses'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
