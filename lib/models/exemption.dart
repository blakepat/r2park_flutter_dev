class Exemption {
  int? id;
  int? municipalId;
  String? name;
  String? email;
  String? phone;
  String? streetNumber;
  String? streetName;
  String? streetExemption;
  String? streetNameExemption;
  String? reason;
  String? municipality;
  DateTime? startDate;
  DateTime? timeExemption;
  String? plateNumber;
  String? province;
  String? vehicleType;
  int? requestedDays;
  DateTime? endDate;
  DateTime? created;

  Exemption(
      {required this.id,
      this.municipalId,
      this.name,
      this.email,
      this.phone,
      this.streetNumber,
      this.streetName,
      this.streetExemption,
      this.streetNameExemption,
      this.reason,
      this.municipality,
      this.startDate,
      this.timeExemption,
      this.plateNumber,
      this.province,
      this.vehicleType,
      this.requestedDays,
      this.endDate,
      this.created});

  Exemption.def() {
    id = null;
    municipalId = 0;
    streetName = '';
    email = '';
    phone = '';
    streetNumber = '';
    streetName = '';
    streetExemption = '';
    streetNameExemption = '';
    reason = '';
    municipality = '';
    startDate = DateTime.now().toUtc();
    timeExemption = DateTime.now().toUtc();
    plateNumber = '';
    province = '';
    vehicleType = '';
    requestedDays = 0;
    endDate = DateTime.now().toUtc();
    created = DateTime.now().toUtc();
  }
}
