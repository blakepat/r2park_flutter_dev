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
import 'package:r2park_flutter_dev/models/role.dart';
import 'package:r2park_flutter_dev/models/street_address.dart';
import 'package:r2park_flutter_dev/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DatabaseManager {
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();
  // var baseUrl = 'r2park.biz';
  var baseUrl = 'dev.r2p.live';

  Future<List<User>> getUsersFromDevelopment() async {
    List<User> users = [];

    var url = Uri.https(baseUrl, '/services/registry_index');
    var response = await http.get(url);
    final data = await json.decode(response.body);

    // print("✅✅GET USERS: ${response.statusCode}: ${response.body}");

    List jsonUsers = data["data"];

    users = jsonUsers.map((entry) => User.convertFromJson(entry)).toList();

    return users;
  }

  Future<List<City>> getCities() async {
    List<City> cities = [];

    var url = Uri.https(baseUrl, '/services/cities');
    var response = await http.get(url);
    final data = await json.decode(response.body);

    // print("✅✅GET CITIES: ${response.statusCode}: ${response.body}");

    List jsonCities = data['data'];

    cities = jsonCities.map((entry) => City.convertFromJson(entry)).toList();

    var placeholderCity = City.def();
    placeholderCity.description = 'Choose a City';

    cities.insert(0, placeholderCity);

    return cities;
  }

  Future<List<Role>> getRoles() async {
    List<Role> roles = [];

    var url = Uri.https(baseUrl, '/services/contact_roles');
    var response = await http.get(url);
    final data = await json.decode(response.body);

    // print("✅✅GET ROLES: ${response.statusCode}: ${response.body}");

    List jsonRoles = data['data'];

    roles = jsonRoles.map((entry) => Role.convertFromJson(entry)).toList();

    var placeholderCity = Role.def();
    placeholderCity.name = 'Choose a Role';

    roles.insert(0, placeholderCity);

    return roles;
  }

  Future<List<String>> getAddressesForCity(String city) async {
    List<StreetAddress> addresses = [];

    var url = Uri.https(baseUrl, '/services/public_street/$city');
    var response = await http.get(url);
    final data = await json.decode(response.body);

    // print("✅✅GET ADDRESSES FOR CITY: ${response.statusCode}: ${response.body}");

    List jsonStreetAddresses = data['data'];

    addresses = jsonStreetAddresses
        .map((entry) => StreetAddress.convertFromJson(entry))
        .toList();
    final List<String> streetAddress =
        addresses.map((address) => address.street_address ?? '').toList();

    return streetAddress;
  }

  Future<List<Property>> getPropertiesFromJson() async {
    List<Property> properties = [];

    final String response =
        await rootBundle.loadString('assets/r2park_table.json');
    final data = await json.decode(response);

    // print("✅✅GET PROPERTIES: ${response}");

    List jsonProperties = data["properties"];

    properties =
        jsonProperties.map((entry) => Property.convertFromJson(entry)).toList();

    return properties;
  }

  Future<String> generateAccessCodes(
      AccessCodeRequest accessCodeRequest) async {
    final jsonRequest = accessCodeRequest.toJson();

    print(jsonRequest);

    var url = Uri.https(baseUrl, '/services/GenrateAccessCode/');
    final response = await http.post(
      url,
      // headers: {"Content-Type": "application/json"},
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

  Future<List<AccessCode>> getAccessCodes(String userId) async {
    List<AccessCode> accessCodes = [];

    final Map<String, dynamic> userIdData = <String, dynamic>{};

    userIdData['user_id'] = userId;

    var url = Uri.https(baseUrl, '/services/GetAccessCodes/');
    final response = await http.post(url,
        // headers: {"Content-Type": "application/json"},
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


  // LOGIN ---
  Future<User?> login(String email, String password) async {
    var loginUser = LoginUser(email: email.trim(), password: password.trim());
    final jsonUser = loginUser.toJson();

    // print(jsonUser);

    var url = Uri.https(baseUrl, '/services/LoginPortal/');
    final response = await http.post(
      url,
      // headers: {"Content-Type": "application/json"},
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonUser),
    );

    // print(response.body);
    final data = await json.decode(response.body);
    final userJSON = data['user_data'];

    if (data['status'] == 0) {
      return null;
    }

    // print(userJSON);

    final user = User.convertFromJson(userJSON);
    print(user.userId);

    return user;
  }
  //------


  Future<(String, String)> sendPasswordCode(
      String email, String masterAccessCode) async {
    final Map<String, dynamic> userData = <String, dynamic>{};

    userData['email'] = email;
    userData['master_access_code'] = masterAccessCode;

    var url = Uri.https(baseUrl, '/services/ForgetPasswordCodePortal');
    final response = await http.post(
      url,
      // headers: {"Content-Type": "application/json"},
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );

    final data = await json.decode(response.body);
    print(response.body);
    return (data["message"].toString(), data["status"].toString());
    // print(responseString);
  }

  Future<String> changePassword(String code, String newPassword) async {
    final Map<String, dynamic> userData = <String, dynamic>{};

    userData['forgot_code'] = code;
    userData['new_password'] = newPassword;

    var url = Uri.https(baseUrl, '/services/ForgetPasswordPortal');
    final response = await http.post(
      url,
      // headers: {"Content-Type": "application/json"},
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

  Future<String> createUser(User user) async {
    user.register_as = 'resident';
    print(user.toJson());

    var url = Uri.https(baseUrl, '/services/PortalRegisterations/');
    final response = await http.post(
      url,
      // headers: {"Content-Type": "application/json"},
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );

    print(jsonEncode(user));

    final data = await json.decode(response.body);
    print(response.body);
    final responseString = data['message'];

    // print(responseString);

    return responseString;
  }

  Future<AccessCodeProperty?> checkAccessCode(String code) async {
    print("DATABASE CODE CHECK");
    AccessCodeProperty? accessCodeProperty;

    var url = Uri.https(baseUrl, 'services/check_accesscode/$code');
    // print(url);
    try {
      final response = await http.get(url);
      final data = await json.decode(response.body);

      print("✅✅ACCESS CODE RETURN: ${response.statusCode}: ${response.body}");
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
  }

  Future<void> activateAccessCode(String accessCode, String userId) async {
    final Map<String, dynamic> accessCodeData = <String, dynamic>{};

    accessCodeData['access_code'] = accessCode;
    accessCodeData['user_id'] = userId;

    var url = Uri.https(baseUrl, '/services/AccessCodeStatus');
    final response = await http.post(
      url,
      // headers: {"Content-Type": "application/json"},
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
      // headers: {"Content-Type": "application/json"},
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
      // headers: {"Content-Type": "application/json"},
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

  Future<void> updateUser(User user) async {
    var userId = user.userId!;

    var url = Uri.https(baseUrl, '/services/registry_index/$userId');
    final response = await http.put(
      url,
      // headers: {"Content-Type": "application/json"},
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );

    print("💜💜 ${response.body}");
  }

  // Future<void> deleteUser(User user) async {
  //   var userId = user.userId;
  //   deleteUserPreferences(user: user);

  //   print("User To Delete: ${userId} ${user.fullName}");
  // }

  Future<void> deleteUser(User user) async {
    var userId = user.userId!;
    deleteUserPreferences(user: user);

    var url = Uri.https(baseUrl, '/services/registry_index/$userId');
    final response = await http.delete(
      url,
      // headers: {"Content-Type": "application/json"},
      // headers: <String, String>{
      //   'Content-Type': 'application/json; charset=UTF-8',
      // },
    );
    print('${response.statusCode} ${response.body}');
  }

  deleteUserPreferences({required User user}) async {
    final SharedPreferences prefs = await preferences;
    prefs.remove('email');
    prefs.remove('${user.email}plates');
    prefs.remove('${user.email}visitors');
    prefs.remove('${user.email}locations');
  }

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

  Future<DatabaseResponseMessage> createExemption(
      Registration registration) async {
    var jsonExemption = registration.toJson();

    print(jsonExemption);

    var url = Uri.https(baseUrl, '/services/registry_index/');
    final response = await http.post(
      url,
      // headers: {"Content-Type": "application/json"},
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

  Future<void> createLog(Registration registration) async {
    var jsonExemption = registration.toJson();

    print(jsonExemption);

    var url = Uri.https(baseUrl, '/services/registry_log/');
    final response = await http.post(
      url,
      // headers: {"Content-Type": "application/json"},
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(registration),
    );

    print("✅ ${response.body}");

    // var jsonMessageReponse = json.decode(response.body.toString());

    // print("Exemption Created: ${jsonExemption}");
  }
}
