import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r2park_flutter_dev/models/property.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../../models/visitor.dart';
import '../auth/auth_utilities/auth_credentials.dart';
import '../auth/auth_utilities/auth_repo.dart';
import '../auth/data_repo.dart';
import 'session_state.dart';
import 'package:collection/collection.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepo authRepo;
  final DataRepo dataRepo;
  List<User>? users;
  List<Property>? properties;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  SessionCubit(
      {required this.authRepo,
      required this.dataRepo,
      this.users,
      this.properties})
      : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    final SharedPreferences _prefs = await prefs;
    String? userEmail = _prefs.getString('email');
    User? user;
    try {
      if (userEmail != null && users != null) {
        if (users!.isNotEmpty) {
          user = users?.firstWhere((element) => element.email == userEmail);
        }
      }

      if (user == null) {
        print('attemptAutoLogin - USER is null');
        // signOut();
        emit(Unauthenticated());
      } else {
        print(user.email);
        showSession(user);
        emit(Authenticated(user: user));
      }
    } on Exception {
      print('attemptAutoLoginFailed!');
      emit(Unauthenticated());
    }
  }

  void updateLicensePlates(
      {required List<String> plates, required User user}) async {
    print(plates);
    final SharedPreferences _prefs = await prefs;
    await _prefs.setStringList('plates', plates);

    // await dataRepo.updateSavedLicensePlates(plates: plates, user: user);
  }

  void saveVisitor(Visitor visitor) async {
    final SharedPreferences _prefs = await prefs;

    var previousVisitorList = _prefs.getStringList('visitors') ?? [];

    String newVisitor =
        '${visitor.firstName},${visitor.lastName},${visitor.plateNumber}';

    previousVisitorList.add(newVisitor);

    _prefs.setStringList('visitors', previousVisitorList);
  }

  Future<List<Visitor>> getVisitors() async {
    final SharedPreferences _prefs = await prefs;

    var visitors = _prefs.getStringList('visitors');

    var savedVisitors = _prefs.getStringList('visitors') ?? [];
    List<Visitor> visitorList = [];
    for (var i = 0; i < savedVisitors.length; i++) {
      var visitor = savedVisitors[i];
      List<String> separatedVisitor = visitor.split(',');

      visitorList.add(Visitor(
          firstName: separatedVisitor[0],
          lastName: separatedVisitor[1],
          plateNumber: separatedVisitor[2]));
    }
    return visitorList;
  }

  void addLocation(String locationID) async {
    final SharedPreferences _prefs = await prefs;
    var locations = _prefs.getStringList('locations') ?? [];
    if (!locations.contains(locationID)) {
      locations.add(locationID);
    }
    await _prefs.setStringList('locations', locations);
  }

  void removeLocation(String locationID) async {
    final SharedPreferences _prefs = await prefs;
    var locations = _prefs.getStringList('locations') ?? [];
    locations.remove(locationID);
    print(locationID);
    print(locations);
    await _prefs.setStringList('locations', locations);
  }

  String? checkIfValidProperty(String city, String streetName) {
    print(properties?.length);

    Property? property;
    try {
      property = properties?.firstWhere((element) {
        var splitAddress = element.propertyAddress?.split(',');
        print(splitAddress);
        final cityName = splitAddress?[1].toLowerCase().trim();
        var partOfStreetName = splitAddress?[0].split(' ')[1].toLowerCase();
        print(partOfStreetName);
        print('✅ $partOfStreetName == $streetName and $cityName == $city');
        if (partOfStreetName != null) {
          return cityName == city && streetName.contains(partOfStreetName);
        }
        return false;
      });
    } catch (e) {
      property = null;
    }

    print('${property?.propertyName}, ${property?.propertyID}');

    return property?.propertyID;
  }

  Future<List<String>> getLicensePlates() async {
    final SharedPreferences _prefs = await prefs;
    return _prefs.getStringList('plates') ?? [];
  }

  void showAuth() => emit(Unauthenticated());

  void showSession(User user) async {
    try {
      if (user == null) {
        emit(Unauthenticated());
      } else {
        if (user.email != null) {
          print('SHARED PREFERENCE SET! - ${user.email!}');
          final SharedPreferences _prefs = await prefs;
          await _prefs.setString('email', user.email!);
        }

        emit(Authenticated(user: user));
      }
    } catch (e) {
      print('show session failed');
      emit(Unauthenticated());
    }
  }

  void signOut() async {
    final SharedPreferences _prefs = await prefs;
    _prefs.remove('email');
    authRepo.signOut();
    emit(Unauthenticated());
  }
}
