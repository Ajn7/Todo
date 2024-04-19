import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class CommonFunctions {
  CommonFunctions._();

  static saveToken(String title, String data) {
    html.window.localStorage[title] = data;
  }

  static String? getLocalData(String title) {
    return html.window.localStorage[title];
  }
}
