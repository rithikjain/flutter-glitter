import 'package:flutter/material.dart';
import 'package:flutter_glitter/glitter_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Glitter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const Scaffold(
        body: Center(
          child: GlitterCard(),
        ),
      ),
    );
  }
}
