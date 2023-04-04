class Property {
  int? id;
  int? clientID;
  String? propertyName;
  String? propertyID;
  String? propertyType;
  String? allocatedEmployees;
  String? parkingSpace;
  String? propertyAddress;
  String? agreementImage;
  String? propertyImage;
  String? moreInformation;
  DateTime? createdAt;
  String? latitude;
  String? longitude;
  String? qrCode;
  int? status;
  String? country;
  String? province;
  String? area;
  String? zone;
  String? propertyID2;
  int? noUnites;
  int? numObs;
  String? timeRestrictions;
  String? siteDescription;
  String? workInstructions;
  int? isValtag;
  String? municipalTicketAddress;

  Property(
      {required this.id,
      this.clientID,
      this.propertyName,
      this.propertyID,
      this.propertyType,
      this.allocatedEmployees,
      this.parkingSpace,
      this.propertyAddress,
      this.agreementImage,
      this.propertyImage,
      this.moreInformation,
      this.createdAt,
      this.latitude,
      this.longitude,
      this.qrCode,
      this.status,
      this.country,
      this.province,
      this.area,
      this.zone,
      this.propertyID2,
      this.noUnites,
      this.numObs,
      this.timeRestrictions,
      this.siteDescription,
      this.workInstructions,
      this.isValtag,
      this.municipalTicketAddress});

  Property.def() {
    id = null;
    clientID = 0;
    propertyName = '';
    propertyID = '';
    propertyType = '';
    allocatedEmployees = '';
    parkingSpace = '';
    propertyAddress = '';
    agreementImage = '';
    propertyImage = '';
    moreInformation = '';
    createdAt = DateTime.now().toUtc();
    latitude = '';
    longitude = '';
    qrCode = '';
    status = 0;
    country = '';
    province = '';
    area = '';
    zone = '';
    propertyID = '';
    noUnites = 0;
    numObs = 0;
    timeRestrictions = '';
    siteDescription = '';
    workInstructions = '';
    isValtag = 0;
    municipalTicketAddress = '';
  }
}
