import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  // Future<String> _getUserIdFromAttributes() async {
  //   // try {
  //   //   final user = await Amplify.Auth.getCurrentUser();
  //   //   return user.userId;
  //   // } catch (e) {
  //   //   print(e);
  //   //   throw e;
  //   // }
  //   return '';
  // }

  Future<String?> attemptAutoLogin() async {
    // print('✅ AttemptAutoLogin called from AuthRepo');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  Future<String?> login() async {
    //   {required String email, required String password}) async {
    // // signOut();
    // try {
    //   final result = await Amplify.Auth.signIn(
    //       username: email.trim(), password: password.trim());
    //   print(result.isSignedIn);
    //   return result.isSignedIn ? (await _getUserIdFromAttributes()) : null;
    // } catch (e) {
    //   print('error in auth repo login: $e');
    //   throw e;
    // }
    return '';
  }

  Future<bool> signUp() async {
    //   {required String email,
    //   required String password,
    //   required String firstName,
    //   required String lastName,
    //   required String phoneNumber}) async {
    // final userAttributes = <CognitoUserAttributeKey, String>{
    //   CognitoUserAttributeKey.email: email,
    //   CognitoUserAttributeKey.givenName: firstName,
    //   CognitoUserAttributeKey.familyName: lastName,
    //   CognitoUserAttributeKey.phoneNumber: phoneNumber
    // };

    // final options = CognitoSignUpOptions(userAttributes: userAttributes);
    // try {
    //   final result = await Amplify.Auth.signUp(
    //       username: email.trim(), password: password.trim(), options: options);
    //   return result.isSignUpComplete;
    // } catch (e) {
    //   print('error in auth repo signup: $e');
    //   throw e;
    // }
    return true;
  }

  // Future<bool> confirmSignUp({
  //   required String email,
  //   required String confirmationCode,
  // }) async {
  //   try {
  //     final result = await Amplify.Auth.confirmSignUp(
  //       username: email.trim(),
  //       confirmationCode: confirmationCode.trim(),
  //     );
  //     return result.isSignUpComplete;
  //   } catch (e) {
  //     print('error confirming signup: $e');
  //     throw e;
  //   }
  // }

  // Future<void> resendCode({required String email}) async {
  //   try {
  //     await Amplify.Auth.resendSignUpCode(username: email.trim());
  //   } catch (e) {
  //     print('error resending confirmation code');
  //     throw e;
  //   }
  // }

  Future<void> signOut() async {
    // await Amplify.Auth.signOut();
  }
}
