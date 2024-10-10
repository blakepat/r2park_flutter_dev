class RegistrationListItem {
  String? id;
  String? regDate;
  String? masterAccessCode;
  String? employeeAccessCode;
  String? fkPlateId;
  String? prov;
  String? fkLocationId;
  String? startDate;
  String? endDate;

  RegistrationListItem(
      {required this.id,
      this.regDate = "",
      this.masterAccessCode = "",
      this.employeeAccessCode = "",
      this.fkPlateId = "",
      this.prov = "",
      this.fkLocationId = "",
      this.startDate = "",
      this.endDate = ""});

  RegistrationListItem.def() {
    id = "";
    regDate = "";
    masterAccessCode = "";
    employeeAccessCode = "";
    fkPlateId = "";
    prov = "";
    fkLocationId = "";
    startDate = "";
    endDate = "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['Registry_ID'] = id;
    data['Reg_Date'] = regDate;
    data['master_access_code'] = masterAccessCode;
    data['employee_access_code'] = employeeAccessCode;
    data['fk_plate_ID'] = fkPlateId;
    data['fk_location_ID'] = fkLocationId;
    data['prov'] = prov;
    data['Start_Date'] = startDate;
    data['End_Date'] = endDate;

    return data;
  }

  factory RegistrationListItem.convertFromJson(dynamic json) {
    final exemption = RegistrationListItem.def();

    exemption.id = json['Registry_ID'];
    exemption.regDate = json['Reg_Date'];
    exemption.masterAccessCode = json['master_access_code'];
    exemption.employeeAccessCode = json['employee_access_code'];
    exemption.fkPlateId = json['fk_plate_ID'];
    exemption.fkLocationId = json['fk_location_ID'];
    exemption.prov = json['prov'];
    exemption.startDate = json['Start_Date'];
    exemption.endDate = json['End_Date'];

    return exemption;
  }
}
