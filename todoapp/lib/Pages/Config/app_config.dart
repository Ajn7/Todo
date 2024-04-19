import 'package:flutter/material.dart';
import './size_config.dart';

class AppConfig {
  AppConfig._();

  ///Main Colors
  static const Color colorPrimary = Color(0xFF007Aff);
  static const Color colorSecondary = Color(0xFF5bc88d);

 //default text styles

  static var headLineSize = 20.0;
  static var headLineWeight = FontWeight.bold;
  static var subTitleSize = 18.0;
  static var subTitleWeight = FontWeight.bold;
  static var subTitle2Size = 15.0;
  static var subTitle2Weight = FontWeight.w500;
  static var captionSize = 14.0;
  static var captionWeight = FontWeight.normal;
  static var labelSize = 14.0;
  static var labelWeight = FontWeight.bold;

  /// New definitions end
  static var textHeadlineSize = SizeConfig.safeBlockVertical! * 5;
  static var textSubTitleSize = SizeConfig.safeBlockVertical! * 4;
  static var textSubtitle2Size = SizeConfig.safeBlockVertical! * 3;
  static var textSubtitle3Size = SizeConfig.safeBlockVertical! * 2.2;
  static var textParagraphSize = SizeConfig.safeBlockVertical! * 4;
  static var textParagraph2Size = SizeConfig.safeBlockVertical! * 3;
  static var textCaptionSize = SizeConfig.safeBlockVertical! * 2;
  static var textCaption2Size = SizeConfig.safeBlockVertical! * 1.8;
  static var textCaption3Size = SizeConfig.safeBlockVertical! * 1.5;

  static var textLabelSize = SizeConfig.safeBlockVertical! * 2;
  static var textHeadlineWeight = FontWeight.bold;
  static var textSubTitleWeight = FontWeight.w500;
  static var textSubtitle2Weight = FontWeight.w500;
  static var textParagraphWeight = FontWeight.w300;
  static var textParagraph2Weight = FontWeight.w300;
  static var textCaptionWeight = FontWeight.w300;
  static var textLabelWeight = FontWeight.w600;
  static var textFontFamily = "opensans";

  //// Icons
  var iconSizeSmall = SizeConfig.safeBlockVertical! * 3;
  var iconSizeMedium = SizeConfig.safeBlockVertical! * 3;
  var iconSizelarge = SizeConfig.safeBlockVertical! * 6;
  var iconSizeExtralarge = SizeConfig.safeBlockVertical! * 8;

  //AppColors
  static const lightGrey = Color(0xffe9e9ea);
  static const grey = Colors.grey;
  static const background = Color(0xfff9f9f9);
  static const outline = Color(0xffebeef2);
  static const  projectTab=Color(0xff5451D6);
  static const textBlack = Colors.black;
  static const colorWarning=Color(0xffd80000);
  static const hold=Colors.red;
  static const pending=Colors.orange;
  static const completed=Colors.green;
}
