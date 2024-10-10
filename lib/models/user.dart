class User {
  String? userId;
  String? registerAs;
  String? masterAccessCode;
  String? email;
  String? name;
  String? mobile;
  String? unitNumber;
  String? address1;
  String? city;
  String? province;
  String? postalCode;
  String? authLevel;
  String? status;
  String? password;

  User(
      {required this.userId,
      this.registerAs,
      this.masterAccessCode,
      this.email,
      this.name,
      this.mobile,
      this.unitNumber,
      this.address1,
      this.city,
      this.province,
      this.postalCode,
      this.authLevel,
      this.status,
      this.password});

  User.def() {
    userId = null;
    registerAs = "";
    masterAccessCode = "";
    email = "";
    name = "";
    mobile = "";
    unitNumber = "";
    address1 = "";
    city = "";
    province = "";
    postalCode = "";
    authLevel = "";
    status = "";
    password = "";
  }

  factory User.convertFromJson(dynamic json) {
    final user = User.def();

    user.userId = json['user_id'];
    user.registerAs = json['register_as'];
    user.masterAccessCode = json['master_access_code'];
    user.email = json['email'];
    user.name = json['name'];
    user.mobile = json['mobile'];
    user.unitNumber = json['unit_number'];
    user.address1 = json['address1'];
    user.city = json['city'];
    user.province = json['province'];
    user.postalCode = json['postal_code'];
    user.authLevel = json['auth_level'];
    user.status = json['status'];
    return user;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    // data['user_id'] = userId;
    data['register_as'] = registerAs;
    data['email'] = email;
    data['name'] = name;
    data['mobile'] = mobile;
    data['master_access_code'] = masterAccessCode;
    // data['unit_number'] = unitNumber;
    data['city'] = city;
    data['postal_code'] = postalCode;
    data['address1'] = address1;
    data['province'] = province;
    data['auth_level'] = authLevel;
    data['status'] = status;

    return data;
  }
}
