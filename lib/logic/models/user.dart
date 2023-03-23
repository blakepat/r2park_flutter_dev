import 'package:password/password.dart';

class User {
  int? id;
  String? firstName;
  String? lastName;
  // String initials;
  // String clientDisplayName;
  String? email;
  String? mobileNumber;
  String? hash;
  // String AuthorityLevel;
  // String user_image;
  // String companyName;
  // String companyAddress;
  // String comments;
  // String accessCode;
  String? plateNumber;
  // String created;
  String? address1;
  String? address2;
  String? city;
  String? province;
  String? state;
  String? postalCode;
  // String fax;
  // String notes;
  // String employeeId;
  // String enforceID;
  // String workLocation;
  // String gender;
  // String joiningDate;
  // String dateOfBirth;
  // String address;
  // String salary;
  // String propertyType;
  // String property;
  // String jobType;
  // String about;
  // etcc.....

  PBKDF2? algorithm;

  User(
      this.firstName,
      this.lastName,
      this.email,
      this.mobileNumber,
      this.address1,
      this.address2,
      this.city,
      this.province,
      this.state,
      this.postalCode,
      this.plateNumber,
      String password,
      {required this.id}) {
    this.algorithm = new PBKDF2();
    this.hash = Password.hash(password, this.algorithm);
  }

  User.def() {
    id = null;
    firstName = '';
    lastName = '';
    email = '';
    hash = '';
    mobileNumber = '';
    address1 = '';
    address2 = '';
    city = '';
    province = '';
    state = '';
    plateNumber = '';
    algorithm = new PBKDF2();
  }

  passwordVerify(String password) {
    return Password.verify(password, this.hash);
  }

  //
}
