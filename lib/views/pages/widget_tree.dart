import 'package:cost_control/data/notifiers.dart';
import 'package:cost_control/views/pages/profile_page.dart';
import 'package:cost_control/views/pages/settings_page.dart';
import 'home_page.dart';
import 'package:flutter/material.dart';
import '../../widgets/navbar_widget.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  int _current = 0;
  static final List<Widget> _pages = [const HomePage(), const ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Budget app',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          ValueListenableBuilder(
            valueListenable: themeMode,
            builder:
                (context, value, child) => IconButton(
                  onPressed: () {
                    themeMode.value = !themeMode.value;
                  },
                  icon: Icon(
                    themeMode.value ? Icons.dark_mode : Icons.light_mode,
                  ),
                ),
          ),
        ],
      ),

      drawer: SafeArea(
        child: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Divider(thickness: 2, indent: 30, endIndent: 30),
                margin: EdgeInsets.only(top: 30),
              ),

              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.settings, size: 36),
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Text('Settings', style: TextStyle(fontSize: 24)),
                      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
    ;
  }
}
