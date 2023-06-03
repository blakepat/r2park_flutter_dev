import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r2park_flutter_dev/models/property.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../../models/visitor.dart';
import '../auth/auth_utilities/auth_repo.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepo authRepo;
  List<User>? users;
  List<Property>? properties;
  final Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  SessionCubit({required this.authRepo, this.users, this.properties})
      : super(UnknownSessionState()) {
    attemptAutoLogin();
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
        // print('attemptAutoLogin - USER is null');
        // signOut();
        emit(Unauthenticated());
      } else {
        showSession(user);
        emit(Authenticated(user: user));
      }
    } on Exception {
      emit(Unauthenticated());
    }
  }

  void updateLicensePlates(
      {required List<String> plates, required User user}) async {
    final SharedPreferences prefs = await preferences;
    await prefs.setStringList('plates', plates);
  }

  void saveVisitor(Visitor visitor) async {
    final SharedPreferences prefs = await preferences;

    var previousVisitorList = prefs.getStringList('visitors') ?? [];

    String newVisitor =
        '${visitor.firstName},${visitor.lastName},${visitor.plateNumber}';

    previousVisitorList.add(newVisitor);

    prefs.setStringList('visitors', previousVisitorList);
  }

  Future<List<Visitor>> getVisitors() async {
    final SharedPreferences prefs = await preferences;
    var savedVisitors = prefs.getStringList('visitors') ?? [];
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
    final SharedPreferences prefs = await preferences;
    var locations = prefs.getStringList('locations') ?? [];
    if (!locations.contains(locationID)) {
      locations.add(locationID);
    }
    await prefs.setStringList('locations', locations);
  }

  void removeLocation(String locationID) async {
    final SharedPreferences prefs = await preferences;
    var locations = prefs.getStringList('locations') ?? [];
    locations.remove(locationID);
    await prefs.setStringList('locations', locations);
  }

  String? checkIfValidProperty(String city, String streetName) {
    Property? property;
    try {
      property = properties?.firstWhere((element) {
        var splitAddress = element.propertyAddress?.split(',');
        // print(splitAddress);
        final cityName = splitAddress?[1].toLowerCase().trim();
        var partOfStreetName = splitAddress?[0].split(' ')[1].toLowerCase();
        // print(partOfStreetName);
        // print('✅ $partOfStreetName == $streetName and $cityName == $city');
        if (partOfStreetName != null) {
          return cityName == city && streetName.contains(partOfStreetName);
        }
        return false;
      });
    } catch (e) {
      property = null;
    }
    // print('${property?.propertyName}, ${property?.propertyID2}');
    return property?.propertyID2;
  }

  Future<List<String>> getLicensePlates() async {
    final SharedPreferences prefs = await preferences;
    return prefs.getStringList('plates') ?? [];
  }

  List<User> getResidentRequests({required String addressID}) {
    var residents = users
            ?.where((element) =>
                element.clientDisplayName == addressID &&
                element.authorityLevel == 5)
            .toList() ??
        [];

    residents.sort((a, b) =>
        (a.address2 ?? a.address1!).compareTo(b.address2 ?? b.address1!));

    return residents;
  }

  List<User> getResidents({required String addressID}) {
    var residents = users
            ?.where((element) =>
                element.clientDisplayName == addressID &&
                element.authorityLevel == 12)
            .toList() ??
        [];

    residents.sort((a, b) =>
        (a.address2 ?? a.address1!).compareTo(b.address2 ?? b.address1!));

    return residents;
  }

  void showAuth() => emit(Unauthenticated());

  void showSession(User user) async {
    try {
      // if (user == null) {
      // emit(Unauthenticated());
      // } else {
      if (user.email != null) {
        // print('SHARED PREFERENCE SET! - ${user.email!}');
        final SharedPreferences prefs = await preferences;
        await prefs.setString('email', user.email!);
        // }

        emit(Authenticated(user: user));
      }
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  void signOut() async {
    final SharedPreferences prefs = await preferences;
    prefs.remove('email');
    authRepo.signOut();
    emit(Unauthenticated());
  }
}
