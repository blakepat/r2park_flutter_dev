class AccessCodeRequest {
  String userId;
  String description;
  String duration;
  String numberOfCodes;

  AccessCodeRequest(
      {required this.userId,
      required this.description,
      required this.duration,
      required this.numberOfCodes});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['user_id'] = userId;
    data['description'] = description;
    data['duration'] = duration;
    data['number_of_codes'] = numberOfCodes;

    return data;
  }
}
