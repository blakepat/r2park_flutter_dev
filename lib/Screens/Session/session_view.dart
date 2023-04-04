import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:r2park_flutter_dev/Managers/ExemptionRequestManager.dart';
import 'package:r2park_flutter_dev/Managers/UserManager.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:r2park_flutter_dev/models/exemption.dart';
import 'package:r2park_flutter_dev/models/property.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../auth/sign_up/new_user.dart';

class SessionView extends StatefulWidget {
  final User user;
  final SessionCubit sessionCubit;

  SessionView({required this.user, required this.sessionCubit});
  @override
  State<StatefulWidget> createState() =>
      SessionScreen(user: user, sessionCubit: sessionCubit);
}

class SessionScreen extends State<SessionView> {
  final User user;
  final SessionCubit sessionCubit;

  final plateController = TextEditingController();
  final cityController = TextEditingController();
  final unitController = TextEditingController();
  final streetController = TextEditingController();

  late Future<List<String>> licensePlates;
  late Future<List<String>> previousProperties;
  List<Property>? properties;

  String _selectedAddressID = '';
  String _selectedLicensePlate = '';
  int _selectedDuration = 1;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  var userManager = UserManager();
  var exemptionManager = ExemptionRequestManager();

  @override
  void initState() {
    super.initState();
    licensePlates = sessionCubit.prefs.then((SharedPreferences _prefs) {
      var plates = _prefs.getStringList('plates') ?? [];
      if (plates.isNotEmpty) {
        _selectedLicensePlate = plates[0];
      }
      return plates;
    });

    previousProperties = sessionCubit.prefs.then((SharedPreferences _prefs) {
      var locations = _prefs.getStringList('locations') ?? [];
      if (locations.isNotEmpty) {
        _selectedAddressID = locations[0];
      }
      return locations;
    });
  }

  SessionScreen({required this.user, required this.sessionCubit});

