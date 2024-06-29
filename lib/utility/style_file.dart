import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clickclinician/utility/color_file.dart';

class CustomStyles {
  static TextStyle headingPrimary = GoogleFonts.inriaSans(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: ColorsUI.primaryColor,
  );

  static TextStyle headingSecondary = GoogleFonts.inriaSans(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: ColorsUI.yellow,
  );

  static TextStyle headingText = GoogleFonts.inriaSans(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: ColorsUI.headingColor,
  );

  static TextStyle headingSubText = GoogleFonts.inriaSans(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: ColorsUI.darkBorder,
  );

  static TextStyle headingWhite = GoogleFonts.inriaSans(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: Colors.white,
  );

  static TextStyle subHeadingPrimary = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: ColorsUI.primaryColor,
  );

  static TextStyle subHeadingSecondary = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: ColorsUI.yellow,
  );

  static TextStyle subHeadingText = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: ColorsUI.headingColor,
  );

  static TextStyle subHeadingSubText = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: ColorsUI.darkBorder,
  );

  static TextStyle subHeadingWhite = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    color: Colors.white,
  );

  static TextStyle paragraphPrimary = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: ColorsUI.primaryColor,
  );

  static TextStyle paragraphSecondary = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: ColorsUI.yellow,
  );

  static TextStyle paragraphText = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: ColorsUI.headingColor,
  );

  static TextStyle paragraphSubText = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: ColorsUI.darkBorder,
  );

  static TextStyle paragraphWhite = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: Colors.white,
  );

  static TextStyle numberPrimary = GoogleFonts.inriaSans(
    fontWeight: FontWeight.bold,
    fontSize: 32,
    color: ColorsUI.primaryColor,
  );

  static TextStyle numberSecondary = GoogleFonts.inriaSans(
    fontWeight: FontWeight.bold,
    fontSize: 32,
    color: ColorsUI.yellow,
  );

  static TextStyle numberText = GoogleFonts.inriaSans(
    fontWeight: FontWeight.bold,
    fontSize: 32,
    color: ColorsUI.headingColor,
  );

  static TextStyle numberSubText = GoogleFonts.inriaSans(
    fontWeight: FontWeight.bold,
    fontSize: 32,
    color: ColorsUI.darkBorder,
  );

  static TextStyle numberWhite = GoogleFonts.inriaSans(
    fontWeight: FontWeight.bold,
    fontSize: 32,
    color: Colors.white,
  );

  static TextStyle quotationQuestion = GoogleFonts.inter(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: ColorsUI.headingColor,
  );

  static TextStyle radioButtonText = GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: ColorsUI.headingColor,
  );

  static TextStyle radioButtonBoldText = GoogleFonts.inter(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: ColorsUI.headingColor,
  );

  static Style paragraphPrimaryForHTML = Style(
    fontWeight: FontWeight.w400,
    fontSize: FontSize(12),
    color: ColorsUI.primaryColor,
    fontFamily: "inter",
  );

  static Style paragraphSecondaryForHTML = Style(
    fontWeight: FontWeight.w400,
    fontSize: FontSize(12),
    color: ColorsUI.yellow,
    fontFamily: "inter",
  );

  static Style paragraphTextForHTML = Style(
    fontWeight: FontWeight.w400,
    fontSize: FontSize(12),
    color: ColorsUI.headingColor,
    fontFamily: "inter",
  );

  static Style paragraphSubTextForHTML = Style(
    fontWeight: FontWeight.w400,
    fontSize: FontSize(12),
    color: ColorsUI.darkBorder,
    fontFamily: "inter",
  );

  static Style paragraphWhiteForHTML = Style(
    fontWeight: FontWeight.w400,
    fontSize: FontSize(12),
    color: Colors.white,
    fontFamily: "inter",
  );

  static TextStyle legalHeading = const TextStyle(
      fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black);

  static TextStyle legalPara =
      const TextStyle(fontSize: 15.0, color: Colors.black,
      
      );
}
