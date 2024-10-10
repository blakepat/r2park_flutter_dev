import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:r2park_flutter_dev/models/access_code.dart';
import 'package:r2park_flutter_dev/models/access_code_property.dart';
import 'package:r2park_flutter_dev/models/access_code_request.dart';
import 'package:r2park_flutter_dev/models/city.dart';
import 'package:r2park_flutter_dev/models/database_response_message.dart';
import 'package:r2park_flutter_dev/models/employee_registration.dart';
import 'package:r2park_flutter_dev/models/login_user.dart';
import 'package:r2park_flutter_dev/models/property.dart';
import 'package:r2park_flutter_dev/models/registration.dart';
import 'package:r2park_flutter_dev/models/registration_list_item.dart';
import 'package:r2park_flutter_dev/models/role.dart';
import 'package:r2park_flutter_dev/models/street_address.dart';
import 'package:r2park_flutter_dev/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DatabaseManager {
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  var baseUrl = 'dev.r2p.live';

  //GET CITIES FOR INITIAL
  Future<List<City>> getCities() async {
    List<City> cities = [];

    var url = Uri.https(baseUrl, '/services/cities');
    var response = await http.get(url);
    final data = await json.decode(response.body);
    List jsonCities = data['data'];

    cities = jsonCities.map((entry) => City.convertFromJson(entry)).toList();

    var placeholderCity = City.def();
    placeholderCity.description = 'Choose a City';

    cities.insert(0, placeholderCity);

    return cities;
  }

  //GET ADDRESSES AFTER CITY SELECTION FOR INITIAL PAGE
  Future<List<String>> getAddressesForCity(String city) async {
    List<StreetAddress> addresses = [];

    var url = Uri.https(baseUrl, '/services/public_street/$city');
    var response = await http.get(url);
    final data = await json.decode(response.body);
    List jsonStreetAddresses = data['data'];

    addresses = jsonStreetAddresses
        .map((entry) => StreetAddress.convertFromJson(entry))
        .toList();
    final List<String> streetAddress =
        addresses.map((address) => address.street_address ?? '').toList();

    return streetAddress;
  }

  //GET ROLES FOR SIGNUP PAGE
  Future<List<Role>> getRoles() async {
    List<Role> roles = [];

    var url = Uri.https(baseUrl, '/services/contact_roles');
    var response = await http.get(url);
    final data = await json.decode(response.body);
    List jsonRoles = data['data'];

    roles = jsonRoles.map((entry) => Role.convertFromJson(entry)).toList();

    var placeholderCity = Role.def();
    placeholderCity.name = 'Choose a Role';

    roles.insert(0, placeholderCity);

    return roles;
  }

  //ACCESS CODE METHODS *****************************************
  //*********************************************************** */

  //GET ACCESS CODES
  Future<List<AccessCode>> getAccessCodes(String userId) async {
    List<AccessCode> accessCodes = [];
    final Map<String, dynamic> userIdData = <String, dynamic>{};
    userIdData['user_id'] = userId;

    var url = Uri.https(baseUrl, '/services/GetAccessCodes/');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userIdData));

    final data = await json.decode(response.body);
    List accessCodesJSON = data["access_codes"];

    accessCodes = accessCodesJSON
        .map((entry) => AccessCode.convertFromJson(entry))
        .toList();

    return accessCodes;
  }

  //GENERATE ACCESS CODES
  Future<String> generateAccessCodes(
      AccessCodeRequest accessCodeRequest) async {
    final jsonRequest = accessCodeRequest.toJson();
    var url = Uri.https(baseUrl, '/services/GenrateAccessCode/');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonRequest),
    );

    final data = await json.decode(response.body);
    final responseString = data['message'];

    print("DATA: $data");

    return responseString;
  }

  //ACTIVATE ACCESS CODE
  Future<void> activateAccessCode(String accessCode, String userId) async {
    final Map<String, dynamic> accessCodeData = <String, dynamic>{};

    accessCodeData['access_code'] = accessCode;
    accessCodeData['user_id'] = userId;

    var url = Uri.https(baseUrl, '/services/AccessCodeStatus');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(accessCodeData),
    );

    final data = await json.decode(response.body);
    final responseString = data['message'];
    print(responseString);
  }

  //EDIT ACCESS CODE
  Future<void> editAccessCode(
      {required String accessCode,
      required String userId,
      required String description,
      required String duration,
      required String id}) async {
    final Map<String, dynamic> accessCodeData = <String, dynamic>{};

    accessCodeData['access_code'] = accessCode;
    accessCodeData['user_id'] = userId;
    accessCodeData['description'] = description;
    accessCodeData['duration'] = duration;
    accessCodeData['id'] = id;

    print(accessCodeData);

    var url = Uri.https(baseUrl, '/services/EditAccessCode');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(accessCodeData),
    );

    final data = await json.decode(response.body);
    final responseString = data['message'];
    print(responseString);
  }

  //ASSIGN ACCESS CODE
  Future<void> assignAccessCode(
      String accessCode, String userId, String email, String name) async {
    final Map<String, dynamic> accessCodeData = <String, dynamic>{};

    accessCodeData['access_code'] = accessCode;
    accessCodeData['user_id'] = userId;
    accessCodeData['email'] = email;
    accessCodeData['name'] = name;

    print(accessCodeData);

    var url = Uri.https(baseUrl, '/services/AssignAccessCode');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(accessCodeData),
    );

    final data = await json.decode(response.body);
    print(response.body);
    final responseString = data['message'];
    print(responseString);
  }

  Future<AccessCodeProperty?> checkAccessCode(String code) async {
    AccessCodeProperty? accessCodeProperty;
    var url = Uri.https(baseUrl, 'services/check_accesscode/$code');

    try {
      final response = await http.get(url);
      final data = await json.decode(response.body);
      final accessCodePropertySJSON = data['data'];

      if (accessCodePropertySJSON != null) {
        accessCodeProperty =
            AccessCodeProperty.convertFromJson(accessCodePropertySJSON);
        return accessCodeProperty;
      }
    } catch (error) {
      print(error);
      return null;
    }
    return accessCodeProperty;
  }

  //AUTH METHODS *****************************************
  //*********************************************************** */
  // LOGIN ---
  Future<User?> login(String email, String password) async {
    var loginUser = LoginUser(email: email.trim(), password: password.trim());
    final jsonUser = loginUser.toJson();

    var url = Uri.https(baseUrl, '/services/LoginPortal/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonUser),
    );

    final data = await json.decode(response.body);
    final userJSON = data['user_data'];
    if (data['status'] == 0) {
      return null;
    }

    return User.convertFromJson(userJSON);
  }

  //SEND PASSWORD RESET CODE TO EMAIL
  Future<(String, String)> sendPasswordCode(
      String email, String masterAccessCode) async {
    final Map<String, dynamic> userData = <String, dynamic>{};

    userData['email'] = email;
    userData['master_access_code'] = masterAccessCode;

    var url = Uri.https(baseUrl, '/services/ForgetPasswordCodePortal');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );

    final data = await json.decode(response.body);
    return (data["message"].toString(), data["status"].toString());
  }

  //CHANGE PASSWORD
  Future<String> changePassword(String code, String newPassword) async {
    final Map<String, dynamic> userData = <String, dynamic>{};

    userData['forgot_code'] = code;
    userData['new_password'] = newPassword;

    var url = Uri.https(baseUrl, '/services/ForgetPasswordPortal');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );

    final data = await json.decode(response.body);
    print(response.body);
    final responseString = data['message'];

    return responseString;
  }

  //USER CRUD METHODS ************************************
  //***************************************************** */
  //CREATE USER
  Future<String> createUser(User user) async {
    user.register_as = 'resident';
    var url = Uri.https(baseUrl, '/services/PortalRegisterations/');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );

    final data = await json.decode(response.body);
    final responseString = data['message'];

    return responseString;
  }

  //UPDATE USER
  Future<void> updateUser(User user) async {
    var userId = user.userId!;
    var url = Uri.https(baseUrl, '/services/registry_index/$userId');

    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );
    print("UPDATE RESPONSE ${response.body}");
  }

  //DELETE USER
  Future<void> deleteUser(User user) async {
    var userId = user.userId!;
    deleteUserPreferences(user: user);
    var url = Uri.https(baseUrl, '/services/registry_index/$userId');

    final response = await http.delete(
      url,
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
    );
    print('${response.statusCode} ${response.body}');
  }

  //DELETED USER LOCAL STORED PREFERENCES -- CURRENTLY NOT IN USE
  deleteUserPreferences({required User user}) async {
    final SharedPreferences prefs = await preferences;
    prefs.remove('email');
    prefs.remove('${user.email}plates');
    prefs.remove('${user.email}visitors');
    prefs.remove('${user.email}locations');
  }

  //EXEMPTION/REGISTRATION METHODS ********************
  //************************************************* */
  //GET REGISTRATIONS FOR LIST VIEW
  Future<List<RegistrationListItem>> getRegistrations(String userId) async {
    List<RegistrationListItem> registrations = [];
    final Map<String, dynamic> userIdData = <String, dynamic>{};
    userIdData['user_id'] = userId;

    var url = Uri.https(baseUrl, '/services/GetRegistrations/');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userIdData));

    final data = await json.decode(response.body);
    print(data);
    List registrationsJSON = data["registrations"];

    registrations = registrationsJSON
        .map((entry) => RegistrationListItem.convertFromJson(entry))
        .toList();

    return registrations;
  }

  //CREATE EMPLOYEE REGISTRATION
  Future<String> createEmployeeRegistration(
      EmployeeRegistration employeeRegistration) async {
    print(employeeRegistration.toJson());

    var url = Uri.https(baseUrl, '/services/registerVehicle/');
    final response = await http.post(
      url,
      // headers: {"Content-Type": "application/json"},
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(employeeRegistration),
    );

    final data = await json.decode(response.body);
    final responseString = data['message'];

    print(responseString);

    return responseString;
  }

  //CREATE EXEMPTION FOR VISITORS
  Future<DatabaseResponseMessage> createExemption(
      Registration registration) async {
    var url = Uri.https(baseUrl, '/services/registry_index/');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(registration),
    );

    var jsonMessageReponse = json.decode(response.body.toString());
    var databaseResponseMessage =
        DatabaseResponseMessage.convertFromJson(jsonMessageReponse);

    return databaseResponseMessage;
  }

  //CREATE LOG ON TERMS AND CONDITIONS CLICK
  Future<void> createLog(Registration registration) async {
    var url = Uri.https(baseUrl, '/services/registry_log/');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(registration),
    );
  }
}
