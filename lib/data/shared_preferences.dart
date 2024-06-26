/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>JUNE 13, 2023</date>
/////////////////////////////////////////////////////////

import 'dart:convert';

import 'package:clickclinician/shared/models/accepted_service_req.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../shared/models/click_user.dart';
import '../shared/models/service_request.dart';

class SPSettings {
  final String _keyChangeCode = 'changeCode';
  final String _keyUserId = 'userId';
  final String _keyUsername = 'userName';
  final String _keyPassword = 'password';
  final String _keyBearerToken = 'bearerToken';
  final String _keyRefreshToken = 'refreshToken';
  final String _keyServiceRequests = 'serviceRequests';
  final String _keyAcceptedServiceRequests = 'acceptedServiceRequests';
  final String _keyClickUser = 'clickUser';
  final String _keyDeviceToken = 'deviceToken';
  final String _keyRegisteredDevice = 'registeredDevice';

  static SPSettings? _instance;
  static late SharedPreferences _sharedPreferences;

  SPSettings.internal();

  factory SPSettings() {
    _instance ??= SPSettings.internal();

    return _instance as SPSettings;
  }

  Future init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future setChangeCode(String changeCode) async {
    await _sharedPreferences.setString(_keyChangeCode, changeCode);
  }

  String getChangeCode() {
    return _sharedPreferences.getString(_keyChangeCode) ?? '';
  }

  Future setUserId(String userId) async {
    await _sharedPreferences.setString(_keyUserId, userId);
  }

  String? getUserId() {
    return _sharedPreferences.getString(_keyUserId);
  }

  Future setUserName(String userName) async {
    await _sharedPreferences.setString(_keyUsername, userName);
  }

  String? getUserName() {
    return _sharedPreferences.getString(_keyUsername);
  }

  Future setUserRole(String userRole) async {
    await _sharedPreferences.setString(_keyUsername, userRole);
  }

  String? getUserRole() {
    return _sharedPreferences.getString(_keyUsername);
  }

  Future setPassword(String password) async {
    await _sharedPreferences.setString(_keyPassword, password);
  }

  String? getPassword() {
    return _sharedPreferences.getString(_keyPassword);
  }

  Future setDeviceToken(String token) async {
    await _sharedPreferences.setString(_keyDeviceToken, token);
  }

  String? getDeviceToken() {
    return _sharedPreferences.getString(_keyDeviceToken);
  }

  bool? getRegisteredDevice() {
    return _sharedPreferences.getBool(_keyRegisteredDevice);
  }

  Future<void> setRegisteredDevice(bool value) async {
    await _sharedPreferences.setBool(_keyRegisteredDevice, value);
  }

  Future setBearerToken(String bearerToken) async {
    await _sharedPreferences.setString(_keyBearerToken, bearerToken);
  }

  String getBearerToken() {
    return _sharedPreferences.getString(_keyBearerToken) ?? '';
  }

  Future setRefreshToken(String token) async {
    await _sharedPreferences.setString(_keyRefreshToken, token);
  }

  String getRefreshToken() {
    return _sharedPreferences.getString(_keyRefreshToken) ?? '';
  }

  Future setServiceRequests(List<ServiceRequest>? requests) async {
    if (requests == null) {
      await _sharedPreferences.setStringList(_keyServiceRequests, []);
      return;
    }

    List<String> value = [];
    for (var request in requests) {
      var jsonData = request.toJson();
      value.add(json.encode(jsonData));
    }

    await _sharedPreferences.setStringList(_keyServiceRequests, value);
  }

  Future setAcceptedServiceRequests(
      List<AcceptedServiceRequest>? requests) async {
    if (requests == null) {
      await _sharedPreferences.setStringList(_keyAcceptedServiceRequests, []);
      return;
    }

    List<String> value = [];
    for (var request in requests) {
      var jsonData = request.toJson();
      value.add(json.encode(jsonData));
    }

    await _sharedPreferences.setStringList(_keyAcceptedServiceRequests, value);
  }

  List<ServiceRequest>? getServiceRequests() {
    List<String>? storedValues =
        _sharedPreferences.getStringList(_keyServiceRequests);

    if (storedValues == null) {
      return null;
    }

    List<ServiceRequest> requests = [];
    for (var value in storedValues) {
      var request = ServiceRequest.fromJson(json.decode(value));
      requests.add(request);
    }

    return requests.isNotEmpty ? requests : null;
  }

  List<AcceptedServiceRequest>? getAcceptedServiceRequests() {
    List<String>? storedValues =
        _sharedPreferences.getStringList(_keyServiceRequests);

    if (storedValues == null) {
      return null;
    }

    List<AcceptedServiceRequest> requests = [];
    for (var value in storedValues) {
      var request = AcceptedServiceRequest.fromJson(json.decode(value));
      requests.add(request);
    }

    return requests.isNotEmpty ? requests : null;
  }

  Future setClickUser(ClickUser? clickUser) async {
    if (clickUser == null) {
      await _sharedPreferences.setString(_keyClickUser, '');
      return;
    }

    await setUserId(clickUser.id);
    var jsonData = clickUser.toJson();
    await _sharedPreferences.setString(_keyClickUser, json.encode(jsonData));
  }

  ClickUser? getClickUser() {
    String? storedValue = _sharedPreferences.getString(_keyClickUser);

    if (storedValue == null || storedValue == '') {
      return null;
    }

    ClickUser user = ClickUser.fromJson(json.decode(storedValue));
    return user;
  }
}
