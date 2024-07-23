import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:r2park_flutter_dev/models/city.dart';
import 'package:r2park_flutter_dev/models/database_response_message.dart';
import 'package:r2park_flutter_dev/models/property.dart';
import 'package:r2park_flutter_dev/models/exemption.dart';
import 'package:r2park_flutter_dev/models/registration.dart';
import 'package:r2park_flutter_dev/models/street_address.dart';
import 'package:r2park_flutter_dev/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DatabaseManager {
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  // Future<List<User>> getUsersFromJson() async {
  //   List<User> users = [];

  //   final String response =
  //       await rootBundle.loadString('assets/r2park_table.json');
  //   final data = await json.decode(response);
  //   List jsonUsers = data["users"];

  //   users = jsonUsers.map((entry) => User.convertFromJson(entry)).toList();

  //   return users;
  // }

  Future<List<User>> getUsersFromDevelopment() async {
    List<User> users = [];

    var url = Uri.https('dev.r2p.live', '/services/registry_index');
    var response = await http.get(url);
    final data = await json.decode(response.body);

    // print("✅✅GET USERS: ${response.statusCode}: ${response.body}");

    List jsonUsers = data["data"];

    users = jsonUsers.map((entry) => User.convertFromJson(entry)).toList();

    return users;
  }

  Future<List<City>> getCities() async {
    List<City> cities = [];

    var url = Uri.https('dev.r2p.live', '/services/cities');
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

  Future<List<String>> getAddressesForCity(String city) async {
    List<StreetAddress> addresses = [];

    var url = Uri.https('dev.r2p.live', '/services/public_street/$city');
    var response = await http.get(url);
    final data = await json.decode(response.body);

    // print("✅✅GET ADDRESSES FOR CITY: ${response.statusCode}: ${response.body}");

    List jsonStreetAddresses = data['data'];

    addresses = jsonStreetAddresses
        .map((entry) => StreetAddress.convertFromJson(entry))
        .toList();
    final List<String> street_addresses =
        addresses.map((address) => address.street_address ?? '').toList();

    return street_addresses;
  }

  Future<void> getDataFromPostman() async {
    var url = Uri.https('dev.r2p.live', '/services/registry_index');
    var response = await http.get(url);
    // print(json.decode(response.body));
  }

  Future<List<Property>> getPropertiesFromJson() async {
    List<Property> properties = [];

    final String response =
        await rootBundle.loadString('assets/r2park_table.json');
    final data = await json.decode(response);

    print("✅✅GET PROPERTIES: ${response}");

    List jsonProperties = data["properties"];

    properties =
        jsonProperties.map((entry) => Property.convertFromJson(entry)).toList();

    return properties;
  }

  Future<List<String>> getBlacklistLicencePlates() async {
    List<String> blacklistPlates = [];

    final String response =
        await rootBundle.loadString('assets/r2park_table.json');
    final data = await json.decode(response);
    List jsonProperties = data["blacklistPlates"];

    blacklistPlates = jsonProperties.map((entry) => '').toList();

    return blacklistPlates;
  }

  // Future<void> createUser(User user) async {
  //   var jsonUser = user.toJson();

  //   print("New User: ${jsonUser}");
  // }

  Future<void> createUser(User user) async {
    var newUser = user;
    newUser.propertyId = '';
    newUser.companyAddress = '';
    newUser.companyId = '';
    print(user.toJson());

    var url = Uri.https('dev.r2p.live', '/services/registry_index/');
    final response = await http.post(
      url,
      // headers: {"Content-Type": "application/json"},
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );

    print("💜💜 ${response.body}");
  }

  Future<void> updateUser(User user) async {
    var userId = user.userId!;

    var url = Uri.https('dev.r2p.live', '/services/registry_index/$userId');
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

    var url = Uri.https('dev.r2p.live', '/services/registry_index/$userId');
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

  Future<DatabaseResponseMessage> createExemption(
      Registration registration) async {
    var jsonExemption = registration.toJson();

    print(jsonExemption);

    var url = Uri.https('dev.r2p.live', '/services/registry_index/');
    final response = await http.post(
      url,
      // headers: {"Content-Type": "application/json"},
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(registration),
    );

    print("💜💜 ${response.body}");

    var jsonMessageReponse = json.decode(response.body.toString());

    var databaseResponseMessage =
        DatabaseResponseMessage.convertFromJson(jsonMessageReponse);

    print(
        "💜💜 ${databaseResponseMessage.message}\n ${databaseResponseMessage.description}");

    print("Exemption Created: ${jsonExemption}");

    return databaseResponseMessage;
  }

  Future<void> createLog(Registration registration) async {
    var jsonExemption = registration.toJson();

    print(jsonExemption);

    var url = Uri.https('dev.r2p.live', '/services/registry_log/');
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
