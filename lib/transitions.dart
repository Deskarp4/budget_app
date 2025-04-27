import 'package:flutter/material.dart';

Route CreateTransitionRouteFoSi(beginOffset, Widget page, duration) {
  return PageRouteBuilder(
    transitionDuration: duration,
    reverseTransitionDuration: Duration(milliseconds: 750),

    pageBuilder: (context, animation, secondaryAnimation) => page,

    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      );

      final offsetAnimation = Tween<Offset>(
        begin: beginOffset,
        end: Offset.zero,
      ).animate(curvedAnimation);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
