import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../Config/app_config.dart';
import '../Config/size_config.dart';

class CommonWidgets {
  CommonWidgets._();

  static horizontalSpace(double size) {
    return SizedBox(
      width: SizeConfig.blockSizeHorizontal * size,
    );
  }

  static verticalSpace(double size) {
    return SizedBox(
      height: SizeConfig.blockSizeVertical * size,
    );
  }

  static Widget button(
      {required String title,
      required double width,
      required double height,
      required Color bgColor,
      required Color textColor,
      required double radius,
      required VoidCallback function}) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(radius),
              ),
            ),
          ),
          backgroundColor: MaterialStatePropertyAll(bgColor),
        ),
        onPressed: function,
        child: Text(
          title,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  static Widget iconButton(
      {required String title,
      required double width,
      required double height,
      required Color bgColor,
      required Color textColor,
      required double radius,
      required IconData icon,
      required VoidCallback function}) {
    return Container(
      height: height,
      constraints: BoxConstraints(
        minWidth: width,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(radius),
              ),
            ),
          ),
          backgroundColor: MaterialStatePropertyAll(bgColor),
        ),
        onPressed: function,
        child: Row(
          children: [
            Icon(icon, color: textColor),
            Text(
              'Add New',
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> showDialogueBox(
      {required BuildContext context,
      required String title,
      required String msg}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static void showServerErrors(
    BuildContext context,
  ) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                width: SizeConfig.blockSizeHorizontal * 40,
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Text(
                          'Error',
                          style: TextStyle(
                              fontFamily: 'helvetica',
                              fontSize: AppConfig.headLineSize * 1.2),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const CircleAvatar(
                            backgroundColor: AppConfig.colorPrimary,
                            child: Icon(
                              Icons.close,
                              color: AppConfig.background,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CommonWidgets.verticalSpace(3),
                    SizedBox(
                        height: SizeConfig.blockSizeVertical * 20,
                        width: SizeConfig.blockSizeHorizontal * 60,
                        child: Lottie.asset('Assets/Images/serverError.json')),
                    Text(
                      'Oops! Something went wrong. We are currently experiencing a technical glitch at the moment. Please try again later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'helvetica',
                          fontSize: AppConfig.captionSize * 1.2),
                    ),
                    CommonWidgets.verticalSpace(4),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: SizeConfig.safeBlockHorizontal! * 65,
                        height: SizeConfig.safeBlockVertical! * 7,
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            color: AppConfig.colorPrimary),
                        child: Center(
                          child: Text(
                            'Ok',
                            style: TextStyle(
                                fontFamily: 'helvetica',
                                letterSpacing: 1,
                                fontSize: AppConfig.captionSize * 1.2,
                                color: AppConfig.background),
                          ),
                        ),
                      ),
                    ),
                    CommonWidgets.verticalSpace(2),
                  ],
                ),
              ),
            ]),
          );
        });
  }

  static Widget loadingContainers(
      {required double height, required double width}) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: AppConfig.grey,
      ),
      height: height,
      width: width,
    );
  }

  static Widget textContainer(
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
                  obscureText: false,
                  enableSuggestions: (title == "Password") ? false : true,
                  autocorrect: (title == "Password") ? false : true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
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

  static Future<void> editDialogue(
      String title,
      BuildContext context,
      TextEditingController? controller,
      TextEditingController? controller2,
      bool isEdit,
      String? data,
      VoidCallback function) async {
    if (isEdit && controller != null) {
      controller.text = data!;
    } else if (isEdit && controller2 != null) {
      controller2.text = data!;
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: (title == 'delete')
              ? const Text('Delete Item?')
              : (isEdit)
                  ? const Text('Edit')
                  : const Text('Add New'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                (controller != null)
                    ? CommonWidgets.textContainer(
                        (title == 'project') ? 'Project Name' : 'Title',
                        null,
                        controller)
                    : Container(),
                CommonWidgets.verticalSpace(1),
                (controller2 != null)
                    ? CommonWidgets.textContainer(
                        'Description', null, controller2)
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
            TextButton(
              onPressed: function,
              child: (title == 'delete')
                  ? const Text('Delete')
                  : const Text('Save'),
            )
          ],
        );
      },
    );
  }

  static Widget shimmerCards(int index,
      {required double height, required double width}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets.verticalSpace(2),
        CommonWidgets.loadingContainers(height: height, width: width),
      ],
    );
  }
}
