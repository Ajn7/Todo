import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class CommonFunctions {
  CommonFunctions._();

  static Future<void> showMyDialog(BuildContext context,
      {required String title,
      required String description,
      required VoidCallback function}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(description),
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
              child: const Text('Save'),
              onPressed: function,
            )
          ],
        );
      },
    );
  }

  static saveToken(String title, String data) {
    html.window.localStorage[title] = data;
  }

  static String? getToken(String title) {
    return html.window.localStorage[title];
  }
}
