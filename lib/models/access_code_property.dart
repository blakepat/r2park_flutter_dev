class AccessCodeProperty {
  String? propertyId;
  String? propertyName;
  String? propertyType;
  String? propertyAddress;
  String? province;
  String? zone;

  AccessCodeProperty({
    this.propertyId,
    this.propertyName,
    this.propertyType,
    this.propertyAddress,
    this.province,
    this.zone,
  });

  AccessCodeProperty.def() {
    propertyId = '';
    propertyName = '';
    propertyType = '';
    propertyAddress = '';
    province = '';
    zone = '';
  }

  factory AccessCodeProperty.convertFromJson(dynamic json) {
    final acProperty = AccessCodeProperty.def();
    acProperty.propertyId = json['property_id'];
    acProperty.propertyName = json['property_name'];
    acProperty.propertyType = json['property_type'];
    acProperty.propertyAddress = json['property_address'];
    acProperty.province = json['province'];
    acProperty.zone = json['zone'];

    return acProperty;
  }
}
