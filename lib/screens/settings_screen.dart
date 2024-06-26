/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>JUNE 13, 2023</date>
/////////////////////////////////////////////////////////

import 'package:clickclinician/utility/color_file.dart';
import 'package:clickclinician/utility/widget_file.dart';
import 'package:clickclinician/widgets/const/custom_form_fields.dart';
import 'package:clickclinician/widgets/snack_bar_notification.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/api_calls.dart';
import '../shared/models/click_user.dart';
import '../widgets/nav_drawer.dart';
import '../widgets/shared.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const String routeName = '/Settings';

  @override
  State<StatefulWidget> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final Color _uneditableColor = const Color.fromARGB(180, 200, 200, 200);

  Future<ClickUser> fetchData(context, userId) {
    return ApiCalls.whoami(context);
  }

  static late SharedPreferences _sharedPreferences;
  final String _keyUserId = 'userId';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _filterRadiusController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final TextEditingController _zipcodeFilterController =
      TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode filterRadiusFocusNode = FocusNode();
  final FocusNode zipCodeFocusNode = FocusNode();

  Color filterRadiosFillColor = ColorsUI.backgroundColor;
  Color zipCodeFillColor = ColorsUI.backgroundColor;

  void _onFilterRadiusFocusChange() {
    setState(() {
      filterRadiosFillColor = filterRadiusFocusNode.hasFocus
          ? Colors.white
          : ColorsUI.backgroundColor;
    });
  }

  void _onZipCodeFocusChange() {
    setState(() {
      zipCodeFillColor =
          zipCodeFocusNode.hasFocus ? Colors.white : ColorsUI.backgroundColor;
    });
  }

  String userTypeId = ''; // New variable to track loading state
  bool _isProfileButtonLoading = false;
  bool _isPasswordButtonLoading = false;
  bool _isLoading = true;
  bool _isUpdating = false;
  String userId = '';
  String _selectedState = '';
  int _filterRadiusMiles = 0;
  bool _filterEnabled = true;
  bool _twofactorAuthenticationEnabled = false;
  bool _notificationEnabled = true;
  bool _isDisabled = true;
  bool _lockoutEnabled = true;
  String _lockoutEnd = '';

  ClickUser? clickUser;
  late AsyncSnapshot<ClickUser> localUser;

  @override
  void initState() {
    super.initState();
    filterRadiusFocusNode.addListener(_onFilterRadiusFocusChange);
    zipCodeFocusNode.addListener(_onZipCodeFocusChange);
    _fetchData(context).then((_) => {
          setState(() {
            _isLoading = false;
            _isUpdating = false;
          })
        });
  }

  String? getUserId() {
    print(
        '_sharedPreferences.getString(_keyUserId): ${_sharedPreferences.getString(_keyUserId)}');
    return _sharedPreferences.getString(_keyUserId);
  }

  Future setUserId(String userId) async {
    await _sharedPreferences.setString(_keyUserId, userId);
  }

  Future<void> _fetchData(context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      // fetch profile info api
      var data = await ApiCalls.whoami(context);
      ClickUser? user = data;
      setState(() {
        _nameController.text = user.displayName;
        _userNameController.text = user.userName;
        _emailController.text = user.email;
        _phoneNumberController.text = formatPhoneNumber('${user.phoneNumber}');
        _addressController.text = user.address1 ?? '';
        _address2Controller.text = user.address2 ?? '';
        _cityController.text = user.city ?? '';
        _selectedState = user.state ?? 'tx';
        _zipcodeController.text = user.zipCode ?? '';
        userTypeId = user.userTypeId ?? '';
        _filterRadiusController.text = user.filterRadiusMiles.toString();
        _filterEnabled = user.isFilterEnabled;
        _zipcodeFilterController.text = user.filterZipCode ?? '';
        _twofactorAuthenticationEnabled = user.twoFactorEnabled;
        _notificationEnabled = user.notificationsDisabled;
        _isDisabled = user.isDisabled;
        _lockoutEnabled = user.lockoutEnabled;
        _lockoutEnd = user.lockoutEnd ?? '';

        _isLoading = false;
      });
    } catch (e) {
      print('error while fetching the data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateUser(context) async {
    setState(() {
      _isUpdating = true;
    });
    try {
      // fetch profile info api
      Map<String, dynamic> updatedUserInfo = {
        "filterZipCode": _zipcodeFilterController.text,
        "filterRadiusMiles": int.parse(_filterRadiusController.text),
        // "FilterRadiusMiles": 60,
        "isFilterEnabled": _filterEnabled
      };
      print('selected state: $updatedUserInfo');
      debugPrint(
          'filter radius miles: ${int.parse(_filterRadiusController.text)}');
      await ApiCalls.updateSettings(updatedUserInfo, context);
      // Optionally, perform any actions after the update
    } catch (e) {
      debugPrint('update setting: $e');
      showSnackBar(context, e.toString(), Colors.grey);
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ClickUser>(
        future: fetchData(context, _keyUserId),
        builder: (BuildContext context, AsyncSnapshot<ClickUser> localUser) {
          // if (localUser.connectionState == ConnectionState.waiting && _isUpdating) {
          //   return const Center(
          //       child:
          //           CircularProgressIndicator()); // Display a loading indicator
          // } else
          if (localUser.hasError) {
            return Text(
                'Error: ${localUser.error}'); // Display an error message
          } else {
            ClickUser? user = localUser.data;

            return _isLoading
                ? const Scaffold(
                    backgroundColor: Colors.white,
                    body: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Scaffold(
                    backgroundColor: Colors.white,
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 36.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: Container(
                                          padding: const EdgeInsets.all(6.0),
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                54, 119, 121, 124),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.arrow_back)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    const Text(
                                      "Settings",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                              DesignWidgets.addVerticalSpace(24.0),
                              _buildProfileForm(context),
                              const SizedBox(
                                height: 16.0,
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     const Text("Id: ", textAlign: TextAlign.left),
                              //     Text(user?.id ?? "",
                              //         textAlign: TextAlign.right,
                              //         style: TextStyle(
                              //             backgroundColor: _uneditableColor)),
                              //   ],
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     const Text("Display Name: ",
                              //         textAlign: TextAlign.left),
                              //     Text(user?.displayName ?? "",
                              //         textAlign: TextAlign.right,
                              //         style: TextStyle(
                              //             backgroundColor: _uneditableColor)),
                              //   ],
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     const Text("UserName: ", textAlign: TextAlign.left),
                              //     Text(user?.userName ?? "",
                              //         textAlign: TextAlign.right,
                              //         style: TextStyle(
                              //             backgroundColor: _uneditableColor)),
                              //   ],
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     const Text("Filter enabled: ",
                              //         textAlign: TextAlign.left),
                              //     Text((user?.isFilterEnabled ?? false).toString(),
                              //         textAlign: TextAlign.right,
                              //         style: TextStyle(
                              //             backgroundColor: _uneditableColor)),
                              //   ],
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     const Text("Filter radius (in miles): ",
                              //         textAlign: TextAlign.left),
                              //     Text((user?.filterRadiusMiles ?? 0).toString(),
                              //         textAlign: TextAlign.right,
                              //         style: TextStyle(
                              //             backgroundColor: _uneditableColor)),
                              //   ],
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     const Text("ZipCode Filter: ",
                              //         textAlign: TextAlign.left),
                              //     Text(user?.filterZipCode ?? "",
                              //         textAlign: TextAlign.right,
                              //         style: TextStyle(
                              //             backgroundColor: _uneditableColor)),
                              //   ],
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     const Text("2 factor authentication enabled: ",
                              //         textAlign: TextAlign.left),
                              //     Text((user?.twoFactorEnabled ?? false).toString(),
                              //         textAlign: TextAlign.right,
                              //         style: TextStyle(
                              //             backgroundColor: _uneditableColor)),
                              //   ],
                              // ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     const Text("Notifications enabled: ",
                              //         textAlign: TextAlign.left),
                              //     Text(
                              //         (!(user?.notificationsDisabled ?? true))
                              //             .toString(),
                              //         textAlign: TextAlign.right,
                              //         style: TextStyle(
                              //             backgroundColor: _uneditableColor)),
                              //   ],
                              // ),
                            ]),
                      ),
                    ),
                  );
          }
        });
  }

  Widget _buildProfileForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileInfo(context),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Box 1
        Container(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: const Color.fromARGB(167, 158, 158, 158)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Theme(
            data: ThemeData(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: const Text(
                'Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              maintainState: true,
              initiallyExpanded: true,
              tilePadding: const EdgeInsets.only(left: 8.0, right: 8.0),
              childrenPadding: const EdgeInsets.all(8.0),
              children: [
                DesignWidgets.addVerticalSpace(4.0),
                // buildFullWidthFormField('Name', _nameController, 'Name',
                //     _nameEntered, 'Enter Name', true),
                // buildFullWidthFormField('Email', _emailController, 'Email',
                //     _isEmailValid, 'Add Valid Email', true),
                buildFullWidthFormField(
                    'Filte Radius',
                    _filterRadiusController,
                    'Filter Radius (in miles)',
                    true,
                    '',
                    false,
                    filterRadiusFocusNode,
                    filterRadiosFillColor),
                buildFullWidthFormField(
                    'Filter Zip Code',
                    _zipcodeFilterController,
                    'Filter Zip Code',
                    true,
                    '',
                    false,
                    zipCodeFocusNode,
                    zipCodeFillColor),
                DesignWidgets.addVerticalSpace(12.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildFilterCheckbox(),
                    DesignWidgets.addVerticalSpace(8.0),
                    // const SizedBox(
                    //   height: 16.0,
                    // ),
                    // _buildNotificationCheckbox(),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        DesignWidgets.getButton(
          text: "Save",
          onTap: () {
            _updateUser(context);
          },
          isLoading: _isUpdating,
        ),
      ],
    );
  }

  Widget _buildFilterCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Is Filter Enabled',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(width: 8.0),
        InkWell(
          onTap: () {
            setState(() {
              _filterEnabled = !_filterEnabled;
            });
          },
          child: Container(
            height: 30.0,
            width: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: _filterEnabled
                    ? ColorsUI.primaryColor
                    : ColorsUI.backgroundColor,
                width: 2.0,
              ),
              color: _filterEnabled
                  ? ColorsUI.primaryColor
                  : ColorsUI.backgroundColor,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 200),
                  left: _filterEnabled ? 30.0 : 5.0,
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Is Notification Enabled',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
        ),
        const SizedBox(width: 8.0),
        InkWell(
          onTap: () {
            setState(() {
              _notificationEnabled = !_notificationEnabled;
            });
          },
          child: Container(
            height: 30.0,
            width: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: !_notificationEnabled ? Colors.green : Colors.grey,
                width: 2.0,
              ),
              color: !_notificationEnabled ? Colors.green : Colors.grey,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  left: !_notificationEnabled ? 30.0 : 5.0,
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
