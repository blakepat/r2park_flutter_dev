class AccessCodeRequest {
  String user_id;
  String description;
  String duration;
  String number_of_codes;

  AccessCodeRequest(
      {required this.user_id,
      required this.description,
      required this.duration,
      required this.number_of_codes});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['user_id'] = user_id;
    data['description'] = description;
    data['duration'] = duration;
    data['number_of_codes'] = number_of_codes;

    return data;
  }
}
