class StreetAddress {
  String? streetAddress;

  StreetAddress({this.streetAddress});

  StreetAddress.def() {
    streetAddress = '';
  }

  factory StreetAddress.convertFromJson(dynamic json) {
    final streetAddress = StreetAddress.def();
    streetAddress.streetAddress = json['street_address'];

    return streetAddress;
  }
}
