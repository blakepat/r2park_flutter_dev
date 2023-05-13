class SelfRegistration {
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

  SelfRegistration(
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

  SelfRegistration.def() {
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
}
