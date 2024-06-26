// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'click_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClickUser _$ClickUserFromJson(Map<String, dynamic> json) => ClickUser()
  ..id = json['Id'] as String
  ..userName = json['UserName'] as String
  ..email = json['Email'] as String
  ..phoneNumber = json['PhoneNumber'] as String?
  ..displayName = json['DisplayName'] as String
  ..isDisabled = json['IsDisabled'] as bool
  ..role = json['Role'] as String?
  ..userTypeId = json['UserTypeId'] as String?
  ..userType = UserType.fromJson(json['UserType'] as Map<String, dynamic>)
  ..createdOn = json['CreatedOn'] as String?
  ..notificationsDisabled = json['NotificationsDisabled'] as bool
  ..address1 = json['Address1'] as String?
  ..address2 = json['Address2'] as String?
  ..city = json['City'] as String?
  ..state = json['State'] as String?
  ..zipCode = json['ZipCode'] as String?
  ..emailConfirmed = json['EmailConfirmed'] as bool
  ..phoneNumberConfirmed = json['PhoneNumberConfirmed'] as bool
  ..twoFactorEnabled = json['TwoFactorEnabled'] as bool
  ..lockoutEnabled = json['LockoutEnabled'] as bool
  ..lockoutEnd = json['LockoutEnd'] as String?
  ..filterZipCode = json['FilterZipCode'] as String?
  ..filterRadiusMiles = json['FilterRadiusMiles'] as int
  ..isFilterEnabled = json['IsFilterEnabled'] as bool;

Map<String, dynamic> _$ClickUserToJson(ClickUser instance) => <String, dynamic>{
      'Id': instance.id,
      'UserName': instance.userName,
      'Email': instance.email,
      'PhoneNumber': instance.phoneNumber,
      'DisplayName': instance.displayName,
      'IsDisabled': instance.isDisabled,
      'Role': instance.role,
      'UserTypeId': instance.userTypeId,
      'UserType': instance.userType,
      'CreatedOn': instance.createdOn,
      'NotificationsDisabled': instance.notificationsDisabled,
      'Address1': instance.address1,
      'Address2': instance.address2,
      'City': instance.city,
      'State': instance.state,
      'ZipCode': instance.zipCode,
      'EmailConfirmed': instance.emailConfirmed,
      'PhoneNumberConfirmed': instance.phoneNumberConfirmed,
      'TwoFactorEnabled': instance.twoFactorEnabled,
      'LockoutEnabled': instance.lockoutEnabled,
      'LockoutEnd': instance.lockoutEnd,
      'FilterZipCode': instance.filterZipCode,
      'FilterRadiusMiles': instance.filterRadiusMiles,
      'IsFilterEnabled': instance.isFilterEnabled,
    };

UserType _$UserTypeFromJson(Map<String, dynamic> json) => UserType()
  ..id = json['Id'] as String
  ..name = json['Name'] as String
  ..createdOn = json['CreatedOn'] as String?
  ..canPass = json['CanPass'] as bool
  ..serviceRequestTypeId = json['ServiceRequestTypeId'] as int
  ..serviceRequestType = ServiceRequestType.fromJson(
      json['ServiceRequestType'] as Map<String, dynamic>)
  ..specialtyId = json['SpecialtyId'] as int
  ..specialty = Specialty.fromJson(json['Specialty'] as Map<String, dynamic>)
  ..passToUserTypeId = json['PassToUserTypeId'] as String?
  ..passToUserType = json['PassToUserType'] == null ? null : UserType.fromJson(json['PassToUserType'] as Map<String, dynamic>)
  ..roleId = json['RoleId'] as String?
  ..role = Role.fromJson(json['Role'] as Map<String, dynamic>)
  ..description = json['Description'] as String?
  ..abbreviation = json['Abbreviation'] as String?
  ..order = json['Order'] as int;

Map<String, dynamic> _$UserTypeToJson(UserType instance) => <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'CreatedOn': instance.createdOn,
      'CanPass': instance.canPass,
      'ServiceRequestTypeId': instance.serviceRequestTypeId,
      'ServiceRequestType': instance.serviceRequestType,
      'SpecialtyId': instance.specialtyId,
      'Specialty': instance.specialty,
      'PassToUserTypeId': instance.passToUserTypeId,
      'PassToUserType': instance.passToUserType,
      'RoleId': instance.roleId,
      'Role': instance.role,
      'Description': instance.description,
      'Abbreviation': instance.abbreviation,
      'Order': instance.order,
    };

ServiceRequestType _$ServiceRequestTypeFromJson(Map<String, dynamic> json) =>
    ServiceRequestType()
      ..id = json['Id'] as int
      ..name = json['Name'] as String
      ..description = json['Description'] as String?;

Map<String, dynamic> _$ServiceRequestTypeToJson(ServiceRequestType instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Description': instance.description,
    };

Specialty _$SpecialtyFromJson(Map<String, dynamic> json) => Specialty()
  ..id = json['Id'] as int
  ..name = json['Name'] as String
  ..description = json['Description'] as String?;

Map<String, dynamic> _$SpecialtyToJson(Specialty instance) => <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'Description': instance.description,
    };

Role _$RoleFromJson(Map<String, dynamic> json) => Role()
  ..id = json['Id'] as String
  ..name = json['Name'] as String
  ..normalizedName = json['NormalizedName'] as String?
  ..concurrencyStamp = json['ConcurrencyStamp'] as String?
  ..hasUserTypes = json['HasUserTypes'] as bool;

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'NormalizedName': instance.normalizedName,
      'ConcurrencyStamp': instance.concurrencyStamp,
      'HasUserTypes': instance.hasUserTypes,
    };
