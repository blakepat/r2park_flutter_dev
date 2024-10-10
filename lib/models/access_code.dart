class AccessCode {
  String? id;
  String? userId;
  String? accessCode;
  String? description;
  String? duration;
  String? expiry;
  String? status;
  String? email;
  String? name;
  String? createdAt;
  String? modifiedAt;
  String? lastIncrement;

  AccessCode(
      {this.id,
      this.userId,
      this.accessCode,
      this.description,
      this.duration,
      this.expiry,
      this.status,
      this.email,
      this.name,
      this.createdAt,
      this.modifiedAt,
      this.lastIncrement});

  AccessCode.def() {
    id = '';
    userId = '';
    accessCode = '';
    description = '';
    duration = '';
    expiry = '';
    status = '';
    email = '';
    name = '';
    createdAt = '';
    modifiedAt = '';
    lastIncrement = '';
  }

  factory AccessCode.convertFromJson(dynamic json) {
    final accessCode = AccessCode.def();

    accessCode.id = json['id'];
    accessCode.userId = json['user_id'];
    accessCode.accessCode = json['access_code'];
    accessCode.description = json['description'];
    accessCode.duration = json['duration'];
    accessCode.expiry = json['expiry'];
    accessCode.status = json['status'];
    accessCode.email = json['email'];
    accessCode.name = json['name'];
    accessCode.createdAt = json['created_at'];
    accessCode.modifiedAt = json['modified_at'];
    accessCode.lastIncrement = json['last_increment'];

    return accessCode;
  }
}
