import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r2park_flutter_dev/models/city.dart';
import 'package:r2park_flutter_dev/models/property.dart';
import 'package:r2park_flutter_dev/models/role.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../../models/visitor.dart';
import '../auth/auth_utilities/auth_repo.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepo authRepo;
  List<User>? users;
  List<Property>? properties;
  List<City>? cities;
  List<Role>? roles;
  List<String>? blacklistPlates;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  SessionCubit(
      {required this.authRepo,
      this.users,
      this.properties,
      this.cities,
      this.roles})
      : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  //MARK: - Visitor Methods
  void saveVisitor({required Visitor visitor, required User user}) async {
    final SharedPreferences prefs = await preferences;
    var previousVisitorList =
        prefs.getStringList('${user.email}visitors') ?? [];

    String newVisitor = '${visitor.name},${visitor.plateNumber}';
    if (!previousVisitorList.contains(newVisitor)) {
      previousVisitorList.add(newVisitor);
      prefs.setStringList('${user.email}visitors', previousVisitorList);
    }
  }

  void updateVisitors(
      {required List<String> visitors, required User user}) async {
    final SharedPreferences prefs = await preferences;
    await prefs.setStringList('${user.email}visitors', visitors);
  }

  Future<List<Visitor>> getVisitors({required User user}) async {
    final SharedPreferences prefs = await preferences;
    var savedVisitors = prefs.getStringList('${user.email}visitors') ?? [];
    List<Visitor> visitorList = [];
    for (var i = 0; i < savedVisitors.length; i++) {
      var visitor = savedVisitors[i];
      List<String> separatedVisitor = visitor.split(',');

      visitorList.add(
          Visitor(name: separatedVisitor[0], plateNumber: separatedVisitor[1]));
    }
    return visitorList;
  }
  ///////////////////////////////////////////

  //MARK: - Location Methods
  void addLocation({required String locationID, required User user}) async {
    final SharedPreferences prefs = await preferences;
    var locations = prefs.getStringList('${user.email}locations') ?? [];
    if (!locations.contains(locationID)) {
      locations.add(locationID);
    }
    await prefs.setStringList('${user.email}locations', locations);
  }

  void removeLocation({required String locationID, required User user}) async {
    final SharedPreferences prefs = await preferences;
    var locations = prefs.getStringList('${user.email}locations') ?? [];
    locations.remove(locationID);
    await prefs.setStringList('${user.email}locations', locations);
  }

  Property? getPropertyFromID(String propertyId) {
    return properties
        ?.firstWhere((element) => element.propertyID == propertyId);
  }

  String? checkIfValidProperty(String city, String streetName) {
    Property? property;
    try {
      property = properties?.firstWhere((element) {
        var splitAddress = element.propertyAddress?.split(',');
        final cityName = splitAddress?[1].toLowerCase().trim();
        var partOfStreetName = splitAddress?[0].split(' ')[1].toLowerCase();
        if (partOfStreetName != null) {
          return cityName == city && streetName.contains(partOfStreetName);
        }
        return false;
      });
    } catch (e) {
      property = null;
    }
    return property?.propertyID;
  }
  ///////////////////////////////////////////

  //MARK: - License Plate Methods
  Future<List<String>> getLicensePlates({required User user}) async {
    final SharedPreferences prefs = await preferences;
    return prefs.getStringList('${user.email}plates') ?? [];
  }

  void updateLicensePlates(
      {required List<String> plates, required User user}) async {
    final SharedPreferences prefs = await preferences;

    await prefs.setStringList('${user.email}plates', plates);
  }

  String? isPlateBlacklisted({required String licencePlate}) {
    String? unauthorizedMessage;
    if (blacklistPlates != null) {
      if (blacklistPlates!.contains(licencePlate)) {
        unauthorizedMessage =
            "Licence Plate Blacklisted, unable to park complete registration";
      }
    }

    return unauthorizedMessage;
  }

  //MARK: - Resident Methods
  List<User> getResidentRequests({required String addressID}) {
    var residents = users
            ?.where((element) =>
                element.master_access_code == addressID &&
                element.register_as == "Visitor")
            .toList() ??
        [];

    residents.sort((a, b) =>
        (a.address1 ?? a.unitNumber!).compareTo(b.address1 ?? b.unitNumber!));

    return residents;
  }

  List<User> getResidents({required String addressID}) {
    var residents = users
            ?.where((element) =>
                element.master_access_code == addressID &&
                element.register_as == "Resident")
            .toList() ??
        [];

    residents.sort((a, b) =>
        (a.unitNumber ?? a.address1!).compareTo(b.unitNumber ?? b.address1!));

    return residents;
  }
  ///////////////////////////////////////////

  //MARK: - Auth Methods
  void showAuth() => emit(Unauthenticated());

  void showSession(User user) async {
    try {
      if (user.email != null) {
        final SharedPreferences prefs = await preferences;
        await prefs.setString('email', user.email!);
        emit(Authenticated(user: user));
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  void signOut() async {
    final SharedPreferences prefs = await preferences;
    prefs.remove('email');
    emit(Unauthenticated());
  }

  void attemptAutoLogin() async {
    final SharedPreferences prefs = await preferences;
    String? userEmail = prefs.getString('email');
    User? user;
    try {
      if (userEmail != null && users != null) {
        if (users!.isNotEmpty) {
          user = users?.firstWhere((element) => element.email == userEmail);
        }
      }

      if (user == null) {
        emit(Unauthenticated());
      } else {
        showSession(user);
        emit(Authenticated(user: user));
      }
    } on Exception {
      emit(Unauthenticated());
    }
  }
}
