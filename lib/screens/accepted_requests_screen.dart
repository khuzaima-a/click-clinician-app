/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>MAY 29, 2023</date>
/////////////////////////////////////////////////////////

import 'package:clickclinician/shared/api_calls.dart';
import 'package:clickclinician/widgets/const/custom_form_fields.dart';
import 'package:clickclinician/widgets/nav_drawer.dart';
import 'package:clickclinician/widgets/shared.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AcceptedRequestsScreen extends StatefulWidget {
  const AcceptedRequestsScreen({super.key, this.requestId});
  static const String routeName = "/acceptedRequestsScreen";
  final String? requestId;

  @override
  State<AcceptedRequestsScreen> createState() => _AcceptedRequestsScreenState();
}

class _AcceptedRequestsScreenState extends State<AcceptedRequestsScreen> {
  Object? requestId = [];
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Move this line to didChangeDependencies()
    requestId = ModalRoute.of(context)!.settings.arguments;
    fetchData(context);
  }

  Future<void> fetchData(BuildContext context) async {
    debugPrint('request ID inside fetch data function: $requestId');
    setState(() {
      _isLoading = true;
    });
    if (requestId != '') {
      var json =
          await ApiCalls.getAcceptedRequestData(requestId as String, context);
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
          // if (createdOn.toString().isNotEmpty) {
          //   DateTime? date = DateTime.parse(createdOn!);
          //   String displayDate = "${date.month}/${date.day}/${date.year}";
          //   createdOn = displayDate;
          // }
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
        : Scaffold(
            backgroundColor: Colors.grey[200], // Changed background color
            appBar: getAppBar(
                isBack: true, tabName: 'Accepted Service Request Details'),
            drawer: const NavDrawer(),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Text(
                      //   'Accepted Service Request Details',
                      //   style: TextStyle(
                      //     fontSize: 24, // Increased font size
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // const SizedBox(height: 16.0),
                      buildDetailItem(
                          'Name', '$patientFirstName $patientLastName'),
                      buildDetailItem('Gender', gender ?? 'N/A'),
                      buildDetailItem('Age', patientAge?.toString() ?? 'N/A'),
                      buildDetailItem('Number', phoneNumber ?? 'N/A'),
                      buildDetailItem('Priority', priority ?? 'N/A'),
                      buildDetailItem('Special Note', specialNotes ?? 'N/A'),
                      buildDetailItem('Status',
                          (serviceRequestType ?? 'N/A').toUpperCase()),
                      buildDetailItem(
                          'Accepted By', acceptingTherapistName ?? 'N/A'),
                      buildDetailItem('Address', addressLine1 ?? 'N/A'),
                      buildDetailItem('Created On', createdOn ?? 'N/A'),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
