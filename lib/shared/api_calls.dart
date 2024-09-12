/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>MAY 24, 2023</date>
/////////////////////////////////////////////////////////

import 'dart:convert';
//import 'package:flutter/foundation.dart';
import 'package:clickclinician/models/chatmessage.dart';
import 'package:clickclinician/models/chatroom.dart';
import 'package:clickclinician/models/review.dart';
import 'package:clickclinician/screens/chat_screen.dart';
import 'package:clickclinician/screens/login_screen.dart';
import 'package:clickclinician/screens/map_screen.dart';
import 'package:clickclinician/screens/ratings_screen.dart';
import 'package:clickclinician/screens/service_request_screen.dart';
import 'package:clickclinician/screens/startup_screen.dart';
import 'package:clickclinician/screens/two_factor_authentication_screen.dart';
import 'package:clickclinician/screens/unauthorised_user_screen.dart';
import 'package:clickclinician/shared/models/accepted_service_req.dart';
import 'package:clickclinician/widgets/snack_bar_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../data/shared_preferences.dart';
import 'device_info.dart';
import 'models/click_user.dart';
import 'models/device.dart';
import 'models/service_request.dart';

class ApiCalls {
  ApiCalls();

  static final SPSettings _settings = SPSettings();
  //static String _baseUrl = 'http://localhost:6216';
  // static String _baseUrl = 'https://api.clickclinician.com';
  // static String _baseUrl = 'https://dev-clickapi.azurewebsites.net';
  // static String _baseUrl = 'https://clickclinician-live-api.azurewebsites.net';
  static String _baseUrl =
      "https://clickclinician-live-api-v2.azurewebsites.net";

  static String deviceToken = '';
  static bool? registeredDevice = _settings.getRegisteredDevice();
  static String bearerToken = _settings.getBearerToken();
  static String refreshToken = _settings.getRefreshToken();
  static List<ServiceRequest>? serviceRequests = _settings.getServiceRequests();
  static List<AcceptedServiceRequest>? acceptedServiceRequests =
      _settings.getAcceptedServiceRequests();
  static ClickUser? clickUser = _settings.getClickUser();
  static String? userId = _settings.getUserId();
  static String? userRole = _settings.getUserRole();
  static String? userName = _settings.getUserName();

  static String _lastChangeCode = _settings.getChangeCode();

  static set baseUrl(value) => _baseUrl = value;
  static String get baseUrl => _baseUrl;

  static void init() {}
  // static void init() {
  //   print('user ID in apis page: $userId');
  //   if (kDebugMode == false) {
  //     // _baseUrl = 'https://api.clickclinician.com';
  //     // _baseUrl = 'https://dev-clickapi.azurewebsites.net';
  //     _baseUrl = _baseUrl;
  //   } else if (ClickDeviceInfo.deviceToken.mobilePlatform == 0) {
  //     _baseUrl = 'http://10.0.2.2:6216';
  //   } else {
  //     _baseUrl = 'http://localhost:6216';
  //   }
  //   // _baseUrl = 'https://api.clickclinician.com';
  //   // _baseUrl = "http://192.168.1.17:6216";
  //   // _baseUrl = 'https://clickclinician-api-test.azurewebsites.net';
  //   _baseUrl = 'https://dev-clickapi.azurewebsites.net';
  //   // _baseUrl = 'https://clickclinician-live-api.azurewebsites.net';

  //   // _baseUrl = _baseUrl;
  // }

  static _setChangeCode(String changeCode) {
    _lastChangeCode = changeCode;
    _settings.setChangeCode(changeCode);
  }

  static _setBearerToken(String token) {
    bearerToken = token;
    _settings.setBearerToken(token);
  }

  static _setRefreshToken(String token) {
    refreshToken = token;
    _settings.setRefreshToken(token);
  }

  static _setDeviceToken(String token) {
    deviceToken = token;
    _settings.setDeviceToken(deviceToken);
  }

  static _setRegisteredDevice(bool token) {
    registeredDevice = token;
    _settings.setRegisteredDevice(registeredDevice!);
  }

  static _setUserName(String name) {
    userName = name;
    _settings.setUserName(userName!);
  }

  static _setUserId(String id) {
    userId = id;
    // _settings.setUserName(userId!);
  }

  static _setUserRole(String role) {
    userRole = role;
    _settings.setUserRole(userRole!);
  }

