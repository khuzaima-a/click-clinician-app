/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>JUNE 13, 2023</date>
/////////////////////////////////////////////////////////

import 'package:json_annotation/json_annotation.dart';

part 'click_user.g.dart';

// dart run build_runner build

@JsonSerializable()
class ClickUser
{
  ClickUser();

  // ignore: non_constant_identifier_names
  String id = "";
  String userName = "";
  String email = "";
  String? phoneNumber;
  String displayName = "";
  bool isDisabled = true;
  String? role;
  String? userTypeId;
  UserType? userType;
  String? createdOn;
  bool notificationsDisabled = false;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? zipCode;
  bool emailConfirmed = false;
  bool phoneNumberConfirmed = false;
  bool twoFactorEnabled = false;
  bool lockoutEnabled = false;
  String? lockoutEnd;
  String? filterZipCode;
  int filterRadiusMiles = 0;
  bool isFilterEnabled = false;

  factory ClickUser.fromJson(Map<String, dynamic> json) =>
      _$ClickUserFromJson(json);

  Map<String, dynamic> toJson() => _$ClickUserToJson(this);
}

@JsonSerializable()
class UserType
{
  UserType();
  
  String id = "";
  String name = "";
  String? createdOn;
  bool canPass = false;
  int serviceRequestTypeId = 0;
  ServiceRequestType serviceRequestType = ServiceRequestType();
  int specialtyId = 0;
  Specialty specialty = Specialty();
  String? passToUserTypeId;
  UserType? passToUserType;
  String? roleId;
  Role role = Role();
  String? description;
  String? abbreviation;
  int order = 0;

  factory UserType.fromJson(Map<String, dynamic> json) =>
      _$UserTypeFromJson(json);

  Map<String, dynamic> toJson() => _$UserTypeToJson(this);
}

@JsonSerializable()
class ServiceRequestType
{
  ServiceRequestType();

  int id = 0;
  String name = "";
  String? description;

  factory ServiceRequestType.fromJson(Map<String, dynamic> json) =>
      _$ServiceRequestTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceRequestTypeToJson(this);
}

@JsonSerializable()
class Specialty
{
  Specialty();

  int id = 0;
  String name = "";
  String? description;

  factory Specialty.fromJson(Map<String, dynamic> json) =>
      _$SpecialtyFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialtyToJson(this);
}

@JsonSerializable()
class Role
{
  Role();

  String id = "";
  String name = "";
  String? normalizedName;
  String? concurrencyStamp;
  bool hasUserTypes = false;

  factory Role.fromJson(Map<String, dynamic> json) =>
      _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);
}
