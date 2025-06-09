import 'package:assignment12_6509966_ict425/Screens/EmployeePage.dart';
import 'package:assignment12_6509966_ict425/Screens/LoginPage.dart';
import 'package:assignment12_6509966_ict425/Screens/SignUpPage.dart';
import 'package:assignment12_6509966_ict425/Screens/SplashPage.dart';
import 'package:assignment12_6509966_ict425/Screens/WeatherPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RSU Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
      },
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
