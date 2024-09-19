import 'dart:math';

class AccessCode {
  String? id;
  String? user_id;
  String? access_code;
  String? description;
  String? duration;
  String? expiry;
  String? status;
  String? email;
  String? name;
  String? created_at;
  String? modified_at;
  String? last_increment;

  AccessCode(
      { this.id,
       this.user_id,
       this.access_code,
       this.description,
       this.duration,
       this.expiry,
       this.status,
       this.email,
       this.name,
       this.created_at,
       this.modified_at,
       this.last_increment});

  AccessCode.def() {
    id = '';
    user_id = '';
    access_code = '';
    description = '';
    duration = '';
    expiry = '';
    status = '';
    email = '';
    name = '';
    created_at = '';
    modified_at = '';
    last_increment = '';
  }

  factory AccessCode.convertFromJson(dynamic json) {
    final accessCode = AccessCode.def();

    accessCode.id = json['id'];
    accessCode.user_id = json['user_id'];
    accessCode.access_code = json['access_code'];
    accessCode.description = json['description'];
    accessCode.duration = json['duration'];
    accessCode.expiry = json['expiry'];
    accessCode.status = json['status'];
    accessCode.email = json['email'];
    accessCode.name = json['name'];
    accessCode.created_at = json['created_at'];
    accessCode.modified_at = json['modified_at'];
    accessCode.last_increment = json['last_increment'];

    return accessCode;
  }


}
