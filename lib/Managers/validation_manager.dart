import 'package:email_validator/email_validator.dart';

bool isValidPlate(String licencePlate) {
  return RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(licencePlate) &&
      licencePlate.length < 10;
}

bool isValidLocationCityOrProvince(String location) {
  return RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(location);
}

String validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
  RegExp regExp = new RegExp(pattern);
  String errorMessage = '';

  if (value.length == 0) {
    errorMessage = 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    errorMessage = 'Please enter valid mobile number';
  }

  return errorMessage;
}

String validateName(String name) {
  String errorMessage = '';

  if (name.length < 3) {
    errorMessage += 'Name must be longer than 3 characters.\n';
  }
  if (name.contains(RegExp(r'[!@#%^&*(),$.?":{}|<>]'))) {
    errorMessage += '• name cannot include special characters.\n';
  }

  return errorMessage;
}

String validateEmail(String email) {
  String errorMessage = '';

  if (email.length < 3) {
    errorMessage += 'email must be longer than 3 characters.\n';
  }
  if (!email.contains('@')) {
    errorMessage += '• @ symbol is missing.\n';
  }
  if (!EmailValidator.validate(email)) {
    errorMessage += '• email is invalid\n';
  }

  return errorMessage;
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
