class User {
  String? userId;
  String? userType;
  String? propertyId;
  String? email;
  String? fullName;
  String? mobileNumber;
  String? unitNumber;
  String? address;
  String? city;
  String? province;
  String? postalCode;
  String? companyAddress;
  String? companyId;
  String? password;

  User(
      {required this.userId,
      this.userType,
      this.propertyId,
      this.email,
      this.fullName,
      this.mobileNumber,
      this.unitNumber,
      this.address,
      this.city,
      this.province,
      this.postalCode,
      this.companyAddress,
      this.companyId,
      this.password});

  User.def() {
    userId = null;
    userType = "";
    propertyId = "";
    email = "";
    fullName = "";
    mobileNumber = "";
    unitNumber = "";
    address = "";
    city = "";
    province = "";
    postalCode = "";
    companyAddress = "";
    companyId = "";
    password = "";
  }

  factory User.convertFromJson(dynamic json) {
    final user = User.def();

    user.userId = json['user_id'];
    user.userType = json['user_type'];
    user.propertyId = json['property_id'];
    user.email = json['email'];
    user.fullName = json['full_name'];
    user.mobileNumber = json['mobile_number'];
    user.unitNumber = json['unit_number'];
    user.address = json['address'];
    user.city = json['city'];
    user.province = json['province'];
    user.postalCode = json['postal_code'];
    user.companyAddress = json['address_address'];
    user.companyId = json['company_id'];
    user.password = json['password'];

    return user;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['user_id'] = userId;
    data['user_type'] = userType;
    data['property_id'] = propertyId;
    data['email'] = email;
    data['full_name'] = fullName;
    data['mobile_number'] = mobileNumber;
    data['unit_number'] = unitNumber;
    data['address'] = address;
    data['city'] = city;
    data['province'] = province;
    data['postal_code'] = postalCode;
    data['company_address'] = companyAddress;
    data['company_id'] = companyId;
    data['password'] = password;

    return data;
  }
}