  @override
  Widget build(BuildContext context) {
    properties = Provider.of<List<Property>>(context);
    if (sessionCubit.properties == null) {
      sessionCubit.properties = properties;
    }
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: _createAppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _headerView(),
              _licencePlateForm(),
              _licensePlateList(),
              _cityInput(),
              Row(
                children: [_unitNumberInput(), _streetInput()],
              ),
              // _unitNumberInput(),
              // _streetInput(),
              _previousLocationList(),
              _durationInput(),
              _submitButton(),
              _footerView()
            ],
          ),
        ),
      ),
    );
  }

  AppBar _createAppBar() {
    return AppBar(
      actions: [
        IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) =>
                        NewUser(user: user, sessionCubit: sessionCubit)))
                .then((obj) {
              if (obj != null) {
                userManager.updateUser(obj);
              }
            });
          },
        )
      ],
      leading: IconButton(
        icon: Icon(Icons.logout),
        onPressed: () => BlocProvider.of<SessionCubit>(context).signOut(),
      ),
      backgroundColor: Colors.blue,
      title: Text("Register to Park"),
      shadowColor: Colors.black54,
    );
  }

  Widget _headerView() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Text(
        'Register Vehicle',
        textAlign: TextAlign.left,
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _licencePlateForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          SizedBox(
            width: 260,
            child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: plateController,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.rectangle_rounded,
                    color: Colors.white,
                  ),
                  hintText: 'add new license plate...',
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                )),
          ),
          IconButton(
              onPressed: () {
                _addNewLicensePlate(plateController.text);
                plateController.text = '';
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
    );
  }

  void _addNewLicensePlate(String plate) async {
    List<String> updatedPlates = List.empty(growable: true);
    //validate plate
    if (plate.isNotEmpty) {
      // updatedPlates.addAll(licensePlates);
      await sessionCubit.prefs.then((SharedPreferences _prefs) {
        updatedPlates = _prefs.getStringList('plates') ?? [];
      });
      updatedPlates.add(plate.toUpperCase());
      sessionCubit.updateLicensePlates(plates: updatedPlates, user: user);

      final sharedPrefs = await prefs;

      setState(() {
        licensePlates = sharedPrefs
            .setStringList('plates', updatedPlates)
            .then((bool success) {
          return updatedPlates;
        });
      });

      setState(() {});
    } else {
      //show alert
      print('plate not valid');
    }
  }

  Widget _licensePlateList() {
    return FutureBuilder<List<String>>(
        future: licensePlates,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.data != null) {
                  var listOfPlates = snapshot.data!
                      .map((plate) => Dismissible(
                            background: Container(color: Colors.red),
                            key: Key(plate),
                            onDismissed: (direction) {
                              setState(() {
                                snapshot.data!
                                    .removeWhere((element) => element == plate);
                                sessionCubit.updateLicensePlates(
                                    plates: snapshot.data!, user: user);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                onPressed: () {},
                                child: CheckboxListTile(
                                  title: Text(
                                    plate,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  shape: RoundedRectangleBorder(),
                                  value: _selectedLicensePlate == plate,
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      newValue
                                          ? setState(() =>
                                              _selectedLicensePlate = plate)
                                          : setState(
                                              () => _selectedLicensePlate = '');
                                    }
                                  },
                                ),
                              ),
                            ),
                          ))
                      .toList();

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              'License Plate: ${_selectedLicensePlate.toUpperCase().trim()}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 120,
                          child: ListView(children: listOfPlates),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox();
                }
              }
          }
        });
  }

  Widget _previousLocationList() {
    return FutureBuilder<List<String>>(
        future: previousProperties,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.data != null) {
                  final listOfaddressIds = snapshot.data;
                  List<Property>? listOfAddress;
                  try {
                    listOfAddress = properties
                        ?.where((element) =>
                            listOfaddressIds!.contains(element.propertyID))
                        .toList();
                  } catch (e) {
                    print('error gettings list of address: $e');
                  }

                  if (listOfAddress != null) {
                    var listOfAddressTiles = listOfAddress
                        .map((address) => Dismissible(
                              background: Container(color: Colors.red),
                              key: Key(address.propertyName!),
                              onDismissed: (direction) {
                                setState(() {
                                  snapshot.data!.removeWhere(
                                      (element) => element == address);
                                  //TODO: remove plate from userDefaults
                                  //   sessionCubit.updateLicensePlates(
                                  //       plates: snapshot.data!, user: user);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                  onPressed: () {},
                                  child: CheckboxListTile(
                                    title: Text(
                                      address.propertyAddress!,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    shape: RoundedRectangleBorder(),
                                    value: _selectedAddressID ==
                                        address.propertyID,
                                    onChanged: (newValue) {
                                      if (newValue != null) {
                                        newValue
                                            ? setState(() =>
                                                _selectedAddressID =
                                                    address.propertyID!)
                                            : setState(
                                                () => _selectedAddressID = '');
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ))
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'Locations:',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 120,
                            child: ListView(children: listOfAddressTiles),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                } else {
                  return SizedBox();
                }
              }
          }
        });
  }

  Widget _cityInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 260,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: cityController,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.place,
                    color: Colors.white,
                  ),
                  hintText: 'City name...',
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _streetInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: streetController,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.home_work,
                    color: Colors.white,
                  ),
                  hintText: 'Street name',
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _unitNumberInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: unitController,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.numbers,
                    color: Colors.white,
                  ),
                  hintText: 'unit #',
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _durationInput() {
    final durationsList = [1, 2, 3, 4]
        .map(
          (duration) => Container(
            height: 64,
            width: 84,
            child: CheckboxListTile(
              checkColor: Colors.red,
              activeColor: Colors.white,
              title: Text(
                duration.toString(),
                style: TextStyle(color: Colors.white),
              ),
              value: duration == _selectedDuration,
              onChanged: (newValue) => setState(() {
                if (newValue != null) {
                  _selectedDuration = duration;
                }
              }),
            ),
          ),
        )
        .toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 10, 6, 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                'Number of days:',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Row(children: durationsList),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: () => _submitPressed(), child: Text('Submit'));
  }

  Exemption createExemption() {
    var exemption = Exemption.def();
    exemption.name = '${user.firstName} ${user.lastName}';
    exemption.email = user.email;
    exemption.phone = user.homePhone;
    exemption.plateNumber = _selectedLicensePlate;
    exemption.streetNumber = unitController.text;
    exemption.streetName = streetController.text;
    exemption.requestedDays = _selectedDuration;
    exemption.municipality = cityController.text;
    exemption.created = DateTime.now().toUtc();
    exemption.reason = 'guests';

    return exemption;
  }

  _submitPressed() {
    final exemption = createExemption();
    var propertyID = sessionCubit.checkIfValidProperty(
        cityController.text.toLowerCase(), streetController.text.toLowerCase());

    if (propertyID != null) {
      print('✅ $propertyID property valid!');
      sessionCubit.addLocation(propertyID);
      exemptionManager.createExemptionRequest(exemption);
    } else {
      openDialog(
          context,
          'Incorrect Address',
          'please double check the address and try again',
          'please double check the address and try again');
    }

    print(
        '\nLicense Plate: $_selectedLicensePlate \nCity Name: ${cityController.text} \n Address: ${unitController.text} ${streetController.text} \n Duration: $_selectedDuration \n');
  }

  void openDialog(BuildContext context, String dialogTitle, StringContent,
      String dialogContent) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text(dialogTitle),
            content: Text(dialogContent),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Back'))
            ],
          );
        }));
  }

  Widget _footerView() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        user.email ?? 'no email found',
        style: TextStyle(
            color: Colors.white, fontSize: 12, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
