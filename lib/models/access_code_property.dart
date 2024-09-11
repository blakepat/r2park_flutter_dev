class AccessCodeProperty {
  String? property_id;
  String? property_name;
  String? property_type;
  String? property_address;
  String? province;
  String? zone;

  AccessCodeProperty({
    this.property_id,
    this.property_name,
    this.property_type,
    this.property_address,
    this.province,
    this.zone,
  });

  AccessCodeProperty.def() {
    property_id = '';
    property_name = '';
    property_type = '';
    property_address = '';
    province = '';
    zone = '';
  }

  factory AccessCodeProperty.convertFromJson(dynamic json) {
    final acProperty = AccessCodeProperty.def();
    acProperty.property_id = json['property_id'];
    acProperty.property_name = json['property_name'];
    acProperty.property_type = json['property_type'];
    acProperty.property_address = json['property_address'];
    acProperty.province = json['province'];
    acProperty.zone = json['zone'];

    return acProperty;
  }
}
