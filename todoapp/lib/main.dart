import 'package:flutter/material.dart';
import 'package:todoapp/Pages/Config/app_config.dart';
import 'package:todoapp/Pages/SplashScreen.dart';
import 'package:todoapp/Pages/homescreen.dart';
import 'package:todoapp/Pages/todolistscreen.dart';

import 'Pages/Config/size_config.dart';
import 'Pages/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
        title: 'Todo App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppConfig.colorPrimary),
          useMaterial3: true,
        ),
        initialRoute: SplashScreen.routeName,
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          SplashScreen.routeName: (context) => const SplashScreen(),
          HomeScreen.routeName: (context) => HomeScreen(),
          TodoList.routeName: (context) => TodoList(),
        });
  }
}
