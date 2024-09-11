class EmployeeRegistration {
  String? full_name;
  String? email;
  String? phone;
  String? access_code;
  String? plate_number;
  String? province;

  EmployeeRegistration(
      {this.email,
      this.full_name,
      this.phone,
      this.access_code,
      this.plate_number,
      this.province});

  EmployeeRegistration.def() {
    email = '';
    full_name = '';
    phone = '';
    access_code = '';
    plate_number = '';
    province = '';
  }

  factory EmployeeRegistration.convertFromJson(dynamic json) {
    final employeeRegistration = EmployeeRegistration.def();
    employeeRegistration.full_name = json['full_name'];
    employeeRegistration.email = json['email'];
    employeeRegistration.phone = json['phone'];
    employeeRegistration.access_code = json['access_code'];
    employeeRegistration.plate_number = json['plate_number'];
    employeeRegistration.province = json['province'];

    return employeeRegistration;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['full_name'] = full_name;
    data['email'] = email;
    data['phone'] = phone;
    data['access_code'] = access_code;
    data['plate_number'] = plate_number;
    data['province'] = province;

    return data;
  }
}