  static _setServiceRequests(List<ServiceRequest>? requests) {
    serviceRequests = requests;
    _settings.setServiceRequests(requests);
  }

  static _setAcceptedServiceRequests(List<AcceptedServiceRequest>? requests) {
    acceptedServiceRequests = requests;
    _settings.setAcceptedServiceRequests(requests);
  }

  static _setClickUser(ClickUser? user) {
    clickUser = user;
    _settings.setClickUser(user);
  }

  static void _clearCache(String changeCode) {
    _setChangeCode(changeCode);
    // _setServiceRequests(null);
    // _setAcceptedServiceRequests(null);
    // _setClickUser(null);
    // userId = null;
  }

  static Future<ClickUser> whoami(context, {String? userid}) async {
    print('user id =====> $userId');
    debugPrint('inside who am I call');
    // if (clickUser != null) {
    //   String changeCode = await getChangeCode(context);
    //   if (changeCode == _lastChangeCode && _lastChangeCode != '') {
    //     return clickUser as ClickUser;
    //   }

    //   _clearCache(changeCode);
    // }
    String id;
    if (userid != null) {
      id = userid;
    } else if (userId != null) {
      id = userId!;
    } else {
      id = '';
    }
    // var id = userid!.isNotEmpty ? userid : userId;
    debugPrint('id value inside who am I call: $id');

    String endpoint = '/api/User?userId=$id';
    // String endpoint = '/api/User?userId=$userId';
    var received = await _getEndpoint(endpoint, context, "whoami");

    if (received == '') {
      return ClickUser();
    }

    dynamic jsonResults = json.decode(received);
    var result = ClickUser.fromJson(jsonResults);
    debugPrint('user info: $result');
    userId = result.id;

    _setClickUser(result);

    return result;
  }

  static Future<dynamic> updateMe(
      Map<String, dynamic> updatedUserInfo, context) async {
    try {
      String endpoint = '/api/User?userId=$userId';
      String endpointUrl = baseUrl + endpoint;

      final response = await http.post(Uri.parse(endpointUrl),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(updatedUserInfo));
      print('post response code : ${response.statusCode}');

      if (response.statusCode == 401) {
        logout(context, 'Inside Update Me Api');
      }

      if (response.statusCode >= 200 && response.statusCode <= 204) {
        print("res from api: $response");
        showSnackBar(
            context, 'Profile Updated successfully!', SnackbarColors.success);
        dynamic jsonResults = json.decode(response.body);
        var result = ClickUser.fromJson(jsonResults);
        userId = result.id;
        _setClickUser(result);
        return response.body;
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        var errorMessage = responseData['message'];
        showSnackBar(context, errorMessage ?? response.reasonPhrase!,
            SnackbarColors.error);
        return response.statusCode.toString();
      }
    } catch (e) {
      print('error in update me: $e');
      showSnackBar(
          context, 'Something Went Wrong While Updating', SnackbarColors.error);
    }
  }

