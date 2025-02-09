import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:user_management/page/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'aFlutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {"/home": (context) => HomePage()},
      initialRoute: "/home",
    );
  }
}
