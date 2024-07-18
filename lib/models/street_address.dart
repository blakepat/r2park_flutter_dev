class StreetAddress {
  String? street_address;

  StreetAddress({this.street_address});

  StreetAddress.def() {
    street_address = '';
  }

  factory StreetAddress.convertFromJson(dynamic json) {
    final streetAddress = StreetAddress.def();
    streetAddress.street_address = json['street_address'];

    return streetAddress;
  }
}
