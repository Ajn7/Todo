import 'package:flutter/material.dart';
import 'package:todoapp/Pages/homescreen.dart';
import 'package:todoapp/Pages/login_screen.dart';

import 'Config/app_config.dart';
import 'Config/size_config.dart';
import 'Utilities/sharedpref.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "SplashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool callAppConfig = false;
  bool initDone = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _initAppState() async {
    SharedPref sharedPref = SharedPref();
    bool appStateRetrieved = false;
    appStateRetrieved = await sharedPref.containsKey('app_state');
    print('Init App');

    if (appStateRetrieved == true) {
      Map<String, dynamic> resp = await sharedPref.read("app_state");
      _getAppStateDetails(resp);

   
        if (mounted) {
          Navigator.of(context).pushNamed(HomeScreen.routeName);
        }
      
    } else {
      if (mounted) {
        Navigator.of(context).pushNamed(LoginScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _initAppState();
    return Scaffold(
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue, AppConfig.outline])),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Initializing..Please wait",
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getAppStateDetails(Map<String, dynamic> json) {
    // appState.token = json['token'];
    // appState.name = json['name'];
    // appState.userId = json['userId'];
  }
}
