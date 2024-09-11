class User {
  String? userId;
  String? register_as;
  String? master_access_code;
  String? email;
  String? name;
  String? mobile;
  String? unitNumber;
  String? address1;
  String? city;
  String? province;
  String? postalCode;
  String? auth_level;
  String? status;
  String? password;

  User(
      {required this.userId,
      this.register_as,
      this.master_access_code,
      this.email,
      this.name,
      this.mobile,
      this.unitNumber,
      this.address1,
      this.city,
      this.province,
      this.postalCode,
      this.auth_level,
      this.status,
      this.password});

  User.def() {
    userId = null;
    register_as = "";
    master_access_code = "";
    email = "";
    name = "";
    mobile = "";
    unitNumber = "";
    address1 = "";
    city = "";
    province = "";
    postalCode = "";
    auth_level = "";
    status = "";
    password = "";
  }

  factory User.convertFromJson(dynamic json) {
    final user = User.def();

    // user.userId = json['user_id'];
    user.register_as = json['register_as'];
    user.master_access_code = json['master_access_code'];
    user.email = json['email'];
    user.name = json['name'];
    user.mobile = json['mobile'];
    // user.unitNumber = json['unit_number'];
    user.address1 = json['address1'];
    user.city = json['city'];
    user.province = json['province'];
    user.postalCode = json['postal_code'];
    user.auth_level = json['auth_level'];
    user.status = json['status'];
    return user;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    // data['user_id'] = userId;
    data['register_as'] = register_as;
    data['email'] = email;
    data['name'] = name;
    data['mobile'] = mobile;
    data['master_access_code'] = master_access_code;
    // data['unit_number'] = unitNumber;
    data['city'] = city;
    data['postal_code'] = postalCode;
    data['address1'] = address1;
    data['province'] = province;
    data['auth_level'] = auth_level;
    data['status'] = status;

    return data;
  }
}
