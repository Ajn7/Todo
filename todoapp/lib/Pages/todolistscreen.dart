import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todoapp/Pages/CommonFunctions/common_functions.dart';
import 'package:todoapp/Pages/Components/common_widgets.dart';
import 'package:todoapp/Pages/Config/app_config.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;


import 'Config/size_config.dart';
import 'Models/todolistmodelclass.dart';

class TodoList extends StatefulWidget {
  static const routeName = '/TodoList';
  final String? projectId;
  final String? title;
  const TodoList({super.key, this.projectId, this.title});

  @override
  State<TodoList> createState() => _TodoListState();
}

enum ListItems { pending, completed, delete }

class _TodoListState extends State<TodoList> {
  ListItems? selectedItem;
  TodoListModel todoList = TodoListModel();
  List<Result> pendings = [];
  List<Result> completed = [];
  bool hover = false;
  late String? pid;
  String? token;
  String? userId;
  String? title;
  bool _initDone = false;
  String? progress;
  List<String> pendingListData = [];
  List<String> holdListData = [];
  List<String> completedListData = [];

  final TextEditingController _todoName = TextEditingController();
  final TextEditingController _todoDesc = TextEditingController();
  final TextEditingController _projectName = TextEditingController();

  @override
  void initState() {
    super.initState();
    token = CommonFunctions.getLocalData('token');
    userId = CommonFunctions.getLocalData('id');
    title = widget.title;
    pid = widget.projectId;

    _getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: (_initDone)?Column(
        children: [
          CommonWidgets.verticalSpace(2),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 8,
            width: (hover)
                ? SizeConfig.blockSizeHorizontal * 10
                : SizeConfig.blockSizeHorizontal * 5,
            child: ElevatedButton(
              style: const ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                backgroundColor: MaterialStatePropertyAll(Colors.green),
              ),
              onPressed: () {
                progress = (todoList.result!.isEmpty)
                    ? 'No todos'
                    : '${completed.length}/${todoList.result!.length} todos completed';
                _generateList().then(saveMarkdownFile(
                  'Project Title',
                  completedListData,
                  pendingListData,
                  holdListData,
                  '$title.md',
                ));
              },
              onHover: (value) => setState(() {
                hover = value;
              }),
              child: Row(
                children: [
                  const Icon(
                    Icons.download,
                    color: AppConfig.background,
                  ),
                  (hover)
                      ? const Text(
                          'Download',
                          style: TextStyle(color: AppConfig.background),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ):Container(),
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 118, 163, 199).withOpacity(0.1),
              AppConfig.outline
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: (_initDone)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'You have',
                              style: TextStyle(
                                fontSize: AppConfig.headLineSize * 1.2,
                                fontWeight: AppConfig.headLineWeight,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' ${pendings.length} tasks',
                                  style: const TextStyle(
                                      color: AppConfig.colorWarning),
                                ),
                                TextSpan(
                                  text: (pendings.isNotEmpty)
                                      ? ' to be completed'
                                      : ' !',
                                  style: const TextStyle(
                                      color: AppConfig.textBlack),
                                ),
                              ],
                            ),
                          ),
                          CommonWidgets.horizontalSpace(2),
                          CommonWidgets.iconButton(
                              height: SizeConfig.blockSizeVertical * 8,
                              width: SizeConfig.blockSizeHorizontal * 10,
                              bgColor: AppConfig.colorPrimary,
                              radius: 10,
                              icon: Icons.add,
                              title: 'Add New',
                              textColor: AppConfig.background,
                              function: () {
                                CommonWidgets.editDialogue('todo', context,
                                    _todoName, _todoDesc, false, null, () {
                                  if (_todoName.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: 'Plesae enter valid title',
                                        timeInSecForIosWeb: 3);
                                  } else if (_todoDesc.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: 'Plesae enter valid description',
                                        timeInSecForIosWeb: 3);
                                  } else {
                                    createTodo().then((value) {
                                      _todoName.clear();
                                      _todoDesc.clear();
                                      Navigator.of(context).pop();
                                    });
                                  }
                                });
                              })
                        ],
                      ),
                      CommonWidgets.verticalSpace(1),
                      InkWell(
                        onTap: () {
                          CommonWidgets.editDialogue('project', context,
                              _projectName, null, true, title, () {
                            if (_projectName.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Plesae enter valid project name',
                                  timeInSecForIosWeb: 3);
                            } else {
                              editProject(pid!).then((value) {
                                _projectName.clear();
                                Navigator.of(context).pop();
                              });
                            }
                          });
                        },
                        child: Text(
                          'Project:$title',
                          style: TextStyle(
                              fontWeight: AppConfig.headLineWeight,
                              fontSize: AppConfig.headLineSize),
                        ),
                      ),
                      CommonWidgets.verticalSpace(3),
                      _headLine(title: 'Pending', color: AppConfig.pending),
                      CommonWidgets.verticalSpace(2),
                      (pendings.isEmpty)
                          ? const Text('No pending todos')
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: pendings.length,
                              itemBuilder: (context, index) {
                                return _itemList(
                                    index: index,
                                    status: 'pending',
                                    data: pendings[index]);
                              },
                            ),
                      CommonWidgets.verticalSpace(2),
                      _headLine(title: 'Completed', color: AppConfig.completed),
                      CommonWidgets.verticalSpace(2),
                      (completed.isEmpty)
                          ? const Text('No completed todos')
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: completed.length,
                              itemBuilder: (context, index) {
                                return _itemList(
                                    index: index,
                                    status: 'completed',
                                    data: completed[index]);
                              },
                            ),
                      CommonWidgets.verticalSpace(2),
                    ],
                  )
                : Shimmer.fromColors(
                    baseColor: AppConfig.grey.withOpacity(0.1),
                    highlightColor: AppConfig.background,
                    child: SizedBox(
                      width: SizeConfig.screenWidth! * 0.8,
                      child: ListView.builder(
                        itemCount: 20,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return CommonWidgets.shimmerCards(index,
                              height: SizeConfig.blockSizeVertical * 12,
                              width: SizeConfig.screenWidth!);
                        },
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  _headLine({required String title, Color color = AppConfig.textBlack}) {
    return Text(
      title,
      style: TextStyle(
          fontSize: AppConfig.headLineSize,
          color: color,
          fontWeight: AppConfig.headLineWeight),
    );
  }

  Widget _itemList(
      {required int index, required String status, required Result data}) {
    return ExpansionTile(
      title: Column(
        children: [
          SizedBox(
            width: SizeConfig.screenWidth,
            height: SizeConfig.blockSizeVertical * 4,
            child: Row(
              children: [
                Icon(Icons.circle,
                    size: 10,
                    color: (status == 'pending')
                        ? AppConfig.pending
                        : AppConfig.completed),
                CommonWidgets.horizontalSpace(0.5),
                InkWell(
                    onTap: () {
                      CommonWidgets.editDialogue('todo', context, _todoName,
                          null, true, data.title ?? '', () {
                        if (_todoName.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Plesae enter valid todo title',
                              timeInSecForIosWeb: 3);
                        } else {
                          editTodo(
                                  id: data.id!,
                                  status: null,
                                  desc: null,
                                  title: _todoName.text)
                              .then((value) {
                            _todoName.clear();
                            Navigator.of(context).pop();
                          });
                        }
                      });
                    },
                    child: Text(data.title ?? '')),
                const Spacer(),
                PopupMenuButton<ListItems>(
                    initialValue: selectedItem,
                    onSelected: (ListItems item) {
                      setState(() {
                        selectedItem = item;
                      });
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<ListItems>>[
                          PopupMenuItem<ListItems>(
                            value: ListItems.pending,
                            child: const Text('Mark as pending'),
                            onTap: () {
                              editTodo(
                                  id: data.id!,
                                  status: 'pending',
                                  desc: null,
                                  title: null);
                            },
                          ),
                          PopupMenuItem<ListItems>(
                            value: ListItems.completed,
                            child: const Text('Mark as completed'),
                            onTap: () {
                              editTodo(
                                  id: data.id!,
                                  status: 'completed',
                                  desc: null,
                                  title: null);
                            },
                          ),
                          PopupMenuItem<ListItems>(
                            value: ListItems.delete,
                            child: const Text('Delete'),
                            onTap: () {
                              CommonWidgets.editDialogue(
                                  'delete', context, null, null, false, 'null',
                                  () {
                                deleteTodo(data.id!).then(
                                    (value) => Navigator.of(context).pop());
                              });
                            },
                          ),
                        ]),
                CommonWidgets.horizontalSpace(2),
              ],
            ),
          ),
          Divider(
            color: AppConfig.grey.withOpacity(0.2),
          ),
        ],
      ),
      children: [
        InkWell(
          onTap: () {
            CommonWidgets.editDialogue(
                'todo', context, null, _todoDesc, true, data.description ?? '',
                () {
              if (_todoDesc.text.isEmpty) {
                Fluttertoast.showToast(
                    msg: 'Plesae enter valid todo description',
                    timeInSecForIosWeb: 3);
              } else {
                editTodo(
                        id: data.id!,
                        status: null,
                        desc: _todoDesc.text,
                        title: null)
                    .then((value) {
                  _todoDesc.clear();
                  Navigator.of(context).pop();
                });
              }
            });
          },
          child: ListTile(
            subtitle: Text(
              data.createdAt!.substring(0, 10),
              style: TextStyle(fontSize: AppConfig.textCaption3Size),
            ),
            title: Text(
              data.description ?? '',
              style: TextStyle(fontSize: AppConfig.subTitle2Size),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> saveMarkdownFile(
      String title,
      List<String> completedTasks,
      List<String> pendingTasks,
      List<String> holdTasks,
      String fileName) async {
    // Create Markdown content
    String markdownContent = '## ${widget.title}\n\n';

    markdownContent += '**Summary**';
    markdownContent += ' : $progress\n\n';

    markdownContent += '\n**Pending**\n';
    if (pendingTasks.isNotEmpty) {
      for (String task in pendingTasks) {
        markdownContent += '[ ] $task\n';
      }
    } else {
      markdownContent += 'No data\n';
    }

    markdownContent += '\n**Completed**\n';
    if (completedTasks.isNotEmpty) {
      for (String task in completedTasks) {
        markdownContent += '[x] $task\n';
      }
    } else {
      markdownContent += 'No data\n';
    }

    final blob = html.Blob([markdownContent], 'text/markdown');
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..style.display = 'none';

    html.document.body?.children.add(anchor);
    anchor.click();

    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  Future _getTodos() async {
    completed.clear();
    pendings.clear();
    try {
      String apiUrl = 'http://127.0.0.1:8000/api/todolist/$pid/';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        },
      );

      if (response.statusCode == 200) {
        todoList = TodoListModel.fromJson(json.decode(response.body));
        for (var i in todoList.result!) {
          if (i.status == "completed") {
            completed.add(i);
          } else if (i.status == "pending") {
            pendings.add(i);
          }
        }
        setState(() {
          _initDone = true;
        });
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

  _generateList() {
    for (var i in pendings) {
      pendingListData.add(i.title!);
    }

    for (var i in completed) {
      completedListData.add(i.title!);
    }
  }

  Future createTodo() async {
    try {
      const String apiUrl = 'http://127.0.0.1:8000/api/todo_add/';

      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({
          'project_ref_id': pid,
          'title': _todoName.text,
          'description': _todoDesc.text,
          'status': 'pending'
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        },
      );

      if (response.statusCode == 201) {
        _getTodos();
      }
    } catch (e, stackTrace) {
      if (mounted) {
        CommonWidgets.showServerErrors(context);
      }
    }
  }

  Future deleteTodo(int id) async {
    try {
      String apiUrl = 'http://127.0.0.1:8000/api/todo/$id/';

      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        },
      );

      if (response.statusCode == 204) {
        _getTodos();
      }
    } catch (e, stackTrace) {
      if (mounted) {
        CommonWidgets.showServerErrors(context);
      }
    }
  }

  Future editTodo(
      {required int id,
      required String? status,
      required String? title,
      required String? desc}) async {
    try {
      String apiUrl = 'http://127.0.0.1:8000/api/todo/$id/';

      final response = await http.patch(
        Uri.parse(apiUrl),
        body: json.encode({
          if (status != null) 'status': status,
          if (title != null) 'title': title,
          if (desc != null) 'description': desc
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Token $token"
        },
      );

      if (response.statusCode == 200) {
        _getTodos();
      }
    } catch (e, stackTrace) {
      if (mounted) {
        CommonWidgets.showServerErrors(context);
      }
    }
  }

  Future editProject(String id) async {
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
        setState(() {
          title = _projectName.text;
        });
      }
    } catch (e, stackTrace) {
      if (mounted) {
        CommonWidgets.showServerErrors(context);
      }
    }
  }
}
