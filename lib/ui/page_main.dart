import 'package:flutter/material.dart';

class MainPage extends StatefulWidget{
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<StatefulWidget> createState() => _MainPageState();

}

class _MainPageState extends State<MainPage>{
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "dddd",
          textDirection: TextDirection.ltr,
        ),
      ),
    );
  }

}