class LoginUser {
  String? email;
  String? password;


  LoginUser({
    this.email,
    this.password,
 
  });

  LoginUser.def() {
    email = '';
    password = '';

  }

  factory LoginUser.convertFromJson(dynamic json) {
    final acProperty = LoginUser.def();
    acProperty.email = json['email'];
    acProperty.password = json['password'];

    return acProperty;
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['email'] = email;
    data['password'] = password;

    return data;
  }
}