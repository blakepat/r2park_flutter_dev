class RegistrationListItem {
  String? id;
  String? reg_date;
  String? master_access_code;
  String? employee_access_code;
  String? fk_plate_id;
  String? prov;
  String? fk_location_id;
  String? start_date;
  String? end_date;

  RegistrationListItem(
      {this.id,
      this.reg_date = "",
      this.master_access_code = "",
      this.employee_access_code = "",
      this.fk_plate_id = "",
      this.prov = "",
      this.fk_location_id = "",
      this.start_date = "",
      this.end_date = ""});

  RegistrationListItem.def() {
    id = null;
    reg_date = "";
    master_access_code = "";
    employee_access_code = "";
    fk_plate_id = "";
    prov = "";
    fk_location_id = "";
    start_date = "";
    end_date = "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['Registry_ID'] = id;
    data['Reg_Date'] = reg_date;
    data['master_access_code'] = master_access_code;
    data['employee_access_code'] = employee_access_code;
    data['fk_plate_ID'] = fk_plate_id;
    data['fk_location_ID'] = fk_location_id;
    data['prov'] = prov;
    data['Start_Date'] = start_date;
    data['End_Date'] = end_date;

    return data;
  }

  factory RegistrationListItem.convertFromJson(dynamic json) {
    final exemption = RegistrationListItem.def();

    exemption.id = json['Registry_ID'];
    exemption.reg_date = json['Reg_Date'];
    exemption.master_access_code = json['master_access_code'];
    exemption.employee_access_code = json['employee_access_code'];
    exemption.fk_plate_id = json['fk_plate_ID'];
    exemption.fk_location_id = json['fk_location_ID'];
    exemption.prov = json['prov'];
    exemption.start_date = json['Start_Date'];
    exemption.end_date = json['End_Date'];

    return exemption;
  }
}
