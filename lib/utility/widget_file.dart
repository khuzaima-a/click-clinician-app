import 'package:clickclinician/utility/style_file.dart';
import 'package:flutter/material.dart';
import 'package:clickclinician/utility/color_file.dart';
import 'package:flutter_svg/svg.dart';

class DesignWidgets {
  static Widget addVerticalSpace(double height) {
    return SizedBox(
      height: height,
    );
  }

  static Widget addHorizontalSpace(double width) {
    return SizedBox(
      width: width,
    );
  }

  static Widget getButton(
      {required String text,
      required VoidCallback onTap,
      Color backgroundColor = ColorsUI.primaryColor,
      Color foregroundColor = Colors.white,
      double borderRadios = 12.0,
      double margin = 0,
      bool disabled = false,
      bool isLoading = false}) {
    return Container(
      margin: margin > 0 ? EdgeInsets.all(margin) : null,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: disabled ? () {} : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadios),
          ),
        ),
        child: !isLoading
            ? Text(text)
            : const SizedBox(
                height: 12,
                width: 12,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  static Widget getProfileIcon(
      BuildContext context, String name, VoidCallback onClick) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: [
         const Padding(
            padding: const EdgeInsets.only(top: 72.0),
            child: Center(
                child: Icon(
              Icons.account_circle_rounded,
              color: ColorsUI.primaryColor,
              size: 100,
            )),
          ),
          addVerticalSpace(8),
          Text(
            "Hello ${name.split(" ").first}!",
            style: CustomStyles.headingText,
          ),
          addVerticalSpace(32),
        ],
      ),
    );
  }

  static Widget profileItem(
      String title, String icon, IconData? name, Null Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Row(
        children: [
          addHorizontalSpace(32),
          icon == ""
              ? Icon(
                  name,
                  color: ColorsUI.primaryColor,
                  size: 24,
                )
              : SvgPicture.asset(
                  icon,
                  width: 22,
                  height: 22,
                  color: ColorsUI.primaryColor,
                ),
          addHorizontalSpace(4.0),
          Container(
            height: 56,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              title,
              style: CustomStyles.subHeadingText,
            ),
          ),
        ],
      ),
    );
  }

  static Widget divider() {
    return Container(
      height: 1,
      color: ColorsUI.backgroundColor.withOpacity(0.8),
    );
  }

  static Widget signOutItem(Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Column(
        children: [
          Container(
            height: 80,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.logout_outlined,
                  color: ColorsUI.primaryColor,
                  size: 24,
                ),
                addHorizontalSpace(16.0),
                Text(
                  "Sign Out",
                  style: CustomStyles.headingPrimary,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
