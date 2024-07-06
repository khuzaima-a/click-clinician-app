/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>JUNE 13, 2023</date>
/////////////////////////////////////////////////////////

import 'package:clickclinician/screens/map_screen.dart';
import 'package:clickclinician/utility/color_file.dart';
import 'package:clickclinician/utility/utils.dart';
import 'package:clickclinician/utility/widget_file.dart';
import 'package:clickclinician/widgets/const/custom_form_fields.dart';
import 'package:clickclinician/widgets/snack_bar_notification.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/api_calls.dart';
import '../shared/models/click_user.dart';
import '../widgets/nav_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/Profile';

  @override
  State<StatefulWidget> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final Color _uneditableColor = const Color.fromARGB(180, 200, 200, 200);

  static late SharedPreferences _sharedPreferences;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  final FocusNode address2FocusNode = FocusNode();
  final FocusNode cityFocusNode = FocusNode();
  final FocusNode stateFocusNode = FocusNode();
  final FocusNode zipcodeFocusNode = FocusNode();
  final FocusNode currentPasswordFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  Color nameFillColor = ColorsUI.backgroundColor;
  Color emailFillColor = ColorsUI.backgroundColor;
  Color phoneNumberFillColor = ColorsUI.backgroundColor;
  Color addressFillColor = ColorsUI.backgroundColor;
  Color address2FillColor = ColorsUI.backgroundColor;
  Color cityFillColor = ColorsUI.backgroundColor;
  Color stateFillColor = ColorsUI.backgroundColor;
  Color zipcodeFillColor = ColorsUI.backgroundColor;
  Color currentPasswordFillColor = ColorsUI.backgroundColor;
  Color newPasswordFillColor = ColorsUI.backgroundColor;
  Color confirmPasswordFillColor = ColorsUI.backgroundColor;

  void _onNameFocusChange() {
    setState(() {
      nameFillColor =
          nameFocusNode.hasFocus ? Colors.white : ColorsUI.backgroundColor;
    });
  }

  void _onEmailFocusChange() {
    setState(() {
      emailFillColor =
          emailFocusNode.hasFocus ? Colors.white : ColorsUI.backgroundColor;
    });
  }

  void _onPhoneNumberFocusChange() {
    setState(() {
      phoneNumberFillColor = phoneNumberFocusNode.hasFocus
          ? Colors.white
          : ColorsUI.backgroundColor;
    });
  }

  void _onAddressFocusChange() {
    setState(() {
      addressFillColor =
          addressFocusNode.hasFocus ? Colors.white : ColorsUI.backgroundColor;
    });
  }

  void _onAddress2FocusChange() {
    setState(() {
      address2FillColor =
          address2FocusNode.hasFocus ? Colors.white : ColorsUI.backgroundColor;
    });
  }

  void _onCityFocusChange() {
    setState(() {
      cityFillColor =
          cityFocusNode.hasFocus ? Colors.white : ColorsUI.backgroundColor;
    });
  }

  void _onStateFocusChange() {
    setState(() {
      stateFillColor =
          stateFocusNode.hasFocus ? Colors.white : ColorsUI.backgroundColor;
    });
  }

  void _onZipcodeFocusChange() {
    setState(() {
      zipcodeFillColor =
          zipcodeFocusNode.hasFocus ? Colors.white : ColorsUI.backgroundColor;
    });
  }

  void _onCurrentPasswordFocusChange() {
    setState(() {
      currentPasswordFillColor = currentPasswordFocusNode.hasFocus
          ? Colors.white
          : ColorsUI.backgroundColor;
    });
  }

  void _onNewPasswordFocusChange() {
    setState(() {
      newPasswordFillColor = newPasswordFocusNode.hasFocus
          ? Colors.white
          : ColorsUI.backgroundColor;
    });
  }

  void _onConfirmPasswordFocusChange() {
    setState(() {
      confirmPasswordFillColor = confirmPasswordFocusNode.hasFocus
          ? Colors.white
          : ColorsUI.backgroundColor;
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
  Object _zipcodeFilter = [];
  bool _twofactorAuthenticationEnabled = false;
  bool _notificationEnabled = true;
  bool _isDisabled = true;
  bool _lockoutEnabled = true;
  String _lockoutEnd = '';

  // New validation state variables
  bool _nameEntered = true;
  bool _isEmailValid = true;
  bool _phoneNumberAdded = true;
  bool _addressAdded = true;
  bool _cityAdded = true;
  bool _stateAdded = true;
  bool _zipAdded = true;
  bool _currentPassword = true;
  bool _confirmPassword = true;
  ClickUser? clickUser;
  late AsyncSnapshot<ClickUser> localUser;

  final String _keyUserId = 'userId';
  Future<ClickUser> fetchData(context, userId) {
    return ApiCalls.whoami(context);
  }

  @override
  void initState() {
    super.initState();
    nameFocusNode.addListener(_onNameFocusChange);
    emailFocusNode.addListener(_onEmailFocusChange);
    phoneNumberFocusNode.addListener(_onPhoneNumberFocusChange);
    addressFocusNode.addListener(_onAddressFocusChange);
    address2FocusNode.addListener(_onAddress2FocusChange);
    cityFocusNode.addListener(_onCityFocusChange);
    stateFocusNode.addListener(_onStateFocusChange);
    zipcodeFocusNode.addListener(_onZipcodeFocusChange);
    currentPasswordFocusNode.addListener(_onCurrentPasswordFocusChange);
    newPasswordFocusNode.addListener(_onNewPasswordFocusChange);
    confirmPasswordFocusNode.addListener(_onConfirmPasswordFocusChange);
    _fetchData(context).then((_) => {
          setState(() {
            _isLoading = false;
            _isUpdating = false;
          })
        });
  }

  Future<ClickUser>? _futureServiceRequests;
  Future<Future<ClickUser>> _refreshServiceRequests(context) async {
    setState(() {
      _futureServiceRequests = ApiCalls.whoami(context);
    });
    return _futureServiceRequests!;
  }

  Future<void> _fetchData(context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      // fetch profile info api
      var data = await ApiCalls.whoami(context);
      ClickUser user = data;
      setState(() {
        _nameController.text = user.displayName;
        _emailController.text = user.email;
        _phoneNumberController.text = formatPhoneNumber('${user.phoneNumber}');
        _addressController.text = user.address1 ?? '';
        _address2Controller.text = user.address2 ?? '';
        _cityController.text = user.city ?? '';
        // _stateController.text = user.state ?? 'tx';
        _selectedState = user.state ?? 'tx';
        // _stateController.text = 'name';
        _zipcodeController.text = user.zipCode ?? '';
        // _emailController.text = userData['email'] ?? '';
        userTypeId = user.userTypeId ?? '';
        _filterRadiusMiles = user.filterRadiusMiles;
        _filterEnabled = user.isFilterEnabled;
        _zipcodeFilter = user.filterZipCode ?? [];
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

  void _updateUser(context) async {
    setState(() {
      _isUpdating = true;
    });
    String username = _emailController.text;
    String number = _phoneNumberController.text;
    String name = _nameController.text;
    String address = _addressController.text;
    String city = _cityController.text;
    String state = _selectedState;
    String zip = _zipcodeController.text;

    // Validate email and password
    setState(() {
      _isEmailValid =
          username.isNotEmpty && RegExp(r'\S+@\S+\.\S+').hasMatch(username);
      _phoneNumberAdded = number.isNotEmpty;
      _nameEntered = name.isNotEmpty;
      _addressAdded = address.isNotEmpty;
      _cityAdded = city.isNotEmpty;
      _stateAdded = state.isNotEmpty;
      _zipAdded = zip.isNotEmpty;
    });
    if (!_isEmailValid ||
        !_phoneNumberAdded ||
        !_phoneNumberAdded ||
        !_addressAdded ||
        !_zipAdded ||
        !_cityAdded) {
      print('params empty');
      setState(() {
        _isUpdating = false;
      });
      return;
    }
    try {
      // fetch profile info api
      var data = await ApiCalls.whoami(context);
      ClickUser? user = data;
      Map<String, dynamic> updatedUserInfo = {
        "DisplayName": _nameController.text,
        "Email": _emailController.text,
        "PhoneNumber": formatPhoneNumber(_phoneNumberController.text),
        "Address1": _addressController.text,
        "Address2": _address2Controller.text,
        "City": _cityController.text,
        "State": _selectedState,
        "ZipCode": _zipcodeController.text,
        "Role": user.role ?? '',
        "TwoFactorEnabled": _twofactorAuthenticationEnabled,
        "LockoutEnabled": _lockoutEnabled,
        "lockoutEnd": _lockoutEnd,
        "IsDisabled": _isDisabled,
        "UserTypeId": userTypeId,
        "FilterZipCode": _zipcodeFilter,
        "FilterRadiusMiles": _filterRadiusMiles,
        "IsFilterEnabled": _filterEnabled
      };
      print('selected state: $_selectedState');
      var res = await ApiCalls.updateMe(updatedUserInfo, context);
      print('response data from api call: $res');
      if (res.toString().isNotEmpty) {
        setState(() {
          print('inside called api: $_isUpdating');
          _isUpdating = false;
        });
      }
      // return res;
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.grey);
      setState(() {
        _isUpdating = false;
      });
    }
  }

  Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future setUserId(String userId) async {
    await _sharedPreferences.setString(_keyUserId, userId);
  }

  String? getUserId() {
    return _sharedPreferences.getString(_keyUserId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ClickUser>(
        future: fetchData(context, _keyUserId),
        builder: (BuildContext context, AsyncSnapshot<ClickUser> localUser) {
          // if (localUser.connectionState == ConnectionState.waiting &&
          //     _isLoading) {
          //   // if (localUser.connectionState == ConnectionState.waiting) {
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
                : SafeArea(
  child: Scaffold(
    backgroundColor: Colors.white,
    body: Column(
      children: [
        DesignWidgets.getAppBar(context, "Edit Profile"), // Fixed app bar
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _refreshServiceRequests(context),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Center(
                      child: DesignWidgets.profileImageDisplay(radius: 80),
                    ),
                    DesignWidgets.addVerticalSpace(24.0),
                    _buildProfileForm(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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
          // const SizedBox(height: 16.0),
          // _buildChangePassword(context),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Box 1
        Stack(
          children: [
            Positioned(
              top: -120,
              right: -45,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.lightBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                border:
                    Border.all(width: 1, color: Colors.blue.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Theme(
                data: ThemeData(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Row(children: [
                    const Icon(
                      Icons.account_box_rounded,
                      color: Color.fromARGB(206, 170, 172, 178),
                    ),
                    DesignWidgets.addHorizontalSpace(12),
                    const Text(
                      'Basic Information',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ]),
                  maintainState: true,
                  initiallyExpanded: true,
                  tilePadding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  childrenPadding: const EdgeInsets.all(8.0),
                  children: [
                    DesignWidgets.addVerticalSpace(4.0),
                    buildFullWidthFormField(
                        'Name',
                        _nameController,
                        'Name',
                        _nameEntered,
                        'Enter Name',
                        true,
                        nameFocusNode,
                        nameFillColor),
                    buildFullWidthFormField(
                        'Email',
                        _emailController,
                        'Email',
                        _isEmailValid,
                        'Add Valid Email',
                        true,
                        emailFocusNode,
                        emailFillColor),
                    buildFullWidthFormField(
                        'Phone Number',
                        _phoneNumberController,
                        'Phone Number',
                        _phoneNumberAdded,
                        'Add Valid Number',
                        true,
                        phoneNumberFocusNode,
                        phoneNumberFillColor),
                    DesignWidgets.addVerticalSpace(4.0),
                  ],
                ),
              ),
            ),
          ],
        ),
        DesignWidgets.addVerticalSpace(24.0),
        // Box 2
        Stack(
          children: [
            Positioned(
              top: -115,
              right: -45,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.lightBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                border:
                    Border.all(width: 1, color: Colors.blue.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Theme(
                data: ThemeData(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Row(children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: ColorsUI.darkBorder,
                    ),
                    DesignWidgets.addHorizontalSpace(12.0),
                    const Text(
                      'Address',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ]),
                  maintainState: true,
                  initiallyExpanded: true,
                  tilePadding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  childrenPadding: const EdgeInsets.all(8.0),
                  children: [
                    DesignWidgets.addVerticalSpace(4.0),
                    buildFullWidthFormField(
                        'Address',
                        _addressController,
                        'Street Address',
                        _addressAdded,
                        'Enter Address',
                        true,
                        addressFocusNode,
                        addressFillColor),
                    buildFullWidthFormField(
                        'Address 2',
                        _address2Controller,
                        'Suite/Apt/House Number',
                        true,
                        '',
                        false,
                        address2FocusNode,
                        address2FillColor),
                    buildFullWidthFormField(
                        'City',
                        _cityController,
                        'City',
                        _cityAdded,
                        'Add City',
                        true,
                        cityFocusNode,
                        cityFillColor),
                    buildCustomStatesDropdownFormField('State', _selectedState,
                        (newVlue) {
                      setState(() {
                        _selectedState = newVlue!;
                      });
                    }),
                    buildFullWidthFormField(
                        'Zipcode',
                        _zipcodeController,
                        'Zipcode',
                        _zipAdded,
                        'Enter Zip Code',
                        true,
                        zipcodeFocusNode,
                        zipcodeFillColor),
                    DesignWidgets.addVerticalSpace(4.0),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24.0),

        DesignWidgets.getButton(
            text: "Save",
            onTap: () {
              _updateUser(context);
            },
            isLoading: _isUpdating),
      ],
    );
  }

  Widget _buildChangePassword(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Positioned(
              top: -115,
              right: -45,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.lightBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                border:
                    Border.all(width: 1, color: Colors.blue.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Theme(
                data: ThemeData(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  maintainState: true,
                  initiallyExpanded: true,
                  tilePadding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  childrenPadding: const EdgeInsets.all(8.0),
                  children: [
                    DesignWidgets.addVerticalSpace(4.0),
                    buildFullWidthFormField(
                        'Current Password',
                        _currentPasswordController,
                        'Current password',
                        _currentPassword,
                        'Please Enter Correct Password',
                        true,
                        currentPasswordFocusNode,
                        currentPasswordFillColor),
                    buildFullWidthFormField(
                        'New Password',
                        _newPasswordController,
                        'New password',
                        true,
                        '',
                        false,
                        newPasswordFocusNode,
                        newPasswordFillColor),
                    buildFullWidthFormField(
                        'Confirm Password',
                        _confirmPasswordController,
                        'Confirm new password',
                        _confirmPassword,
                        'Please enter the same password',
                        _currentPasswordController.text.isNotEmpty
                            ? true
                            : false,
                        confirmPasswordFocusNode,
                        confirmPasswordFillColor),
                    DesignWidgets.addVerticalSpace(4.0),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        DesignWidgets.getButton(
            text: "Change Password",
            onTap: () {
              // _updatePassword(context);
            },
            isLoading: _isPasswordButtonLoading),
      ],
    );
  }
}
