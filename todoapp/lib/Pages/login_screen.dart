import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:todoapp/Pages/CommonFunctions/common_functions.dart';
import 'package:todoapp/Pages/homescreen.dart';
import 'dart:convert';

import 'Components/common_widgets.dart';
import 'Config/app_config.dart';
import 'Config/size_config.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _password2 = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();

  String? token;
  String? name;
  String? email;
  int? userId;

  bool _obscureText = true;

  bool underline = false;
  bool signup = false;
  bool _loading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, AppConfig.outline],
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: (_loading)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        CommonWidgets.verticalSpace(10),
                        const CircularProgressIndicator.adaptive(),
                        const Text('Please wait a moment...'),
                      ])
                : SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonWidgets.verticalSpace(7),
                        Card(
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: SizedBox(
                            width: SizeConfig.screenWidth! * 0.3,
                            height: (signup)
                                ? SizeConfig.screenHeight! * 1.05
                                : SizeConfig.screenHeight! * 0.7,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  CommonWidgets.verticalSpace(5),
                                  Text(
                                    (signup)
                                        ? 'Create Account'
                                        : 'Welcome Back',
                                    style: TextStyle(
                                        color: AppConfig.textBlack,
                                        fontSize: AppConfig.headLineSize * 1.5,
                                        fontWeight: AppConfig.headLineWeight),
                                  ),
                                  (signup)
                                      ? Container()
                                      : CommonWidgets.verticalSpace(2),
                                  (signup)
                                      ? Container()
                                      : Text(
                                          'Enter your email and password to access your account',
                                          style: TextStyle(
                                            color: AppConfig.textBlack,
                                            fontSize:
                                                AppConfig.headLineSize * 0.7,
                                          ),
                                        ),
                                  CommonWidgets.verticalSpace(3),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Email'),
                                      CommonWidgets.verticalSpace(0.5),
                                      textContainer(
                                          'Enter your email', null, _email),
                                      CommonWidgets.verticalSpace(2),
                                      (signup)
                                          ? const Text('First Name')
                                          : Container(),
                                      (signup)
                                          ? CommonWidgets.verticalSpace(0.5)
                                          : Container(),
                                      (signup)
                                          ? textContainer(
                                              'Enter your first Name',
                                              null,
                                              _firstName)
                                          : Container(),
                                      (signup)
                                          ? CommonWidgets.verticalSpace(2)
                                          : Container(),
                                      (signup)
                                          ? const Text('Last Name')
                                          : Container(),
                                      (signup)
                                          ? CommonWidgets.verticalSpace(0.5)
                                          : Container(),
                                      (signup)
                                          ? textContainer(
                                              'Enter your last Name',
                                              null,
                                              _lastName)
                                          : Container(),
                                      (signup)
                                          ? CommonWidgets.verticalSpace(2)
                                          : Container(),
                                      const Text('Password'),
                                      CommonWidgets.verticalSpace(0.5),
                                      textContainer(
                                          'Password',
                                          Icons.remove_red_eye_outlined,
                                          _password),
                                      (signup)
                                          ? CommonWidgets.verticalSpace(2)
                                          : Container(),
                                      (signup)
                                          ? const Text('Confirm Password')
                                          : Container(),
                                      (signup)
                                          ? CommonWidgets.verticalSpace(0.5)
                                          : Container(),
                                      (signup)
                                          ? textContainer('Confirm Password',
                                              null, _password2)
                                          : Container(),
                                      (signup)
                                          ? CommonWidgets.verticalSpace(2)
                                          : Container(),
                                      CommonWidgets.verticalSpace(6),
                                      Center(
                                        child: CommonWidgets.button(
                                            bgColor: AppConfig.colorPrimary,
                                            textColor: AppConfig.background,
                                            function: (signup)
                                                ? () {
                                                    if (_email.text.isEmpty) {
                                                      CommonWidgets.showDialogueBox(
                                                          context: context,
                                                          title: 'Error',
                                                          msg:
                                                              "Please enter email");
                                                    } else if (_firstName
                                                        .text.isEmpty) {
                                                      CommonWidgets.showDialogueBox(
                                                          context: context,
                                                          title: 'Error',
                                                          msg:
                                                              "Please enter first name");
                                                    } else if (_lastName
                                                        .text.isEmpty) {
                                                      CommonWidgets.showDialogueBox(
                                                          context: context,
                                                          title: 'Error',
                                                          msg:
                                                              "Please enter last name");
                                                    } else if (_password
                                                        .text.isEmpty) {
                                                      CommonWidgets.showDialogueBox(
                                                          context: context,
                                                          title: 'Error',
                                                          msg:
                                                              "Please enter password");
                                                    } else if (_password2
                                                        .text.isEmpty) {
                                                      CommonWidgets.showDialogueBox(
                                                          context: context,
                                                          title: 'Error',
                                                          msg:
                                                              "Please re-enter password");
                                                    } else if (_password2
                                                            .text !=
                                                        _password.text) {
                                                      CommonWidgets.showDialogueBox(
                                                          context: context,
                                                          title: 'Error',
                                                          msg:
                                                              "Password and confirm password does not match");
                                                    } else {
                                                      createAccount();
                                                    }
                                                  }
                                                : () {
                                                    if (_password
                                                            .text.isEmpty ||
                                                        _email.text.isEmpty) {
                                                      CommonWidgets.showDialogueBox(
                                                          context: context,
                                                          title: 'Error',
                                                          msg:
                                                              "Please enter valid Email and Password");
                                                    } else {
                                                      login();
                                                    }
                                                  },
                                            height:
                                                SizeConfig.blockSizeVertical *
                                                    8,
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    25,
                                            radius: 10,
                                            title: (signup)
                                                ? 'Sign Up'
                                                : 'Sign In'),
                                      ),
                                      CommonWidgets.verticalSpace(2),
                                      Center(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              signup = !signup;
                                              _email.clear();
                                              _password.clear();
                                            });
                                          },
                                          onHover: (value) {
                                            setState(() {
                                              underline = value;
                                            });
                                          },
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          splashColor: AppConfig.colorPrimary
                                              .withOpacity(0.1),
                                          child: RichText(
                                            text: TextSpan(
                                              text: (signup)
                                                  ? 'Already have an account? '
                                                  : 'Don\'t have an account? ',
                                              style: TextStyle(
                                                decoration: (underline)
                                                    ? TextDecoration.underline
                                                    : null,
                                              ),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: (signup)
                                                      ? 'Sign in'
                                                      : 'Create one!',
                                                  style: TextStyle(
                                                      decoration: (underline)
                                                          ? TextDecoration
                                                              .underline
                                                          : null,
                                                      color: AppConfig
                                                          .colorPrimary),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget textContainer(
      String title, dynamic icon, TextEditingController controller) {
    return Container(
        height: SizeConfig.blockSizeVertical * 8,
        width: SizeConfig.blockSizeHorizontal * 28,
        decoration: BoxDecoration(
          color: AppConfig.colorPrimary.withOpacity(0.05),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  obscureText: (title == "Password") ? _obscureText : false,
                  enableSuggestions: (title == "Password") ? false : true,
                  autocorrect: (title == "Password") ? false : true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    suffixIcon: (title == "Password")
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            icon: (_obscureText == true)
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: AppConfig.grey,
                                  )
                                : const Icon(Icons.visibility,
                                    color: AppConfig.grey),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    hintText: title,
                    alignLabelWithHint: false,
                    hintStyle: const TextStyle(
                      color: Colors.black38,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> login() async {
    try {
      setState(() {
        _loading = true;
      });

      const String apiUrl = 'http://127.0.0.1:8000/api/accounts/login/';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({
          'email': _email.text,
          'password': _password.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        token = json.decode(response.body)['token'];
        name = json.decode(response.body)['name'];
        email = json.decode(response.body)['email'];
        userId = json.decode(response.body)['id'];
        CommonFunctions.saveToken('token', token!);
        CommonFunctions.saveToken('name', name!);
        CommonFunctions.saveToken('email', email!);
        CommonFunctions.saveToken('id', userId.toString());

        if (mounted) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        }
      } else {
        setState(() {
          _loading = false;
        });
        final errorMessage = json.decode(response.body)['response'];
        if (mounted) {
          CommonWidgets.showDialogueBox(
              context: context, msg: '$errorMessage', title: 'Errror');
        }
      }
    } catch (e, stackTrace) {
      setState(() {
        _loading = false;
      });
      if (mounted) {
        CommonWidgets.showServerErrors(context);
      }
    }
  }

  void createAccount() async {
    try {
      setState(() {
        _loading = true;
      });
      const String apiUrl = 'http://127.0.0.1:8000/api/accounts/register/';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({
          'first_name': _firstName.text,
          'last_name': _lastName.text,
          'email': _email.text,
          'password': _password.text,
          'password2': _password2.text
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Registered successfully');
        token = json.decode(response.body)['token'];
        name = json.decode(response.body)['first_name'];
        String lastName = json.decode(response.body)['last_name'];
        email = json.decode(response.body)['email'];
        userId = json.decode(response.body)['id'];
        CommonFunctions.saveToken('token', token!);
        CommonFunctions.saveToken('name', '$name' '$lastName');
        CommonFunctions.saveToken('email', email!);
        CommonFunctions.saveToken('id', userId.toString());
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        }
      } else {
        setState(() {
          _loading = false;
        });
        final errorMessage = json.decode(response.body)['error'];
        if (mounted) {
          CommonWidgets.showDialogueBox(
              context: context, msg: '$errorMessage', title: 'Errror');
        }
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (mounted) {
        CommonWidgets.showServerErrors(context);
      }
    }
  }
}
