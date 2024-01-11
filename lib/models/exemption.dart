class Exemption {
  int? registryID;
  DateTime? regDate;
  String? plateID;
  String? propertyID;
  DateTime? startDate;
  DateTime? endDate;
  String? unitNumber;
  String? streetName;
  String? zoneID;
  String? email;
  String? phone;
  String? name;
  String? makeModel;
  String? numberOfDays;
  String? reason;
  String? notes;
  String? authBy;
  String? isArchived;
  String? streetNumber;
  String? streetSuffix;
  String? address;

  Exemption(
      {this.registryID,
      this.regDate,
      this.plateID,
      this.propertyID,
      this.startDate,
      this.endDate,
      this.unitNumber,
      this.streetName,
      this.zoneID,
      this.email,
      this.phone,
      this.name,
      this.makeModel,
      this.numberOfDays,
      this.reason,
      this.notes,
      this.authBy,
      this.isArchived,
      this.streetNumber,
      this.streetSuffix,
      this.address});

  Exemption.def() {
    registryID = null;
    regDate = DateTime.now().toUtc();
    plateID = '';
    propertyID = '';
    startDate = DateTime.now().toUtc();
    endDate = DateTime.now().toUtc();
    unitNumber = '';
    streetNumber = '';
    zoneID = '';
    email = '';
    phone = '';
    name = '';
    makeModel = '';
    numberOfDays = '';
    reason = '';
    notes = '';
    authBy = '';
    isArchived = '';
    streetNumber = '';
    streetSuffix = '';
    address = '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['Reg_Date'] = regDate.toString();
    data['fk_Plate_ID'] = plateID;
    data['fk_property_id'] = propertyID;
    data['Start_Date'] = startDate.toString();
    data['End_Date'] = endDate.toString();
    data['Unit_No'] = unitNumber;
    data['Street_Name'] = streetName;
    data['fk_Zone_ID'] = zoneID;
    data['email'] = email;
    data['Phone'] = phone;
    data['Name'] = name;
    data['Make_Model'] = makeModel;
    data['Days'] = numberOfDays;
    data['Reason'] = reason;
    data['Notes'] = notes;
    data['Auth_By'] = authBy;
    data['IsArchived'] = isArchived;
    data['street_number'] = streetNumber;
    data['street_suffix'] = streetSuffix;
    data['address'] = address;

    return data;
  }

  factory Exemption.convertFromJson(dynamic json) {
    final exemption = Exemption.def();

    exemption.registryID = json['Reg_Date'];
    exemption.plateID = json['fk_Plate_ID'];
    exemption.propertyID = json['fk_property_id'];
    exemption.startDate = json['Start_Date'];
    exemption.endDate = json['End_Date'];
    exemption.unitNumber = json['Unit_No'];
    exemption.streetName = json['Street_Name'];
    exemption.zoneID = json['fk_Zone_ID'];
    exemption.email = json['email'];
    exemption.phone = json['Phone'];
    exemption.name = json['Name'];
    exemption.makeModel = json['Make_Model'];
    exemption.numberOfDays = json['Days'];
    exemption.reason = json['Reason'];
    exemption.notes = json['Notes'];
    exemption.authBy = json['Auth_By'];
    exemption.isArchived = json['IsArchived'];
    exemption.streetNumber = json['street_number'];
    exemption.streetSuffix = json['street_suffix'];
    exemption.address = json['address'];

    return exemption;
  }
}
