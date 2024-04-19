import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

import 'package:todoapp/Pages/CommonFunctions/common_functions.dart';
import 'package:todoapp/Pages/Components/common_widgets.dart';
import 'package:todoapp/Pages/Models/projectlistmodelclass.dart';
import 'package:todoapp/Pages/login_screen.dart';
import 'package:todoapp/Pages/todolistscreen.dart';
import 'Config/app_config.dart';
import 'Config/size_config.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/Home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProjectListModel projects = ProjectListModel();
  String? token;
  String? name;
  String? email;
  String? userId;
  bool _initDone = false;
  int total = 0;
  int completed = 0;
  double percentage = 0;

  final TextEditingController _projectName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    token = CommonFunctions.getLocalData('token');
    name = CommonFunctions.getLocalData('name');
    email = CommonFunctions.getLocalData('email');
    userId = CommonFunctions.getLocalData('id');
    _getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.withOpacity(0.1), AppConfig.outline],
          ),
        ),
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Projects',
                              style: TextStyle(
                                  color: AppConfig.textBlack,
                                  fontSize: AppConfig.headLineSize * 1.5,
                                  fontWeight: AppConfig.headLineWeight),
                            ),
                            CommonWidgets.horizontalSpace(1),
                            CommonWidgets.iconButton(
                                height: SizeConfig.blockSizeVertical * 5,
                                width: SizeConfig.blockSizeHorizontal * 10,
                                bgColor: AppConfig.colorSecondary,
                                radius: 10,
                                icon: Icons.add,
                                title: 'Add New',
                                textColor: AppConfig.background,
                                function: () {
                                  CommonWidgets.editDialogue('project', context,
                                      _projectName, null, false, null, () {
                                    if (_projectName.text.isEmpty) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Plesae enter valid project name',
                                          timeInSecForIosWeb: 3);
                                    } else {
                                      createProject().then((value) {
                                        _projectName.clear();
                                        Navigator.of(context).pop();
                                      });
                                    }
                                  });
                                })
                          ],
                        ),
                        CommonWidgets.verticalSpace(2),
                        (_initDone)
                            ? SizedBox(
                                width: SizeConfig.screenWidth! * 0.8,
                                child: DynamicHeightGridView(
                                  itemCount: projects.result!.length,
                                  shrinkWrap: true,
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 18.0,
                                  mainAxisSpacing: 18.0,
                                  builder: (context, index) {
                                    return _cards(index);
                                  },
                                ))
                            : Shimmer.fromColors(
                                baseColor: AppConfig.grey.withOpacity(0.1),
                                highlightColor: AppConfig.background,
                                child: SizedBox(
                                  width: SizeConfig.screenWidth! * 0.8,
                                  child: DynamicHeightGridView(
                                    itemCount: 20,
                                    shrinkWrap: true,
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 18.0,
                                    mainAxisSpacing: 18.0,
                                    builder: (context, index) {
                                      return CommonWidgets.shimmerCards(
                                        index,
                                        height:
                                            SizeConfig.blockSizeVertical * 12,
                                        width: SizeConfig.screenWidth! * 0.3,
                                      );
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  CommonWidgets.verticalSpace(5),
                  Container(
                    decoration: BoxDecoration(
                      color: AppConfig.lightGrey.withOpacity(0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    width: SizeConfig.blockSizeHorizontal * 17,
                    height: SizeConfig.screenHeight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                  onTap: () => _showMyDialog(context),
                                  child: const Icon(Icons.logout)),
                            ),
                            CommonWidgets.verticalSpace(3),
                            InkWell(
                              onTap: () {
                                deleteDialogue(context, _email, _password, () {
                                  if (_email.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: 'Please enter your email');
                                  } else if (_password.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: 'Plesae enter your password');
                                  } else {
                                    deleteAccount();
                                  }
                                });
                              },
                              child: const CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage(
                                  'Assets/Images/Logo.png',
                                ),
                              ),
                            ),
                            CommonWidgets.verticalSpace(1),
                            Text(name ?? ''),
                            Text(
                              email ?? '',
                              style: TextStyle(
                                  fontSize: AppConfig.headLineSize * 0.8),
                            ),
                            CommonWidgets.verticalSpace(1),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                border: Border.all(
                                  color: AppConfig.grey,
                                ),
                              ),
                              width: SizeConfig.blockSizeVertical * 30,
                              height: SizeConfig.blockSizeHorizontal * 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text('Project Progress Overview'),
                                  Text('${percentage.toStringAsFixed(1)} %'),
                                ],
                              ),
                            ),
                            CommonWidgets.verticalSpace(2),
                            (_initDone)
                                ? (projects.result!.isNotEmpty)
                                    ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Latest Project Progress',
                                          style: TextStyle(
                                              fontSize:
                                                  AppConfig.headLineSize * 0.8,
                                              fontWeight:
                                                  AppConfig.headLineWeight),
                                        ),
                                      )
                                    : Container()
                                : Container(),
                            (_initDone)
                                ? (projects.result!.isNotEmpty)
                                    ? ListView.builder(
                                        itemCount: (projects.result!.length > 5)
                                            ? 5
                                            : projects.result!.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Column(children: [
                                            CommonWidgets.verticalSpace(1),
                                            _progressContainer(
                                                title: projects
                                                        .result![index].title ??
                                                    '--',
                                                progress: (projects
                                                            .result![index]
                                                            .total !=
                                                        0)
                                                    ? '${((projects.result![index].completed! / projects.result![index].total! * 100)).toStringAsFixed(2)} %'
                                                    : '0 Todos')
                                          ]);
                                        },
                                      )
                                    : Container()
                                : const Text('No Projects')
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cards(int index) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => TodoList(
                      projectId: projects.result![index].projectId.toString(),
                      title: projects.result![index].title,
                    ))).then((value) => _getProjects());
      },
      child: Container(
        height: SizeConfig.blockSizeVertical * 12,
        width: SizeConfig.screenWidth! * 0.3,
        decoration: const BoxDecoration(
            color: AppConfig.colorPrimary,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    projects.result![index].createdAt!.substring(0, 10),
                    style: TextStyle(
                        fontSize: AppConfig.headLineSize * 0.7,
                        color: AppConfig.background),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      CommonWidgets.editDialogue(
                          'delete', context, null, null, false, 'null', () {
                        deleteProject(projects.result![index].projectId!)
                            .then((value) => Navigator.of(context).pop());
                      });
                    },
                    child: Icon(
                      Icons.delete,
                      color: AppConfig.hold.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  CommonWidgets.editDialogue('project', context, _projectName,
                      null, true, projects.result![index].title ?? '', () {
                    if (_projectName.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'Plesae enter valid project name',
                          timeInSecForIosWeb: 3);
                    } else {
                      editProject(projects.result![index].projectId!)
                          .then((value) {
                        _projectName.clear();
                        Navigator.of(context).pop();
                      });
                    }
                  });
                },
                child: Text(
                  projects.result![index].title ?? '',
                  style: TextStyle(
                      fontSize: AppConfig.headLineSize,
                      fontWeight: AppConfig.headLineWeight,
                      color: AppConfig.background),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _progressContainer({required String title, required var progress}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(
          color: AppConfig.grey,
        ),
      ),
      width: SizeConfig.blockSizeVertical * 30,
      height: SizeConfig.blockSizeHorizontal * 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('$title :'),
            CommonWidgets.horizontalSpace(1),
            Text(
              progress,
              style: const TextStyle(color: AppConfig.colorPrimary),
            ),
          ],
        ),
      ),
    );
  }

  void _getProjects() async {
    try {
      const String apiUrl = 'http://127.0.0.1:8000/api/project/list/';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        },
      );

      if (response.statusCode == 200) {
        projects = ProjectListModel.fromJson(json.decode(response.body));
        setState(() {
          _initDone = true;
        });
        for (var i in projects.result!) {
          total = total + (i.total ?? 0);
          completed = completed + (i.completed ?? 0);
        }
        if (total != 0) {
          percentage = completed / total * 100;
        }
      } else {
        final errorMessage = json.decode(response.body)['detail'];
        if (mounted) {
          CommonWidgets.showDialogueBox(
              context: context, msg: '$errorMessage', title: 'Errror');
        }
      }
    } catch (e) {
      if (mounted) {
        CommonWidgets.showServerErrors(context);
      }
    }
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                logout();
              },
            )
          ],
        );
      },
    );
  }

  Future logout() async {
    try {
      const String apiUrl = 'http://127.0.0.1:8000/api/accounts/logout/';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        },
      );

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
        }
      } else {
        final errorMessage = json.decode(response.body)['response'];
        if (mounted) {
          Navigator.pop(context);
          CommonWidgets.showDialogueBox(
              context: context, msg: '$errorMessage', title: 'Errror');
        }
      }
    } catch (e, stackTrace) {
      if (mounted) {
        CommonWidgets.showServerErrors(context);
      }
    }
  }

  Future deleteAccount() async {
    try {
      const String apiUrl = 'http://127.0.0.1:8000/api/accounts/delete/';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({
          'email': _email.text,
          'password': _password.text,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        },
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Account deleted successfully');
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      } else {
        final errorMessage = json.decode(response.body)['response'];
        if (mounted) {
          Navigator.pop(context);
          CommonWidgets.showDialogueBox(
              context: context, msg: '$errorMessage', title: 'Errror');
        }
      }
    } catch (e, stackTrace) {
      if (mounted) {
        CommonWidgets.showServerErrors(context);
      }
    }
  }

  Future createProject() async {
    try {
      const String apiUrl = 'http://127.0.0.1:8000/api/project_add/';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({
          'user': userId,
          'title': _projectName.text,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        },
      );

      if (response.statusCode == 201) {
        _getProjects();
      }
    } catch (e, stackTrace) {
      if (mounted) {
        CommonWidgets.showServerErrors(context);
      }
    }
  }

  Future editProject(int id) async {
    try {
      String apiUrl = 'http://127.0.0.1:8000/api/project/$id/';

      final response = await http.put(
        Uri.parse(apiUrl),
        body: json.encode({
          'user': userId,
          'title': _projectName.text,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        },
      );

      if (response.statusCode == 200) {
        _getProjects();
      }
    } catch (e, stackTrace) {
      if (mounted) {
        CommonWidgets.showServerErrors(context);
      }
    }
  }

  Future deleteProject(int id) async {
    try {
      String apiUrl = 'http://127.0.0.1:8000/api/project/$id/';

      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        },
      );

      if (response.statusCode == 204) {
        _getProjects();
      }
    } catch (e, stackTrace) {
      if (mounted) {
        CommonWidgets.showServerErrors(context);
      }
    }
  }

  Future<void> deleteDialogue(
      BuildContext context,
      TextEditingController? controller,
      TextEditingController? controller2,
      VoidCallback function) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                (controller != null)
                    ? CommonWidgets.textContainer('Email', null, controller)
                    : Container(),
                CommonWidgets.verticalSpace(1),
                (controller2 != null)
                    ? CommonWidgets.textContainer('Password', null, controller2)
                    : Container()
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                (controller != null) ? controller.clear() : null;
                (controller2 != null) ? controller2.clear() : null;
                Navigator.of(context).pop();
              },
            ),
            TextButton(onPressed: function, child: const Text('Delete'))
          ],
        );
      },
    );
  }
}
