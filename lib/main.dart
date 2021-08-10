import 'package:flutter/material.dart';
import 'package:modon_screens/screens/cart_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match',
      debugShowCheckedModeBanner: false,
      home: CartScreen(),
    );
  }
}
