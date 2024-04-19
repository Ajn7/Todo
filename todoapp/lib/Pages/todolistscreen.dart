import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
  final String? progress;
  final String? title;
  const TodoList({super.key, this.projectId, this.progress, this.title});

  @override
  State<TodoList> createState() => _TodoListState();
}

enum ListItems { pending, completed, hold, delete }

class _TodoListState extends State<TodoList> {
  ListItems? selectedItem;
  TodoListModel todoList = TodoListModel();
  List<Result> pendings = [];
  List<Result> completed = [];
  List<Result> hold = [];
  bool hover = false;
  late String? pid;
  String? token;
  bool _initDone = false;
  List<String> pendingListData = [];
  List<String> holdListData = [];
  List<String> completedListData = [];

  @override
  void initState() {
    super.initState();
    token = CommonFunctions.getToken('token');
    pid = widget.projectId;

    _getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: Column(
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
                _generateList().then(saveMarkdownFile(
                  'Project Title',
                  completedListData,
                  pendingListData,
                  holdListData,
                  'project_tasks.md',
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
      ),
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
            child: Column(
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
                            text: ' ${pendings.length + hold.length} tasks',
                            style: TextStyle(color: AppConfig.colorWarning),
                          ),
                          TextSpan(
                            text: (pendings.length + hold.length > 0)
                                ? ' to be completed'
                                : ' !',
                            style: const TextStyle(color: AppConfig.textBlack),
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
                        function: () {})
                  ],
                ),
                CommonWidgets.verticalSpace(1),
                Text(
                  'Project:${widget.title ?? ''}',
                  style: TextStyle(
                      fontWeight: AppConfig.headLineWeight,
                      fontSize: AppConfig.headLineSize),
                ),
                CommonWidgets.verticalSpace(3),
                _headLine(title: 'Pending', color: AppConfig.pending),
                CommonWidgets.verticalSpace(2),
                (pendings.isEmpty)
                    ? const Text('No pending list')
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
                    ? const Text('No completed list')
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
                _headLine(title: 'Hold', color: AppConfig.hold),
                CommonWidgets.verticalSpace(2),
                (hold.isEmpty)
                    ? const Text('No hold list')
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: hold.length,
                        itemBuilder: (context, index) {
                          return _itemList(
                              index: index, status: 'hold', data: hold[index]);
                        },
                      ),
                CommonWidgets.verticalSpace(2),
              ],
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
                    color: (status == 'hold')
                        ? AppConfig.hold
                        : (status == 'pending')
                            ? AppConfig.pending
                            : AppConfig.completed),
                CommonWidgets.horizontalSpace(0.5),
                InkWell(onTap: () {}, child: Text(data.title ?? '')),
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
                          const PopupMenuItem<ListItems>(
                            value: ListItems.pending,
                            child: Text('Mark as pending'),
                          ),
                          const PopupMenuItem<ListItems>(
                            value: ListItems.completed,
                            child: Text('Mark as completed'),
                          ),
                          const PopupMenuItem<ListItems>(
                            value: ListItems.hold,
                            child: Text('Mark as hold'),
                          ),
                          const PopupMenuItem<ListItems>(
                            value: ListItems.delete,
                            child: Text('Delete'),
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
            CommonFunctions.showMyDialog(context,
                description: 'hghg', title: 'Edit', function: () {});
          },
          child: ListTile(
            title: Text(data.description ?? ''),
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
    String markdownContent = '**${widget.title}**\n\n';

    markdownContent += '**Summary**';
    markdownContent += '${widget.progress} todos completed\n\n';

    markdownContent += '\n**Pending**\n';
    if (pendingTasks.isNotEmpty) {
      for (String task in pendingTasks) {
        markdownContent += '-☐ $task\n';
      }
    } else {
      markdownContent += 'No data\n';
    }

    markdownContent += '\n**Completed**\n';
    if (completedTasks.isNotEmpty) {
      for (String task in completedTasks) {
        markdownContent += '-✓$task\n';
      }
    } else {
      markdownContent += 'No data\n';
    }

    markdownContent += '\n**Hold**\n';
    if (holdTasks.isNotEmpty) {
      for (String task in holdTasks) {
        markdownContent += '-* $task\n';
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

  void _getTodos() async {
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
          } else {
            hold.add(i);
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
    for (var i in hold) {
      holdListData.add(i.title!);
    }
    for (var i in completed) {
      completedListData.add(i.title!);
    }
  }
}
