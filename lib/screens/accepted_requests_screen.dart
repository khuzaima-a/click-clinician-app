/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>MAY 29, 2023</date>
/////////////////////////////////////////////////////////

import 'package:clickclinician/shared/api_calls.dart';
import 'package:clickclinician/utility/color_file.dart';
import 'package:clickclinician/utility/widget_file.dart';
import 'package:clickclinician/widgets/const/custom_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AcceptedRequestsScreen extends StatefulWidget {
  const AcceptedRequestsScreen({super.key, this.requestId});
  final String? requestId;

  @override
  State<AcceptedRequestsScreen> createState() => _AcceptedRequestsScreenState();
}

class _AcceptedRequestsScreenState extends State<AcceptedRequestsScreen> {
  String? requestId;

  @override
  void initState() {
    super.initState();
    requestId = widget.requestId;
  }

  bool _isLoading = false;

  String? specialNotes;
  String? patientLastName;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? zip;
  double actualLongitude = 0;
  double actualLatitude = 0;
  String? phoneNumber;
  int phoneNumberAlt = 0;
  DateTime? certPeriodStart;
  String? cancellationReason;
  String? acceptingTherapistName;
  String? patientStatus;
  // String? specialNotes;
  String homeHealthAgency = '';
  String acceptingTherapistId = '';
  String id = '';
  String? patientFirstName;
  DateTime? patientDateOfBirth;
  int? patientAge;
  int? patientSex;
  String? priority;
  String? gender;
  bool wasPassed = true;
  double approxLongitude = 0.0;
  double approxLatitude = 0.0;
  String? createdOn;
  bool canBePassed = true;
  DateTime? createdDateTimeUTC;
  String? serviceRequestType;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move this line to didChangeDependencies()
    fetchData(context);
  }

  Future<void> fetchData(BuildContext context) async {
    debugPrint('request ID inside fetch data function: $requestId');
    setState(() {
      _isLoading = true;
    });
    if (requestId != '') {
      var json =
          await ApiCalls.getAcceptedRequestData(requestId.toString(), context);
      debugPrint('called accepted api: $json');

      if (json != null) {
        setState(() {
          // userList = json;
          patientFirstName = json['PatientFirstName'] == null
              ? 'N/A'
              : json['PatientFirstName'].toString().isNotEmpty
                  ? json['PatientFirstName']
                  : 'N/A';

          patientLastName = json['PatientLastName'] ?? '';
          addressLine1 = json['AddressLine1'] ?? 'N/A';
          addressLine2 = json['AddressLine2'] ?? 'N/A';
          city = json['City'] ?? 'N/A';
          state = json['State'] ?? 'N/A';
          zip = json['Zip'] ?? 'N/A';
          phoneNumber = json['PhoneNumber'] != null
              ? json['PhoneNumber'] ?? 'N/A'
              : 'N/A';
          phoneNumberAlt = json['PhoneNumberAlt'] != null
              ? int.tryParse(json['PhoneNumberAlt'].toString()) ?? 0
              : 0;
          certPeriodStart = json['CertPeriodStart'] == null
              ? null
              : DateTime.parse(json['CertPeriodStart']);
          cancellationReason = json['CancellationReason'] ?? 'N/A';
          acceptingTherapistName = json['AcceptingTherapistName'] ?? 'N/A';
          patientStatus = json['PatientStatus'] ?? 'N/A';
          specialNotes = json['SpecialNotes'].toString().isNotEmpty
              ? json['SpecialNotes']
              : 'N/A';
          homeHealthAgency = json['HomeHealthAgency'] ?? '';
          acceptingTherapistId = json['AcceptingTherapistId'] ?? '';
          id = json['Id'];
          patientDateOfBirth = json['PatientDateOfBirth'] == null
              ? null
              : DateTime.parse(json['PatientDateOfBirth']);
          patientAge = json['PatientAge'];
          patientSex = json['PatientSex'];
          if (patientSex.toString().isNotEmpty && patientSex != null) {
            patientSex == 0
                ? gender = 'Female'
                : patientSex == 1
                    ? gender = 'Male'
                    : gender = 'Other';
          } else {
            gender = 'N/A';
          }
          priority = json['Priority'];
          wasPassed = json['WasPassed'];
          approxLongitude = json['ApproxLongitude'];
          approxLatitude = json['ApproxLatitude'];
          createdOn = json['CreatedOn'] == null
              ? null
              : DateFormat.yMd()
                  .add_jm()
                  .format((DateTime.parse(json['CreatedOn']).toLocal()));

          canBePassed = json['CanBePassed'];
          createdDateTimeUTC = json['CreatedDateTimeUTC'] == null
              ? null
              : DateTime.parse(json['CreatedDateTimeUTC']);
          serviceRequestType = json['ServiceRequestType'] ?? 'Accepted';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'request ID in accepted request page from arguments: $requestId');
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
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    DesignWidgets.getAppBar(context, "Request Details"),
                    Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: ColorsUI.primaryColor.withOpacity(0.05),
                              border: Border.all(
                                  width: 1,
                                  color: Colors.blue.withOpacity(0.4)),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Column(children: [
                              buildDetailItem(
                                  'Name', '$patientFirstName $patientLastName'),
                              const Divider(),
                              buildDetailItem('Gender', gender ?? 'N/A'),
                              const Divider(),
                              buildDetailItem(
                                  'Age', patientAge?.toString() ?? 'N/A'),
                              const Divider(),
                              buildDetailItem('Number', phoneNumber ?? 'N/A'),
                              const Divider(),
                              buildDetailItem('Priority', priority ?? 'N/A'),
                              const Divider(),
                              buildDetailItem(
                                  'Special Note', specialNotes ?? 'N/A'),
                              const Divider(),
                              buildDetailItem('Status',
                                  (serviceRequestType ?? 'N/A').toUpperCase()),
                              const Divider(),
                              buildDetailItem('Accepted By',
                                  acceptingTherapistName ?? 'N/A'),
                              const Divider(),
                              buildDetailItem('Address', addressLine1 ?? 'N/A'),
                              const Divider(),
                              buildDetailItem('Created On', createdOn ?? 'N/A'),
                            ]))),
                  ],
                ),
              ),
            ),
          );
  }
}
