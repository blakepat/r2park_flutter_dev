import 'dart:math';

class AccessCode {
  String? user_id;
  String? access_code;
  String? description;
  String? duration;
  String? expiry;
  String? created_at;
  String? last_increment;

  AccessCode(
      {required this.user_id,
      required this.access_code,
      required this.description,
      required this.duration,
      required this.expiry,
      required this.created_at,
      required this.last_increment});

  AccessCode.def() {
    user_id = '';
    access_code = '';
    description = '';
    duration = '';
    expiry = '';
    created_at = '';
    last_increment = '';
  }

  factory AccessCode.convertFromJson(dynamic json) {
    final accessCode = AccessCode.def();

    accessCode.user_id = json['user_id'];
    accessCode.access_code = json['access_code'];
    accessCode.description = json['description'];
    accessCode.duration = json['duration'];
    accessCode.expiry = json['expiry'];
    accessCode.created_at = json['created_at'];
    accessCode.last_increment = json['last_increment'];

    return accessCode;
  }
}
