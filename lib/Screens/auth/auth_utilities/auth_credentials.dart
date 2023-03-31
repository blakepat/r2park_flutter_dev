class AuthCredentials {
  // final String? firstName;
  // final String? lastName;
  // final String? phoneNumber;
  final String? email;
  final String? password;
  String? userId;

  AuthCredentials(
      {
      // this.firstName,
      // this.lastName,
      // this.phoneNumber,
      required this.email,
      this.password,
      this.userId});
}
