import 'dart:convert';

import 'package:clickclinician/utility/color_file.dart';
import 'package:clickclinician/utility/style_file.dart';
import 'package:clickclinician/utility/widget_file.dart';
import 'package:clickclinician/widgets/const/resources.dart';
import 'package:flutter/material.dart';

class UserType {
  final String id;
  final String name;

  UserType({
    required this.id,
    required this.name,
  });

  factory UserType.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> specialtyJson = json['Specialty'] ?? {};
    // Map<String, dynamic> userType = json['PassToUserType'];
    // Return a new UserType with the extracted "Id" and "Name"
    return UserType(
      id: json['Id'],
      name: json['Name'],
    );
  }
}

class MobileDevice {
  String id;
  String userId;
  DateTime? creationDate; // Make creationDate nullable
  String deviceTokenString;
  int mobilePlatform;
  String deviceUniqueIdentifier;
  String deviceModel;
  String installedAppVersion;
  String operatingSystemVersion;
  bool notificationsEnabled;
  String therapistId;
  // additional properties for your specific case

  bool filterEnabled;
  String filterZipcode;
  int filterRadiusMiles;

  MobileDevice({
    required this.id,
    required this.userId,
    required String creationDate, // Update the type here
    required this.deviceTokenString,
    required this.mobilePlatform,
    required this.deviceUniqueIdentifier,
    required this.deviceModel,
    required this.installedAppVersion,
    required this.operatingSystemVersion,
    required this.notificationsEnabled,
    required this.therapistId,
    // additional properties for your specific case

    required this.filterEnabled,
    required this.filterZipcode,
    required this.filterRadiusMiles,
  }) : creationDate = _parseDate(creationDate);
  static DateTime? _parseDate(String dateString) {
    try {
      // Remove the milliseconds part
      final formattedDate = dateString.replaceAll(RegExp(r'\.\d{1,3}Z'), 'Z');
      return DateTime.parse(formattedDate);
    } catch (e) {
      print('Error parsing date: $e');
      return null;
    }
  }
}

String formatPhoneNumber(String phoneNumber) {
  // Remove any non-numeric characters from the phone number
  String numericPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

  // Apply the format (xxx) xxx-xxxx
  if (numericPhoneNumber.length == 10) {
    return '(${numericPhoneNumber.substring(0, 3)}) ${numericPhoneNumber.substring(3, 6)}-${numericPhoneNumber.substring(6)}';
  } else {
    // Return the original number if it doesn't match the expected length
    return phoneNumber;
  }
}

InputDecoration _getInputDecoration(
    String labelText, bool isValid, String message, bool toShow) {
  String decoratedLabel = toShow ? '$labelText *' : labelText;
  return InputDecoration(
    labelText: decoratedLabel,
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    errorText: toShow ? (isValid ? null : message) : null,
    errorBorder: toShow
        ? (isValid
            ? OutlineInputBorder()
            : OutlineInputBorder(borderSide: BorderSide(color: Colors.red)))
        : OutlineInputBorder(),
  );
}

Widget buildFullWidthFormField(
    String label,
    TextEditingController controller,
    String placeholder,
    bool isValid,
    String message,
    bool toShow,
    FocusNode focusMode,
    Color fillColor) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style:  TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: focusMode.hasFocus ? ColorsUI.primaryColor : ColorsUI.headingColor,
        )
      ),
      DesignWidgets.addVerticalSpace(4),
      TextField(
        controller: controller,
        focusNode: focusMode,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: message,
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 100, 8),
          hintStyle: CustomStyles.paragraphSubText,
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                const BorderSide(color: ColorsUI.primaryColor, width: 2.0),
          ),
          errorText: toShow ? (isValid ? null : message) : null,
          errorBorder: toShow
              ? (isValid
                  ? const OutlineInputBorder()
                  : const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)))
              : const OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 24.0),
    ],
  );
}

final List<Map<String, String>> states = HardCodedStateList.stateLists;

Widget buildCustomStatesDropdownFormField(
  String label,
  String value,
  Function(String?) onChangedCallback,
) {
  // Set a default value if the provided value is null or not in the items list
  // if (!items.contains(value)) {
  //   value = items.first;
  // }
  if (value.isEmpty || !states.any((item) => item['abbreviation'] == value)) {
    value = states.first['abbreviation']!;
  }

  print('value from params: $value');

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
         style:  TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color:  ColorsUI.headingColor,
        ),
      ),
      DesignWidgets.addVerticalSpace(4),
      Container(
        decoration: BoxDecoration(
          color: ColorsUI.backgroundColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          value: value,
          items: states.map((item) {
            return DropdownMenuItem<String>(
              value: item['abbreviation']!,
              child: Text(item['name']!),
            );
          }).toList(),
          onChanged: (newValue) {
            print('new selected value: $newValue');
            onChangedCallback(
                newValue); // Pass the selected value to the callback
          },
        ),
      ),
      SizedBox(height: 24.0),
    ],
  );
}

Widget buildCustomDropdownFormField(
  String label,
  String value,
  List<String> items,
  Function(String?) onChangedCallback,
) {
  // Set a default value if the provided value is null or not in the items list
  if (!items.contains(value)) {
    value = items.first;
  }

  print('value from params: $value');

  return Column(
    children: [
      Container(
        // padding: EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(0),
        ),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (newValue) {
            print('new selected value: $newValue');
            // setState(() {
            //   _selectedContactTitle = newValue!;
            // });
            onChangedCallback(newValue);
          },
        ),
      ),
      SizedBox(height: 16.0),
    ],
  );
}

