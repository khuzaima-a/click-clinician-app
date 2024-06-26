/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>MAY 27, 2023</date>
/////////////////////////////////////////////////////////

import 'package:intl/intl.dart';

class ServiceRequest {
  String id = '';
  String? patientFirstName;
  DateTime? patientDateOfBirth;
  int? patientAge = 0;
  int? patientSex = 0;
  String priority = '';
  bool wasPassed = true;
  double approxLongitude = 0.0;
  double approxLatitude = 0.0;
  String? requestType;
  String? createdOn;
  bool canBePassed = true;
  DateTime? createdDateTimeUTC;
  String? serviceRequestType;

  ServiceRequest.fromJson(Map<String, dynamic> json)
      : id = json['Id'],
        patientFirstName = json['PatientFirstName'] ?? 'N/A',
        patientDateOfBirth = json['PatientDateOfBirth'] == null
            ? null
            : DateTime.parse(json['PatientDateOfBirth']),
        patientAge = json['PatientAge'],
        patientSex = json['PatientSex'],
        priority = json['Priority'],
        wasPassed = json['WasPassed'],
        approxLongitude = json['ApproxLongitude'],
        approxLatitude = json['ApproxLatitude'],
        createdOn = json['CreatedOn'] == null
            ? null
            : DateFormat.yMd()
                .add_jm()
                .format((DateTime.parse(json['CreatedOn']).toLocal())),
        requestType = json['RequestType'] ?? '',
        canBePassed = json['CanBePassed'],
        createdDateTimeUTC = json['CreatedDateTimeUTC'] == null
            ? null
            : DateTime.parse(json['CreatedDateTimeUTC']),
        serviceRequestType = json['ServiceRequestType'];

  Map<String, dynamic> toJson() => {
        'Id': id,
        'PatientFirstName': patientFirstName,
        'PatientDateOfBirth': patientDateOfBirth,
        'PatientAge': patientAge,
        'PatientSex': patientSex,
        'Priority': priority,
        'WasPassed': wasPassed,
        'ApproxLongitude': approxLongitude,
        'ApproxLatitude': approxLatitude,
        'CreatedOn': createdOn,
        'RequestType': requestType,
        'CanBePassed': canBePassed,
        'CreatedDateTimeUTC': createdDateTimeUTC,
        'ServiceRequestType': serviceRequestType,
      };
}
