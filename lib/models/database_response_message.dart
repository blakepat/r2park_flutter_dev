class DatabaseResponseMessage {
  int? status;
  String? message;
  String? description;

  DatabaseResponseMessage({this.status, this.message, this.description});

  DatabaseResponseMessage.def() {
    status = 0;
    message = '';
    description = '';
  }

  factory DatabaseResponseMessage.convertFromJson(dynamic json) {
    final responseMessage = DatabaseResponseMessage.def();

    responseMessage.status = json['status'];
    responseMessage.message = json['message'];
    responseMessage.description = json['description'];

    return responseMessage;
  }
}
