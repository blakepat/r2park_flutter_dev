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

  factory User.convertFromJson(dynamic json) {
    // print(json['user_id']);

    final user = User.def();

    user.id = int.parse(json['user_id']);
    print("🙃 ${user.id}");
    user.prefix = json['prefix'];
    user.firstName = json['name'];
    user.lastName = json['last_name'];
    user.initials = json['initials'];
    user.clientDisplayName = json['client_display_name'];
    user.email = json['email'];
    user.mobileNumber = json['mobile'];
    user.authorityLevel = int.parse(json['auth_level']);
    user.password = json['password'];
    user.userImage = json['user_image'];
    user.role = json['role'];
    user.otp = int.parse(json['otp']);
    user.status = int.parse(json['status']);
    user.enrollServices = int.parse(json['enrollServices']);
    user.companyName = json['companyName'];
    user.companyAddress = json['companyAddress'];
    user.comments = json['comments'];
    user.accessCode = json['accessCode'];
    user.plateNumber = json['plateNumber'];
    user.state = json['state'];
    user.created = DateTime.parse(json['created']);
    user.address1 = json['address1'];
    user.address2 = json['address2'];
    user.city = json['city'];
    user.province = json['province'];
    user.postalCode = json['postal_code'];
    user.fax = json['fax'];
    user.notes = json['notes'];
    user.clientId = json['clientID'];
    user.employeeId = int.parse(json['employeeId']);
    user.enforceID = int.parse(json['enforceId']);
    user.workLocation = json['work_location'];
    user.gender = json['gender'];
    user.joiningDate = DateTime.parse(json['joining_date']);
    user.dateOfBirth = DateTime.parse(json['date_of_birth']);
    user.address = json['address'];
    user.salary = int.parse(json['salary']);
    user.propertyType = json['property_type'];
    user.property = json['property'];
    user.jobType = json['job_type'];
    user.about = json['about'];
    user.paymentOptions = json['payment_options'];
    user.accessProperties = json['access_properties'];
    user.accessedByClient = int.parse(json['accessed_by_client']);
    user.isContact = int.parse(json['is_contact']);
    user.accessedByProperty = int.parse(json['accessed_by_property']);
    user.allowDashboard = int.parse(json['allow_dashboard']);
    user.title = json['title'];
    user.position = json['position'];
    user.visibleAccess = int.parse(json['visible_access']);
    user.country = json['country'];
    user.area = json['area'];
    user.zone = json['zone'];
    user.userId = json['userId'];
    user.propertyTypes = json['property_types'];
    user.condoNumber = json['condo_number'];
    user.condoName = json['condo_name'];
    user.condoAddress = json['condo_addr'];
    user.loginId = json['login_id'];
    user.memberSince = DateTime.parse(json['member_since']);
    user.homePhone = json['home_phone'];
    user.businessPhone = json['business_phone'];
    user.email2 = json['email2'];
    user.mailingAddress = json['mailing_address'];
    user.signature = json['signature'];
    user.employeeRole = int.parse(json['employee_role']);
    user.mleoId = json['mleo_id'];
    user.defaultShow = int.parse(json['default_show']);
    user.signVendorId = int.parse(json['signvendorId']);
    user.multiZone = json['multi_zone'];
    user.latitude = json['latitude'];
    user.longitude = json['longitude'];
    user.holidayRate = json['holiday_rate'];

    return user;
  }

  User.fromJson(Map<String?, dynamic> json) {
    id = json['user_id'] as int?;
    prefix = json['prefix'];
    firstName = json['name'];
    lastName = json['last_name'];
    initials = json['initials'];
    clientDisplayName = json['client_display_name'];
    email = json['email'];
    mobileNumber = json['mobile'];
    authorityLevel = json['auth_level'] as int?;
    password = json['password'];
    userImage = json['user_image'];
    role = json['role'];
    otp = json['otp'] as int?;
    status = json['status'] as int?;
    enrollServices = json['enrollServices'] as int?;
    companyName = json['companyName'];
    companyAddress = json['companyAddress'];
    comments = json['comments'];
    accessCode = json['accessCode'];
    plateNumber = json['plateNumber'];
    state = json['state'];
    created = json['created'] as DateTime?;
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    province = json['province'];
    postalCode = json['postal_code'];
    fax = json['fax'];
    notes = json['notes'];
    clientId = json['clientID'];
    employeeId = json['employeeId'] as int?;
    enforceID = json['enforceId'] as int?;
    workLocation = json['work_location'];
    gender = json['gender'];
    joiningDate = json['joining_date'] as DateTime?;
    dateOfBirth = json['date_of_birth'] as DateTime?;
    address = json['address'];
    salary = json['salary'] as int?;
    propertyType = json['property_type'];
    property = json['property'];
    jobType = json['job_type'];
    about = json['about'];
    paymentOptions = json['payment_options'];
    accessProperties = json['access_properties'];
    accessedByClient = json['accessed_by_client'] as int?;
    isContact = json['is_contact'] as int?;
    accessedByProperty = json['accessed_by_property'] as int?;
    allowDashboard = json['allow_dashboard'] as int?;
    title = json['title'];
    position = json['position'];
    visibleAccess = json['visible_access'] as int?;
    country = json['country'];
    area = json['area'];
    zone = json['zone'];
    userId = json['userId'];
    propertyTypes = json['property_types'];
    condoNumber = json['condo_number'];
    condoName = json['condo_name'];
    condoAddress = json['condo_addr'];
    loginId = json['login_id'];
    memberSince = json['member_since'] as DateTime?;
    homePhone = json['home_phone'];
    businessPhone = json['business_phone'];
    email2 = json['email2'];
    mailingAddress = json['mailing_address'];
    signature = json['signature'];
    employeeRole = json['employee_role'] as int?;
    mleoId = json['mleo_id'];
    defaultShow = json['default_show'] as int?;
    signVendorId = json['signvendorId'] as int?;
    multiZone = json['multi_zone'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    holidayRate = json['holiday_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.id;
    data['prefix'] = this.prefix;
    data['name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['initials'] = this.initials;
    data['client_display_name'] = this.clientDisplayName;
    data['email'] = this.email;
    data['mobile'] = this.mobileNumber;
    data['auth_level'] = this.authorityLevel;
    data['password'] = this.password;
    data['user_image'] = this.userImage;
    data['role'] = this.role;
    data['otp'] = this.otp;
    data['status'] = this.status;
    data['enrollServices'] = this.enrollServices;
    data['companyName'] = this.companyName;
    data['companyAddress'] = this.companyAddress;
    data['comments'] = this.comments;
    data['accessCode'] = this.accessCode;
    data['plateNumber'] = this.plateNumber;
    data['state'] = this.state;
    data['created'] = this.created;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['province'] = this.province;
    data['postal_code'] = this.postalCode;
    data['fax'] = this.fax;
    data['notes'] = this.notes;
    data['clientID'] = this.clientId;
    data['employeeId'] = this.employeeId;
    data['enforceId'] = this.enforceID;
    data['work_location'] = this.workLocation;
    data['gender'] = this.gender;
    data['joining_date'] = this.joiningDate;
    data['date_of_birth'] = this.dateOfBirth;
    data['address'] = this.address;
    data['salary'] = this.salary;
    data['property_type'] = this.propertyType;
    data['property'] = this.property;
    data['job_type'] = this.jobType;
    data['about'] = this.about;
    data['payment_options'] = this.paymentOptions;
    data['access_properties'] = this.accessProperties;
    data['accessed_by_client'] = this.accessedByClient;
    data['is_contact'] = this.isContact;
    data['accessed_by_property'] = this.accessedByProperty;
    data['allow_dashboard'] = this.allowDashboard;
    data['title'] = this.title;
    data['position'] = this.position;
    data['visible_access'] = this.visibleAccess;
    data['country'] = this.country;
    data['area'] = this.area;
    data['zone'] = this.zone;
    data['userId'] = this.userId;
    data['property_types'] = this.propertyTypes;
    data['condo_number'] = this.condoNumber;
    data['condo_name'] = this.condoName;
    data['condo_addr'] = this.condoAddress;
    data['login_id'] = this.loginId;
    data['member_since'] = this.memberSince;
    data['home_phone'] = this.homePhone;
    data['business_phone'] = this.businessPhone;
    data['email2'] = this.email2;
    data['mailing_address'] = this.mailingAddress;
    data['signature'] = this.signature;
    data['employee_role'] = this.employeeRole;
    data['mleo_id'] = this.mleoId;
    data['default_show'] = this.defaultShow;
    data['signvendorId'] = this.signVendorId;
    data['multi_zone'] = this.multiZone;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['holiday_rate'] = this.holidayRate;
    return data;
  }
}
