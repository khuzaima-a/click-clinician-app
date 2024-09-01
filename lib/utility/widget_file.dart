import 'package:clickclinician/screens/map_screen.dart';
import 'package:clickclinician/utility/style_file.dart';
import 'package:clickclinician/utility/utils.dart';
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
      Color? borderColor,
      double margin = 0,
      bool disabled = false,
      bool isLoading = false,
      bool elevate = true}) {
    return Container(
      margin: margin > 0 ? EdgeInsets.all(margin) : null,
      width: double.infinity,
      decoration: elevate
          ? BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(4, 4),
                ),
              ],
            )
          : const BoxDecoration(),
      child: ElevatedButton(
        onPressed: disabled ? () {} : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadios),
            side: borderColor != null
                ? BorderSide(color: borderColor, width: 1.0)
                : BorderSide.none,
          ),
        ),
        child: !isLoading
            ? Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
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
            "Hello ${name.split(" ").first}",
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

  static Widget getRadioButtonWithIcon(
      {required String title,
      required bool isSelected,
      required String iconPath,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.only(left: 10, right: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorsUI.primaryColor.withOpacity(0.2)
              : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: ColorsUI.primaryColor,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                  color: ColorsUI.primaryColor,
                ),
                DesignWidgets.addHorizontalSpace(2.0),
              ],
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: CustomStyles.radioButtonText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget getParagraph({required String text, double padding = 32.0}) {
    return Column(
      children: [
        Text(
          text,
          style: CustomStyles.legalPara,
          textAlign: TextAlign.justify,
        ),
        DesignWidgets.addVerticalSpace(padding),
      ],
    );
  }

  static Widget profileImageDisplay({double radius = 80}) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: ColorsUI.primaryColor.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            "assets/images/profile_dummy.svg",
            height: (radius - 2) * 2,
            width: (radius - 2) * 2,
          ),
        ),
        Positioned(
          bottom: 14,
          right: 14,
          child: CircleAvatar(
            radius: radius / 4.5,
            backgroundColor: Colors.amber,
            child: const Icon(
              Icons.mode_edit_outline_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  static Widget getList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => listItem(item)).toList(),
    );
  }

  static Widget listItem(String item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 12, top: 4),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
                color: Colors.black, shape: BoxShape.circle),
            child: null,
          ),
          Expanded(
            child: Text(item, style: CustomStyles.legalPara),
          ),
        ],
      ),
    );
  }

  static Widget getAppBar(BuildContext context, String pageTitle,
      {bool isMapScreen = false, GlobalKey<ScaffoldState>? scaffoldKey}) {
    return Stack(
      children: [
        Container(
          width: displayWidth(context),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          decoration: const BoxDecoration(
            color: ColorsUI.primaryColor,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (isMapScreen) {
                      scaffoldKey!.currentState?.openDrawer();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isMapScreen
                          ? const Icon(Icons.menu_open_sharp,
                              color: Colors.white, size: 16)
                          : const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 16),
                    ),
                  ),
                ),
                Text(
                  pageTitle,
                  style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ]),
        ),
        Positioned(
          top: -35,
          right: 100,
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color.fromARGB(75, 255, 255, 255),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: 60,
          child: Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: Color.fromARGB(75, 255, 255, 255),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  static Widget getChatBubble(
    String senderName,
    String message,
    String time,
    int unreadCount,
    String shortNames,
  ) {
    return ListTile(
      leading: const Icon(
        Icons.account_circle_rounded,
        color: ColorsUI.primaryColor,
        size: 48,
      ),
      horizontalTitleGap: 12,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            senderName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          addHorizontalSpace(8.0),
          shortNames.isNotEmpty
              ? Text(
                  "($shortNames)",
                  style: TextStyle(fontSize: 14.0),
                )
              : Container()
        ],
      ),
      subtitle: Text(
          message.length > 32 ? "${message.substring(0, 32)}..." : message),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(time, style: TextStyle(fontSize: 12, color: Colors.grey)),
          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: ColorsUI.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  static Widget getChatScreenAppBar(
      BuildContext context, String name, VoidCallback openDialog,
      {bool isGroupChat = true}) {
    return Stack(
      children: [
        Container(
          width: displayWidth(context),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          decoration: const BoxDecoration(
            color: ColorsUI.primaryColor,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                    DesignWidgets.addHorizontalSpace(16.0),
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ]),
              isGroupChat
                  ? GestureDetector(
                      onTap: openDialog,
                      child: const Icon(
                        Icons.expand_more_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ],
    );
  }

  static Widget getParticipantDialog(
      BuildContext context, List<String> participants) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Container(
        height: displayHeight(context) * 0.4,
        child: Column(
          children: [
            addVerticalSpace(16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Group Members",
                        style: CustomStyles.headingText,
                        textAlign: TextAlign.center,
                      ),
                      addHorizontalSpace(12.0),
                      Text(
                        "(${participants.length})",
                        style: TextStyle(
                            fontSize: 16.0, color: ColorsUI.lightHeading),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.cancel,
                        color: ColorsUI.primaryColor,
                        size: 26.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            addVerticalSpace(12.0),
            Divider(),
            addVerticalSpace(12.0),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                child: ListView.builder(
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    final participant = participants[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.account_circle_rounded,
                            color: ColorsUI.primaryColor,
                            size: 32,
                          ),
                          addHorizontalSpace(12.0),
                          Text(
                            participant,
                            style: const TextStyle(
                                fontSize: 16.0, color: ColorsUI.headingColor),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            addVerticalSpace(16.0),
          ],
        ),
      ),
    );
  }
}
