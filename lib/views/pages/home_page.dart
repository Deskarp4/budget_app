import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // bottomNavigationBar: BottomNavigationBar(items: ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            child: Icon(Icons.access_alarm),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            child: Icon(Icons.access_alarm),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white, width: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