Widget buildCustomRoleDropdownFormField(
  String label,
  String value,
  String items,
  Function(String?) onChangedCallback,
) {
  List<String> itemList = json.decode(items).cast<String>();

  // Set a default value if the provided value is null or not in the items list
  if (!itemList.contains(value)) {
    value = itemList.first;
  }

  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(0),
        ),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          value: value,
          items: itemList.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (newValue) {
            print('new selected specility: $newValue');
            // setState(() {
            //   _finalUserRole = newValue!;
            // });
            onChangedCallback(newValue);
          },
        ),
      ),
      const SizedBox(height: 16.0),
    ],
  );
}

Widget buildCustomSpecialistDropdownFormField(
  String label,
  UserType? value,
  List<UserType> items,
  BuildContext context,
  Function(UserType) onChangedCallback,
) {
  // Set a default value if the provided value is null or not in the items list
  if (value == null || !items.contains(value)) {
    value = items.isNotEmpty ? items.first : null;
  }
  print("specility value: $value");
  List<String> prioritizedOrder = [
    'Occupational Therapist'
        'Physical Therapist Assistant',
    'Physical Therapist',
  ];

  if (value == null || !items.contains(value)) {
    value = items.first;
  }

// Separate the items into two lists: prioritized and remaining
  List<UserType> prioritizedItems = [];
  List<UserType> remainingItems = [];

  for (var item in items) {
    if (prioritizedOrder.contains(item.name)) {
      prioritizedItems.add(item);
    } else {
      remainingItems.add(item);
    }
  }

// Concatenate the prioritized and remaining lists
  List<UserType> sortedItems = prioritizedItems + remainingItems;

// Set a default value if the provided value is null or not in the sortedItems list
  value = sortedItems.firstWhere(
    (item) => prioritizedOrder.contains(item.name),
    orElse: () => sortedItems.first,
  );

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(0),
    ),
    child: DropdownButtonFormField<UserType>(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      value: value,
      items: sortedItems.map((item) {
        return DropdownMenuItem<UserType>(
          value: item,
          child: Text(item.name),
        );
      }).toList(),
      onChanged: (newValue) {
        if (newValue != null) {
          // setState(() {
          //   // Use the correct variable here
          //   _finalSpecility = newValue;
          // });
          onChangedCallback(newValue);
        }
      },
    ),
  );
}

Widget buildCustomMobileDeviceDropdownFormField(
  String label,
  MobileDevice? value,
  List<MobileDevice> items,
  Null Function(MobileDevice? selectedDevice) param3,
  BuildContext context,
) {
  if (value == null || !items.contains(value)) {
    value = null; // Set initial value to null
  }

  return Container(
    // width: MediaQuery.of(context).size.width / 3,
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(0),
    ),
    child: DropdownButtonFormField<MobileDevice>(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      value: value,
      items: [
        // Add a hint as the first item
        DropdownMenuItem<MobileDevice>(
          value: null,
          child: Text('Select Device'),
        ),
        // Add other items
        ...items.map((item) {
          return DropdownMenuItem<MobileDevice>(
            value: item,
            child: Text(item.deviceModel),
          );
        }).toList(),
      ],
      onChanged: (newValue) {
        param3(newValue); // Call the callback function
      },
    ),
  );
}

Widget buildCustomPatientSexDropdownFormField(
  String label,
  String value,
  List<Map<String, String>> items,
  Function(String) onChangedCallback,
) {
  if (value.isEmpty || !items.any((item) => item['value'] == value)) {
    value = items.first['value']!;
  }
  print('value from params: $value');

  return Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(0),
        ),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item['value']!,
              child: Text(item['name']!),
            );
          }).toList(),
          onChanged: (newValue) {
            print('new selected value: $newValue');
            // setState(() {
            //   _patientSex = newValue!;
            // });
            onChangedCallback(newValue!);
          },
        ),
      ),
      const SizedBox(height: 16.0),
    ],
  );
}

Widget buildCustomPriorityDropdownFormField(
  String label,
  String value,
  List<String> items,
  Function(String) onChangedCallback,
) {
  // Set a default value if the provided value is null or not in the items list
  if (!items.contains(value)) {
    value = items.first;
  }
  print('value from params: $value');

  return Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(0),
        ),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (newValue) {
            print('new selected value: $newValue');
            // setState(() {
            //   _priority = newValue!;
            // });
            onChangedCallback(newValue!);
          },
        ),
      ),
    ],
  );
}

Widget buildField(
    String label, String? data, double dataFontSize, double labelFontSize) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(
        width: 115,
        child: Text(
          '$label:',
          style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: labelFontSize),
        ),
      ),
      SizedBox(width: 10),
      Text(
        data ?? 'N/A',
        style: TextStyle(fontSize: dataFontSize),
      ),
      const SizedBox(
        height: 10,
      ),
    ],
  );
}

Widget buildDetailItem(String title, String data) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: ColorsUI.headingColor
          ),
        ),
        Text(
          data,
          style: TextStyle(fontSize: 15, color: ColorsUI.headingColor.withOpacity(0.7)),
        ),
      ],
    ),
  );
}
