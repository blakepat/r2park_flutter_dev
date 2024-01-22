import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

bool isNullOrEmpty(String? str) {
  if (str != null) {
    if (str.isEmpty || str == '') return true;
    return false;
  }
  return true;
}

void openDialog(BuildContext context, String dialogTitle, stringContent,
    String dialogContent) {
  showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: Text(dialogTitle),
          content: Text(dialogContent),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Back'))
          ],
        );
      }));
}

bool isValidPlate(String licencePlate) {
  return RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(licencePlate) &&
      licencePlate.length < 10;
}

bool isValidLocationCityOrProvince(String location) {
  return RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(location);
}

bool isValidProvince(String province) {
  return (province == "AB" ||
      province == "BC" ||
      province == "MB" ||
      province == "NB" ||
      province == "NL" ||
      province == "NT" ||
      province == "NS" ||
      province == "NU" ||
      province == "ON" ||
      province == "PE" ||
      province == "QC" ||
      province == "SK" ||
      province == "YT");
}

String validatePassword(String password) {
  // Reset error message
  String errorMessage = '';
  // Password length greater than 6
  if (password.length < 6) {
    errorMessage += 'Password must be longer than 6 characters.\n';
  }
  // Password length less than 26
  if (password.length > 25) {
    errorMessage += 'Password cannot be longer than 25 characters.\n';
  }
  // Contains at least one uppercase letter
  if (!password.contains(RegExp(r'[A-Z]'))) {
    errorMessage += '• Uppercase letter is missing.\n';
  }
  // Contains at least one lowercase letter
  if (!password.contains(RegExp(r'[a-z]'))) {
    errorMessage += '• Lowercase letter is missing.\n';
  }
  // Contains at least one digit
  if (!password.contains(RegExp(r'[0-9]'))) {
    errorMessage += '• Digit is missing.\n';
  }
  // Contains at least one special character
  if (!password.contains(RegExp(r'[!@#%^&*(),$.?":{}|<>]'))) {
    errorMessage += '• Special character is missing.\n';
  }
  // If there are no error messages, the password is valid
  return errorMessage;
}
