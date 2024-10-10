class EmployeeRegistration {
  String? fullName;
  String? email;
  String? phone;
  String? accessCode;
  String? plateNumber;
  String? province;

  EmployeeRegistration(
      {this.email,
      this.fullName,
      this.phone,
      this.accessCode,
      this.plateNumber,
      this.province});

  EmployeeRegistration.def() {
    email = '';
    fullName = '';
    phone = '';
    accessCode = '';
    plateNumber = '';
    province = '';
  }

  factory EmployeeRegistration.convertFromJson(dynamic json) {
    final employeeRegistration = EmployeeRegistration.def();
    employeeRegistration.fullName = json['full_name'];
    employeeRegistration.email = json['email'];
    employeeRegistration.phone = json['phone'];
    employeeRegistration.accessCode = json['access_code'];
    employeeRegistration.plateNumber = json['plate_number'];
    employeeRegistration.province = json['province'];

    return employeeRegistration;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['full_name'] = fullName;
    data['email'] = email;
    data['phone'] = phone;
    data['access_code'] = accessCode;
    data['plate_number'] = plateNumber;
    data['province'] = province;

    return data;
  }
}