  static Future<dynamic> updateSettings(
      Map<String, dynamic> settingsInfo, context) async {
    String endpoint = '/api/User/Filter?userId=$userId';
    // await _postEndpoint(endpoint, settingsInfo, context);
    try {
      String endpointUrl = baseUrl + endpoint;

      final response = await http.post(Uri.parse(endpointUrl),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
            // 'Accept': 'application/json',
          },
          body: jsonEncode(settingsInfo));
      debugPrint('post response code : ${response.statusCode}');

      if (response.statusCode == 401) {
        logout(context, 'Inside Post Endpoint Api');
      }

      if (response.statusCode >= 200 && response.statusCode <= 204) {
        debugPrint("res from api: $response");
        showSnackBar(
            context, 'Settings Updated Successfully!', SnackbarColors.success);
        return response.body;
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        var errorMessage = responseData['message'];
        showSnackBar(context, errorMessage ?? response.reasonPhrase!,
            SnackbarColors.error);
        return response.statusCode.toString();
      }
    } catch (error) {
      debugPrint('error in post req catch: $error');
      showSnackBar(context, 'Something went wrong!', SnackbarColors.error);
      return error.toString();
    }
  }

  static Future<void> acceptRequest(
      String requestId, context, Function(bool) onCallaBack) async {
    print('request id in accept req: $requestId');
    onCallaBack(true);
    // if (requestId == '') {
    //   return;
    // }
    // serviceRequests = null;
    // acceptedServiceRequests = null;

    String endpoint = '/api/ServiceRequest/Accept?requestId=$requestId';
    // String endpoint = '/api/ServiceRequest/Accept?requestId=$requestId';
    // await _postEndpoint(endpoint, null, context);
    try {
      String endpointUrl = baseUrl + endpoint;

      final response = await http.post(
        Uri.parse(endpointUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print('post response code : ${response.statusCode}');
      onCallaBack(false);

      if (response.statusCode == 401) {
        logout(context, 'Inside Accept Req APi');
      }

      if (response.statusCode >= 200 && response.statusCode <= 204) {
        print("res from api: $response");
        showSnackBar(
            context, 'Request Accepted Successfully!', SnackbarColors.success);
        var jsonResults = json.decode(response.body);
        debugPrint('jsonResults[Id]: ${jsonResults['Id']}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ServiceRequestsScreen(),
          ),
        );
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   AcceptedRequestsScreen.routeName,
        //   ModalRoute.withName(MapScreen.routeName),
        //   arguments: jsonResults['Id'],
        // );
        return;
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        var errorMessage = responseData['message'];
        showSnackBar(context, errorMessage, SnackbarColors.error);
        Navigator.of(context).pop();
        return;
      }
    } catch (error) {
      showSnackBar(context, 'Something went wrong!', SnackbarColors.error);
      Navigator.of(context).pop();
      onCallaBack(false);
      return;
    }
  }

  static Future<void> declineRequest(
      String requestId, context, Function(bool) onCallaBack) async {
    onCallaBack(true);
    if (requestId == '') {
      onCallaBack(false);
      return;
    }
    serviceRequests = null;
    acceptedServiceRequests = null;

    String endpoint =
        '/api/ServiceRequest/Decline?requestId=$requestId&userId=$userId';
    await _postEndpoint(endpoint, null, context,
        onCallaBack: onCallaBack, message: 'Service Rrequet Declined');
  }

  static Future<dynamic> getAcceptedRequestData(
      String requestId, context) async {
    // if (requestId == '') {
    //   return null;
    // }

    print('inside get sr api: $requestId');
    // serviceRequests = null;
    // acceptedServiceRequests = null;

    String endpoint =
        '/api/ServiceRequest/Accepted?requestId=$requestId&userId=$userId';
    try {
      final response = await http.get(
        Uri.parse(baseUrl + endpoint),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      if (response.statusCode >= 200 && response.statusCode <= 204) {
        dynamic jsonResults = json.decode(response.body);
        print('decoded json: $jsonResults');

        return jsonResults;
      } else {
        showSnackBar(context, 'Error Declining', SnackbarColors.error);
      }
    } catch (e) {
      print('error in getAcceptedRequestData: $e');
      showSnackBar(context, e.toString(), SnackbarColors.error);
    }
    // var received =
    //     await _getEndpoint(endpoint, context, 'getAcceptedRequestData');

    // if (received == '') {
    //   return null;
    // }
  }

  static Future<void> acceptAndPassRequest(
      String requestId, context, Function(bool) onCallaBack) async {
    onCallaBack(true);
    if (requestId == '') {
      onCallaBack(false);
      return;
    }
    serviceRequests = null;
    acceptedServiceRequests = null;

    String endpoint =
        '/api/ServiceRequest/AcceptEvaluate?requestId=$requestId&userId=$userId';
    await _postEndpoint(endpoint, null, context,
        onCallaBack: onCallaBack, message: 'Reqest passed to assistant');
  }

  static Future<List<AcceptedServiceRequest>> getAcceptedServiceRequests(
      context, Function(bool) onChangedCallback) async {
    onChangedCallback(true);
    print(
        'inside get accepted ser req api & acceptedServiceRequests: $acceptedServiceRequests');
    // if (acceptedServiceRequests != null) {
    // String changeCode = await getChangeCode(context);
    // if (changeCode == _lastChangeCode && _lastChangeCode != '') {
    //   return acceptedServiceRequests ?? <AcceptedServiceRequest>[];
    // }

    // _clearCache(changeCode);
    // }

    List<AcceptedServiceRequest> result = <AcceptedServiceRequest>[];
    String endpoint = '/api/ServiceRequests/Accepted';
    if (userId != '') {
      endpoint += '?Skip=0&Take=100&Sort=&userId=$userId';
    }

    var received =
        await _getEndpoint(endpoint, context, 'getAcceptedServiceRequests');

    if (received == '') {
      onChangedCallback(false);
      return result;
    }

    if (received.isNotEmpty) {
      dynamic jsonResults = json.decode(received);

      List<dynamic> pageResults = jsonResults['PageResults'];
      for (int i = 0; i < pageResults.length; i++) {
        var request = AcceptedServiceRequest.fromJson(pageResults[i]);
        print('response forma api: ${request.patientFirstName}');
        result.insert(0, request); //will show new requests first
        // result.add(request);
      }

      acceptedServiceRequests = result;
      onChangedCallback(false);
    }
    onChangedCallback(false);
    return result;
  }

  static Future<List<ServiceRequest>> getAllServiceRequests(
      String clinicianId, context,
      {bool? isFilter}) async {
    // if (serviceRequests != null) {
    //   String changeCode = await getChangeCode(context);
    //   if (changeCode == _lastChangeCode && _lastChangeCode != '') {
    //     return serviceRequests ?? <ServiceRequest>[];
    //   }

    //   _clearCache(changeCode);
    // }
    print('inside get all srs api');

    List<ServiceRequest> result = <ServiceRequest>[];
    String endpoint = '/api/ServiceRequests/Open';
    if (clinicianId != '') {
      endpoint += '?userId=$clinicianId';
    }

    var received =
        await _getEndpoint(endpoint, context, 'getAllServiceRequests');
    print('api call: $received');

    if (received == '') {
      return result;
    }

    dynamic jsonResults = json.decode(received);
    debugPrint('decoded json: $jsonResults');

    List<dynamic> pageResults = jsonResults['PageResults'];
    for (int i = 0; i < pageResults.length; i++) {
      var request = ServiceRequest.fromJson(pageResults[i]);

      if (isFilter == true) {
        if (request.serviceRequestType == 'open') {
          result.add(request);
        }
      } else {
        result.add(request);
      }
    }

    serviceRequests = result;

    return result;
  }

  static Future<dynamic> getServiceRequest(String requestId, context) async {
    print('inside get sr api');
    String endpoint = '/api/ServiceRequest/Open';
    if (requestId != '') {
      endpoint += '?requestId=$requestId';
    }

    var received = await _getEndpoint(endpoint, context, 'getServiceRequest');

    dynamic jsonResults = json.decode(received);

    return jsonResults;
  }

  static Future<String> getChangeCode(context) async {
    var received =
        await _getEndpoint('/api/ChangeCode', context, 'getChangeCode');
    if (received != '') {
      dynamic jsonResults = json.decode(received);
      return jsonResults['Code'];
    }

    return '';
  }

  static void registerDevice(DeviceToken deviceToken, context) async {
    print(deviceToken);
    debugPrint('inside register data api call');
    var jsonToken = deviceToken.toJson();
    debugPrint('registered device call in api: $registeredDevice');
    // if (registeredDevice == true) {
    //   return;
    // }
    try {
      String endpointUrl =
          '$baseUrl/api/NotificationService/CreateDeviceForUser';
      debugPrint('iendpoint url inside post req: $endpointUrl');

      final response = await http.post(Uri.parse(endpointUrl),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(jsonToken));
      print(
          'post response code inside registed device: ${response.statusCode}');

      if (response.statusCode == 401) {
        logout(context, 'Inside Post Endpoint Api');
      }

      if (response.statusCode >= 200 && response.statusCode <= 204) {
        // showSnackBar(context, 'Successful!', SnackbarColors.success);
        _setRegisteredDevice(true);
      } else {
        Map<String, dynamic>? responseData = jsonDecode(response.body);
        var errorMessage = responseData?['message'];
        showSnackBar(
            context,
            errorMessage.toString().isNotEmpty
                ? errorMessage
                : response.reasonPhrase!,
            SnackbarColors.error);
      }
    } catch (error) {
      debugPrint('error in post req catch: $error');
      showSnackBar(context, 'Something went wrong!', SnackbarColors.error);
    }
  }

  static Future<List<Review>> getReviews({
    required BuildContext context,
  }) async {
    String revieweeId = _settings.getUserId().toString();
    final Uri url = Uri.parse('$baseUrl/api/Review/reviewee/$revieweeId');
    String bearerToken = _settings.getBearerToken();
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return Review.listFromJson(jsonList);
      } else {
        throw Exception('Failed to load reviews: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  static Future<List<ChatRoom>> getChatList(BuildContext context) async {
    String userId = _settings.getUserId().toString();
    String path = '/api/Chat/rooms?userId=$userId';
    final finalPath = Uri.parse(baseUrl + path);
    String validToken = _settings.getBearerToken();
    try {
      final response = await http.get(
        finalPath,
        headers: {'Authorization': 'Bearer $validToken'},
      );

      if (response.statusCode >= 200 && response.statusCode <= 204) {
        final List<ChatRoom> chatRooms = ChatRoom.listFromJson(response.body);
        chatRooms.sort(
            (a, b) => b.lastMessageTimestamp.compareTo(a.lastMessageTimestamp));
        return chatRooms;
      } else {
        print(
            "Something is wrong-------------------------------${response.statusCode}");
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        throw Exception(
            'Failed to load chat rooms: ${jsonResponse['message']}');
      }
    } catch (error) {
      print("Something is wrong-------------------------------");
      print(error.toString());
      showSnackBar(context, 'Something went wrong!', SnackbarColors.error);
      throw error;
    }
  }

  static Future<List<ChatMessage>> getChatMessages({
    required String chatRoomId,
    required int skip,
    required int take,
    required BuildContext context,
  }) async {
    final Uri url = Uri.parse(
        '$baseUrl/api/Chat/messages?skip=$skip&take=$take&chatRoomId=$chatRoomId');
    String bearerToken = _settings.getBearerToken();
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return ChatMessage.listFromJson(jsonList);
      } else {
        throw Exception('Failed to load chat messages: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching chat messages: $e');
      // You might want to show a snackbar or some other error message to the user here
      return [];
    }
  }

  static Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String receiverId,
    required String message,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$baseUrl/api/Chat/send');
    final bearerToken = _settings.getBearerToken();

    final body = jsonEncode({
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $bearerToken',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('Message sent successfully');
      } else {
        print('Failed to send message. Status code: ${response.statusCode}');
        throw Exception('Failed to send message');
      }
    } catch (e) {
      print('Error sending message: $e');
      throw e;
    }
  }

  static Future<String> login(String username, String password,
      BuildContext context, Function(bool) onChangedCallback) async {
    onChangedCallback(true);
    const String path = '/connect/token';
    final tokenEndpoint = Uri.parse(baseUrl + path);
    final requestBody = {
      'grant_type': 'password',
      'client_id': 'owner',
      'client_secret': 'fancyawesome',
      'username': username,
      'password': password,
    };

    try {
      final response = await http.post(
        tokenEndpoint,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: requestBody,
      );

      if (response.statusCode >= 200 && response.statusCode <= 204) {
        final responseData = jsonDecode(response.body);
        final accessToken = responseData['access_token'];

        // Don't save tokens yet, fetch user info first
        await fetchUserInfo(context,
            token: accessToken, onChangedCallback: onChangedCallback);

        return accessToken;
      } else {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        String errorDescription =
            jsonResponse['error_description'] ?? 'Unknown Error';
        showSnackBar(context, errorDescription, SnackbarColors.error);
        onChangedCallback(false);
        return '';
      }
    } catch (error) {
      print(error.toString());
      showSnackBar(context, 'Something went wrong!', SnackbarColors.error);
      onChangedCallback(false);
      return '';
    }
  }

  static Future<void> fetchUserInfo(BuildContext context,
      {String? token, Function(bool)? onChangedCallback}) async {
    onChangedCallback!(true);
    String path = "/connect/userinfo";
    String validToken = token!.isNotEmpty ? token : bearerToken;
    try {
      final response = await http.get(
        Uri.parse(baseUrl + path),
        headers: {'Authorization': 'Bearer $validToken'},
      );
      print("response.statusCode Fetch => ${response.statusCode}");
      if (response.statusCode >= 200 && response.statusCode <= 204) {
        final responseData = jsonDecode(response.body);
        print("User is $responseData");
        if (responseData['two_factor_enabled'] == "true") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TwoFactorAuthScreen(
                userId: responseData["sub"],
                onVerificationSuccess: () {
                  _saveUserData(responseData, validToken);
                  _navigateBasedOnRole(
                      context, responseData['role'], responseData["sub"]);
                },
              ),
            ),
          );
        } else {
          _saveUserData(responseData, validToken);
          _navigateBasedOnRole(
              context, responseData['role'], responseData["sub"]);
        }

        onChangedCallback(false);
        print('data fetched successfully! $responseData');
      }
    } catch (e) {
      onChangedCallback(false);
      print('error while fetching user info: $e');
      showSnackBar(context, 'Error fetching user info', SnackbarColors.error);
    }
  }

  static void _saveUserData(Map<String, dynamic> userData, String token) {
    _setBearerToken(token);
    _setRefreshToken(
        token); // You might want to handle refresh token separately
    _setUserId(userData['sub']);
    _setUserName(userData['user_display_name']);
    _setUserRole(userData['role']);
  }

  static void _navigateBasedOnRole(
      BuildContext context, String role, String userId) {
    if (role == 'Clinician') {
      whoami(context, userid: userId);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MapScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UnauthorisedUserScreen()),
      );
    }
  }

  static Future<bool> verifyTwoFactorCode(String userId, String code) async {
    print("Verify code called");
    const String path = "/api/TwoFactorAuth/verify-code";

    try {
      final response = await http.post(
        Uri.parse(baseUrl + path),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'code': code}),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print("Exception occurred: $e");
      return false;
    }
  }

  static Future<bool> sendTwoFactorCode(String userId) async {
    print("Send code called");
    const String path = "/api/TwoFactorAuth/send-code";

    try {
      final response = await http.post(
        Uri.parse(baseUrl + path),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userId),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print("Exception occurred: $e");
      return false;
    }
  }

  static Future<dynamic> logout(context, String apiName) async {
    print(apiName);
    const String path = '/Account/Logout';
    // var result = await _postEndpoint(path, null, context);

    _setBearerToken('');
    _clearCache('');
    // _setChangeCode(changeCode);
    _setServiceRequests(null);
    _setAcceptedServiceRequests(null);
    _setClickUser(null);
    userId = null;
    _settings.setUserName('');
    _settings.setPassword('');
    _setBearerToken('');
    _setRefreshToken('');
    _setDeviceToken('');
    _setRegisteredDevice(false);
    showSnackBar(context, 'Loggedout Successfully!', SnackbarColors.success);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
    // return result;
  }

  static Future<String> _getEndpoint(
      String endpoint, context, String getEnpointCall) async {
    print('get Endpoint Call in: $getEnpointCall');
    try {
      String endpointUrl = baseUrl + endpoint;
      print('end point in get api: $endpoint');

      final response = await http.get(
        Uri.parse(endpointUrl),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 401) {
        logout(context, "Inside Get endpoint API");
      }

      if (response.statusCode >= 200 && response.statusCode <= 204) {
        print('successful get req: ${response.body}');
        return response.body;
      } else {
        Map<String, dynamic>? responseData = jsonDecode(response.body);
        var errorMessage = responseData?['message'];
        showSnackBar(
            context,
            errorMessage.toString().isNotEmpty
                ? errorMessage
                : response.reasonPhrase!,
            SnackbarColors.error);
        // Request failed, handle the error
        print('Request failed, handle the error: ${response.reasonPhrase}');
        // showSnackBar(context, response.reasonPhrase!, SnackbarColors.error);
      }
    } catch (error) {
      print('Request failed, handle the error: $error');
      // Error occurred during the request
      showSnackBar(context, 'Something went wrong!', SnackbarColors.error);
    }

    return '';
  }

  static Future<String> _postEndpoint(String endpoint, Object? body, context,
      {Function(bool)? onCallaBack, String? message}) async {
    onCallaBack!(true);
    try {
      String endpointUrl = baseUrl + endpoint;

      final response = await http.post(Uri.parse(endpointUrl),
          headers: {
            'Authorization': 'Bearer $bearerToken',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: body);
      print('post response code : ${response.statusCode}');
      onCallaBack(false);

      if (response.statusCode == 401) {
        logout(context, 'Inside Post Endpoint Api');
      }

      if (response.statusCode >= 200 && response.statusCode <= 204) {
        print("res from api: $response");
        showSnackBar(context, message ?? 'Successful!', SnackbarColors.success);
        return response.body;
      } else {
        Map<String, dynamic>? responseData = jsonDecode(response.body);
        var errorMessage = responseData?['message'];
        showSnackBar(
            context,
            errorMessage.toString().isNotEmpty
                ? errorMessage
                : response.reasonPhrase!,
            SnackbarColors.error);
        // showSnackBar(context, response.reasonPhrase!, SnackbarColors.error);
        return response.statusCode.toString();
      }
    } catch (error) {
      debugPrint('error in post req catch: $error');
      showSnackBar(context, 'Something went wrong!', SnackbarColors.error);
      onCallaBack(false);
      return error.toString();
    }
  }
}
