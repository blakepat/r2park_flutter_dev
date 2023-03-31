import 'package:password/password.dart';

class User {
  int? id;
  String? prefix;
  String? firstName;
  String? lastName;
  String? initials;
  String? clientDisplayName;
  String? email;
  String? mobileNumber;
  int? authorityLevel;
  String? password;
  String? userImage;
  String? role;
  int? otp;
  int? status;
  int? enrollServices;
  String? companyName;
  String? companyAddress;
  String? comments;
  String? accessCode;
  String? plateNumber;
  String? state;
  DateTime? created;
  String? address1;
  String? address2;
  String? city;
  String? province;
  String? postalCode;
  String? fax;
  String? notes;
  String? clientId;
  int? employeeId;
  int? enforceID;
  String? workLocation;
  String? gender;
  DateTime? joiningDate;
  DateTime? dateOfBirth;
  String? address;
  int? salary;
  String? propertyType;
  String? property;
  String? jobType;
  String? about;
  String? paymentOptions;
  String? accessProperties;
  int? accessedByClient;
  int? isContact;
  int? accessedByProperty;
  int? allowDashboard;
  String? title;
  String? position;
  int? visibleAccess;
  String? country;
  String? area;
  String? zone;
  String? userId;
  String? propertyTypes;
  String? condoNumber;
  String? condoName;
  String? condoAddress;
  String? loginId;
  DateTime? memberSince;
  String? homePhone;
  String? businessPhone;
  String? email2;
  String? mailingAddress;
  String? signature;
  int? employeeRole;
  String? mleoId;
  int? defaultShow;
  int? signVendorId;
  String? multiZone;
  String? latitude;
  String? longitude;
  String? holidayRate;

  User(
      {required this.id,
      this.prefix,
      this.firstName,
      this.lastName,
      this.initials,
      this.clientDisplayName,
      this.email,
      this.mobileNumber,
      this.authorityLevel,
      this.password,
      this.userImage,
      this.role,
      this.otp,
      this.status,
      this.enrollServices,
      this.companyName,
      this.companyAddress,
      this.comments,
      this.accessCode,
      this.plateNumber,
      this.state,
      this.created,
      this.address1,
      this.address2,
      this.city,
      this.province,
      this.postalCode,
      this.fax,
      this.notes,
      this.clientId,
      this.employeeId,
      this.enforceID,
      this.workLocation,
      this.gender,
      this.joiningDate,
      this.dateOfBirth,
      this.address,
      this.salary,
      this.propertyType,
      this.property,
      this.jobType,
      this.about,
      this.paymentOptions,
      this.accessProperties,
      this.accessedByClient,
      this.isContact,
      this.accessedByProperty,
      this.allowDashboard,
      this.title,
      this.position,
      this.visibleAccess,
      this.country,
      this.area,
      this.zone,
      this.userId,
      this.propertyTypes,
      this.condoNumber,
      this.condoName,
      this.condoAddress,
      this.loginId,
      this.memberSince,
      this.homePhone,
      this.businessPhone,
      this.email2,
      this.mailingAddress,
      this.signature,
      this.employeeRole,
      this.mleoId,
      this.defaultShow,
      this.signVendorId,
      this.multiZone,
      this.latitude,
      this.longitude,
      this.holidayRate}) {
    // this.algorithm = new PBKDF2();
    // this.password = Password.hash(password, this.algorithm);
  }

  User.def() {
    this.id = null;
    this.prefix = '';
    this.firstName = '';
    this.lastName = '';
    this.initials = '';
    this.clientDisplayName = '';
    this.email = '';
    this.mobileNumber = '';
    this.authorityLevel = 12;
    this.password = '';
    this.userImage = 'uploads/profiles/user1.png';
    this.role = '';
    this.otp = 0;
    this.status = 1;
    this.enrollServices = 0;
    this.companyName = '';
    this.companyAddress = '';
    this.comments = '';
    this.accessCode = '';
    this.plateNumber = '';
    this.state = '';
    this.created = DateTime.now().toUtc();
    this.address1 = '';
    this.address2 = '';
    this.city = '';
    this.province = '';
    this.postalCode = '';
    this.fax = '';
    this.notes = '';
    this.clientId = '';
    this.employeeId = 0;
    this.enforceID = 0;
    this.workLocation = '';
    this.gender = '';
    this.joiningDate = DateTime.now().toUtc();
    this.dateOfBirth = DateTime.now().toUtc();
    this.address = '';
    this.salary = 0;
    this.propertyType = '';
    this.property = '';
    this.jobType = '';
    this.about = '';
    this.paymentOptions = '';
    this.accessProperties = '';
    this.accessedByClient = 0;
    this.isContact = 0;
    this.accessedByProperty = 0;
    this.allowDashboard = 0;
    this.title = '';
    this.position = '';
    this.visibleAccess = 0;
    this.country = '';
    this.area = '';
    this.zone = '';
    this.userId = '';
    this.propertyTypes = '';
    this.condoNumber = '';
    this.condoName = '';
    this.condoAddress = '';
    this.loginId = '';
    this.memberSince = DateTime.now().toUtc();
    this.homePhone = '';
    this.businessPhone = '';
    this.email2 = '';
    this.mailingAddress = '';
    this.signature = '';
    this.employeeRole = 0;
    this.mleoId = '';
    this.defaultShow = 0;
    this.signVendorId = 0;
    this.multiZone = '';
    this.latitude = '';
    this.longitude = '';
    this.holidayRate = '';
  }

  // passwordVerify(String password) {
  //   return Password.verify(password, this.password);
  // }
}
