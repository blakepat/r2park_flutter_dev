import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:r2park_flutter_dev/models/property.dart';
import 'package:r2park_flutter_dev/models/exemption.dart';
import 'package:r2park_flutter_dev/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseManager {
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  Future<List<User>> getUsersFromJson() async {
    List<User> users = [];

    final String response =
        await rootBundle.loadString('assets/r2park_table.json');
    final data = await json.decode(response);
    List jsonUsers = data["users"];

    users = jsonUsers.map((entry) => User.convertFromJson(entry)).toList();

    return users;
  }

  Future<List<Property>> getPropertiesFromJson() async {
    List<Property> properties = [];

    final String response =
        await rootBundle.loadString('assets/r2park_table.json');
    final data = await json.decode(response);
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

  Future<void> createUser(User user) async {
    var jsonUser = user.toJson();

    print("New User: ${jsonUser}");
  }

  Future<void> updateUser(User user) async {
    var jsonUser = user.toJson();

    print("Updated User: ${jsonUser}");
  }

  Future<void> deleteUser(User user) async {
    var userId = user.userId;
    deleteUserPreferences(user: user);

    print("User To Delete: ${userId} ${user.fullName}");
  }

  deleteUserPreferences({required User user}) async {
    final SharedPreferences prefs = await preferences;
    prefs.remove('email');
    prefs.remove('${user.email}plates');
    prefs.remove('${user.email}visitors');
    prefs.remove('${user.email}locations');
  }

  Future<void> createExemption(Exemption exemption) async {
    var jsonExemption = exemption.toJson();

    print("Exemption Created: ${jsonExemption}");
  }
}
