class Registration {
  int? id;
  String? userType;
  String? name;
  String? email;
  String? phone;
  String? streetNumber;
  String? streetName;
  String? city;
  String? plateNumber;
  String? province;
  String? unitNumber;
  String? duration;
  DateTime? createdAt;

  Registration({
    this.id,
    this.userType,
    this.name,
    this.email,
    this.phone,
    this.streetNumber,
    this.streetName,
    this.city,
    this.plateNumber,
    this.province,
    this.unitNumber,
    this.duration,
    this.createdAt,
  });

  Registration.def() {
    id = null;
    userType = '';
    name = '';
    email = '';
    phone = '';
    streetNumber = '';
    streetName = '';
    city = '';
    plateNumber = '';
    province = '';
    unitNumber = '';
    duration = '';
    createdAt = DateTime.now().toUtc();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = '20';
    data['user_type'] = userType;
    data['full_name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['street_number'] = streetNumber;
    data['street_name'] = streetName;
    data['city'] = city;
    data['plate_number'] = plateNumber;
    data['province'] = province;
    data['unit_number'] = unitNumber;
    data['duration'] = duration;
    data['created_at'] = createdAt.toString();

    return data;
  }

  factory Registration.convertFromJson(dynamic json) {
    final exemption = Registration.def();

    // exemption.id = json['Reg_Date'];

    exemption.id = json['id'];
    exemption.userType = json['user_type'];
    exemption.name = json['full_name'];
    exemption.email = json['email'];
    exemption.phone = json['phone'];
    exemption.streetNumber = json['street_number'];
    exemption.streetName = json['street_name'];
    exemption.city = json['city'];
    exemption.plateNumber = json['plate_number'];
    exemption.province = json['province'];
    exemption.unitNumber = json['unit_number'];
    exemption.duration = json['duration'];
    exemption.createdAt = json['created_at'];

    return exemption;
  }
}
