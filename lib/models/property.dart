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

  factory Property.convertFromJson(dynamic json) {
    final property = Property.def();

    property.id = int.parse(json['id']);
    property.clientID = int.parse(json['client_id']);
    property.propertyName = json['property_name'];
    property.propertyID = json['property_id'];
    property.propertyType = json['property_type'];
    property.allocatedEmployees = json['allocated_employees'];
    property.parkingSpace = json['parking_space'];
    property.propertyAddress = json['property_address'];
    property.agreementImage = json['aggrement_image'];
    property.propertyImage = json['property_image'];
    property.moreInformation = json['more_inforamation'];
    property.createdAt = DateTime.parse(json['created_at']);
    property.latitude = json['latitude'];
    property.longitude = json['longitude'];
    property.qrCode = json['qrcode'];
    property.status = int.parse(json['status']);
    property.country = json['country'];
    property.province = json['province'];
    property.area = json['area'];
    property.zone = json['zone'];
    property.propertyID2 = json['propertyID'];
    property.noUnites = int.parse(json['no_unites']);
    property.numObs = int.parse(json['num_obs']);
    property.timeRestrictions = json['time_restrictions'];
    property.siteDescription = json['site_description'];
    property.workInstructions = json['work_instructions'];
    property.isValtag = int.parse(json['is_valtag']);
    property.municipalTicketAddress = json['municipal_ticket_address'];

    return property;
  }
}
