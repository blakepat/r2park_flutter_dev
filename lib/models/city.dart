// "zone_id": "106",
// "province_id": "1",
// "zone_title": "BR",
// "default_area": "GTA",
// "additional_area": "C-GTA,GTHA-DAY",
// "area_id": null,
// "country_code": "",
// "show_vehicle": "1",
// "description": "BRAMPTON",
// "update_at": "2023-10-26 14:04:54"

class City {
  String? zoneId;
  String? provinceId;
  String? zoneTitle;
  String? defaultArea;
  String? additionalArea;
  String? areaId;
  String? countryCode;
  String? showVehicle;
  String? description;
  String? updateAt;

  City(
      {this.zoneId,
      this.provinceId,
      this.zoneTitle,
      this.defaultArea,
      this.additionalArea,
      this.areaId,
      this.countryCode,
      this.showVehicle,
      this.description,
      this.updateAt});

  City.def() {
    zoneId = '';
    provinceId = '';
    zoneTitle = '';
    defaultArea = '';
    additionalArea = '';
    areaId = '';
    countryCode = '';
    showVehicle = '';
    description = '';
    updateAt = '';
  }

  factory City.convertFromJson(dynamic json) {
    final city = City.def();

    city.zoneId = json['zone_id'];
    city.provinceId = json['province_id'];
    city.zoneTitle = json['zone_title'];
    city.defaultArea = json['default_area'];
    city.additionalArea = json['additional_area'];
    city.areaId = json['area_id'];
    city.countryCode = json['country_code'];
    city.showVehicle = json['show_vehicle'];
    city.description = json['description'];
    city.updateAt = json['update_at'];

    return city;
  }
}
