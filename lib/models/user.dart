
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
    id = null;
    prefix = '';
    firstName = '';
    lastName = '';
    initials = '';
    clientDisplayName = '';
    email = '';
    mobileNumber = '';
    authorityLevel = 12;
    password = '';
    userImage = 'uploads/profiles/user1.png';
    role = '';
    otp = 0;
    status = 1;
    enrollServices = 0;
    companyName = '';
    companyAddress = '';
    comments = '';
    accessCode = '';
    plateNumber = '';
    state = '';
    created = DateTime.now().toUtc();
    address1 = '';
    address2 = '';
    city = '';
    province = '';
    postalCode = '';
    fax = '';
    notes = '';
    clientId = '';
    employeeId = 0;
    enforceID = 0;
    workLocation = '';
    gender = '';
    joiningDate = DateTime.now().toUtc();
    dateOfBirth = DateTime.now().toUtc();
    address = '';
    salary = 0;
    propertyType = '';
    property = '';
    jobType = '';
    about = '';
    paymentOptions = '';
    accessProperties = '';
    accessedByClient = 0;
    isContact = 0;
    accessedByProperty = 0;
    allowDashboard = 0;
    title = '';
    position = '';
    visibleAccess = 0;
    country = '';
    area = '';
    zone = '';
    userId = '';
    propertyTypes = '';
    condoNumber = '';
    condoName = '';
    condoAddress = '';
    loginId = '';
    memberSince = DateTime.now().toUtc();
    homePhone = '';
    businessPhone = '';
    email2 = '';
    mailingAddress = '';
    signature = '';
    employeeRole = 0;
    mleoId = '';
    defaultShow = 0;
    signVendorId = 0;
    multiZone = '';
    latitude = '';
    longitude = '';
    holidayRate = '';
  }

  // passwordVerify(String password) {
  //   return Password.verify(password, this.password);
  // }
}
