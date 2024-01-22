import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:r2park_flutter_dev/models/property.dart';
import 'package:r2park_flutter_dev/models/exemption.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Managers/helper_functions.dart';
import '../../main.dart';
import '../../models/user.dart';

class VisitorSessionView extends StatefulWidget {
  final User user;
  final SessionCubit sessionCubit;

  const VisitorSessionView(
      {super.key, required this.user, required this.sessionCubit});
  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      VisitorSessionScreen(user: user, sessionCubit: sessionCubit);
}

class VisitorSessionScreen extends State<VisitorSessionView>
    with SingleTickerProviderStateMixin {
  final User user;
  final SessionCubit sessionCubit;

  final plateController = TextEditingController();
  final cityController = TextEditingController();
  final unitController = TextEditingController();
  final streetController = TextEditingController();

  late Future<List<String>> licensePlates;
  late Future<List<String>> previousProperties;
  List<Property>? properties;

  Property? _selectedproperty;
  String _selectedAddressID = '';
  String _selectedLicensePlate = '';
  int _selectedDuration = 1;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  String? unauthorizedPlateMessage;

  // var userManager = UserManager();
  // var exemptionManager = ExemptionRequestManager();
  var databaseManager = DatabaseManager();

  @override
  void initState() {
    super.initState();

    licensePlates = sessionCubit.preferences.then((SharedPreferences prefs) {
      var plates = prefs.getStringList('${user.email}plates') ?? [];
      if (plates.isNotEmpty) {
        _selectedLicensePlate = plates[0];
      }
      return plates;
    });
    setState(() {
      previousProperties =
          sessionCubit.preferences.then((SharedPreferences prefs) {
        var locations = prefs.getStringList('${user.email}locations') ?? [];
        if (locations.isNotEmpty) {
          _selectedAddressID = locations[0];
          _selectedproperty = sessionCubit.properties
              ?.firstWhere((element) => element.propertyID == locations[0]);
        }
        return locations;
      });
    });
  }

  VisitorSessionScreen({required this.user, required this.sessionCubit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Column(
            children: [
              _addPlateTitle(),
              _licencePlateSeciton(),
              _addLocationTitle(),
              _locationSection(),
              _durationInput(),
              _submitButton(),

              // _footerView()
            ],
          ),
        ),
      ),
    ));
  }

  Widget _addPlateTitle() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 4, 0),
        child: Text(
          'Licence Plates',
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ),
    );
  }

  Widget _licencePlateSeciton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: MediaQuery.of(context).size.width - 16,
          decoration: BoxDecoration(
              color: Colors.black26,
              border: Border.all(color: Colors.white30),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _licensePlateList(),
                _licencePlateForm(),
              ],
            ),
          )),
    );
  }

  Widget _licencePlateForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 120,
            child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: plateController,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.rectangle_rounded,
                    color: Colors.white,
                  ),
                  hintText: 'Add License Plate',
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                )),
          ),
          IconButton(
              onPressed: () {
                _addNewLicensePlate(
                    plateController.text.toUpperCase().replaceAll(' ', ''));
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
    if (plate.isNotEmpty && isValidPlate(plate)) {
      // updatedPlates.addAll(licensePlates);
      await sessionCubit.preferences.then((SharedPreferences prefs) {
        updatedPlates = prefs.getStringList('${user.email}plates') ?? [];
      });

      if (updatedPlates.contains(plate)) {
        updatedPlates.remove(plate);
      }
      updatedPlates.insert(0, plate.toUpperCase());
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
      openDialog(
          context,
          'Licence Plate invalid',
          'Please double check licence plate and try again',
          'Please double check licence plate and try again');
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
                              child: CheckboxListTile(
                                tileColor: secondaryColor,
                                checkboxShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                title: Text(
                                  plate,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                value: _selectedLicensePlate == plate,
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    newValue
                                        ? setState(
                                            () => _selectedLicensePlate = plate)
                                        : setState(
                                            () => _selectedLicensePlate = '');
                                  }
                                },
                              ),
                            ),
                          ))
                      .toList();

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // SizedBox(
                        //   width: double.infinity,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(4.0),
                        //     child: Text(
                        //       'License Plate:',
                        //       // ${_selectedLicensePlate.toUpperCase().trim()}',
                        //       textAlign: TextAlign.left,
                        //       style: TextStyle(
                        //           fontSize: 22,
                        //           fontWeight: FontWeight.w400,
                        //           color: Colors.white),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 120,
                          child:
                              Material(child: ListView(children: listOfPlates)),
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

  Widget _addLocationTitle() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 4, 0),
        child: Text(
          'Locations',
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ),
    );
  }

  Widget _locationSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: MediaQuery.of(context).size.width - 16,
          decoration: BoxDecoration(
              color: Colors.black26,
              border: Border.all(color: Colors.white30),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _previousLocationList(),
                Row(
                  children: [_unitNumberInput(), _streetInput()],
                ),
                Row(
                  children: [_cityInput(), _addLocationButton()],
                ),
              ],
            ),
          )),
    );
  }

  Widget _streetInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: streetController,
              decoration: InputDecoration(
                  // icon: Icon(
                  //   Icons.home_work,
                  //   color: Colors.white,
                  // ),
                  hintText: 'Street Number and Name',
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
            width: MediaQuery.of(context).size.width / 4,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: unitController,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.home_work,
                    color: Colors.white,
                  ),
                  hintText: 'Unit #',
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

  Widget _cityInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 130,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: cityController,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.place,
                    color: Colors.white,
                  ),
                  hintText: 'City Name...',
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

  Widget _addLocationButton() {
    return IconButton(
        onPressed: () {
          setState(() {
            var propertyID = sessionCubit.checkIfValidProperty(
                cityController.text.toLowerCase(),
                streetController.text.toLowerCase());

            if (propertyID != null) {
              sessionCubit.addLocation(locationID: propertyID, user: user);

              previousProperties =
                  sessionCubit.preferences.then((SharedPreferences prefs) {
                var locations =
                    prefs.getStringList('${user.email}locations') ?? [];
                if (locations.isNotEmpty) {
                  _selectedAddressID = locations[0];
                  _selectedproperty = sessionCubit.properties?.firstWhere(
                      (element) => element.propertyID == locations[0]);
                }
                return locations;
              });

              _selectedAddressID = propertyID;
            } else {
              openDialog(
                  context,
                  'Incorrect Address',
                  'please double check the address and try again',
                  'please double check the address and try again');
            }
          });
        },
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ));
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
                    listOfAddress = sessionCubit.properties
                        ?.where((element) =>
                            listOfaddressIds!.contains(element.propertyID))
                        .toList();
                  } catch (e) {
                    // ignore: avoid_print
                    print('error gettings list of address: $e');
                  }

                  if (snapshot.data != null && listOfAddress != null) {
                    if (listOfAddress.isNotEmpty) {
                      var listOfAddressTiles = listOfAddress
                          .map(
                            (address) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CheckboxListTile(
                                tileColor: secondaryColor,
                                checkboxShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                title: Text(
                                  address.propertyAddress!,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                value:
                                    _selectedAddressID == address.propertyID2,
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    newValue
                                        ? setState(() {
                                            _selectedAddressID =
                                                address.propertyID2!;
                                            _selectedproperty = address;
                                          })
                                        : setState(() {
                                            _selectedAddressID = '';
                                            _selectedproperty = null;
                                          });
                                  }
                                },
                              ),
                            ),
                          )
                          .toList();

                      return Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 120,
                              child: Material(
                                child: ListView(
                                  children: listOfAddressTiles,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: 120,
                        child: Center(
                          child: Text('No Locations Added.'),
                        ),
                      );
                    }
                  } else {
                    return SizedBox(
                      height: 120,
                    );
                  }
                } else {
                  return SizedBox(
                    height: 120,
                  );
                }
              }
          }
        });
  }

  Widget _durationInput() {
    final durationsList = [1, 2, 3, 4]
        .map(
          (duration) => SizedBox(
            height: 64,
            width: MediaQuery.of(context).size.width / 4 - 10,
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
                'Days Requested:',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
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
      style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
      onPressed: () => _submitPressed(),
      child: Text(
        '  Submit  ',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Exemption createExemption() {
    var selfRegistration = Exemption.def();
    selfRegistration.regDate = DateTime.now().toUtc();
    selfRegistration.plateID = _selectedLicensePlate;
    selfRegistration.propertyID = _selectedAddressID;
    selfRegistration.startDate = DateTime.now().toUtc();
    selfRegistration.endDate =
        DateTime.now().add(Duration(days: _selectedDuration)).toUtc();
    selfRegistration.unitNumber = '';
    selfRegistration.email = user.email;
    selfRegistration.phone = user.mobileNumber;
    selfRegistration.name = '${user.fullName}';
    selfRegistration.makeModel = '';
    selfRegistration.numberOfDays = '$_selectedDuration';
    selfRegistration.reason = 'guests';
    selfRegistration.notes = '';
    selfRegistration.authBy = '';
    selfRegistration.isArchived = '';

    var splitAddress = _selectedproperty?.propertyAddress?.split(',');

    selfRegistration.streetNumber = splitAddress?[0] ?? '0';
    selfRegistration.streetName = 'test';
    selfRegistration.streetSuffix = '';
    selfRegistration.address =
        _selectedproperty?.propertyAddress ?? 'Error getting addresss';

    return selfRegistration;
  }

  _verifyLicencePlate() async {
    unauthorizedPlateMessage =
        sessionCubit.isPlateBlacklisted(licencePlate: _selectedLicensePlate);
  }

  _submitPressed() {
    _verifyLicencePlate();
    // _addNewLicensePlate(_selectedLicensePlate);

    if (unauthorizedPlateMessage != null) {
      openDialog(context, 'Request Unsuccessful', '$unauthorizedPlateMessage',
          '$unauthorizedPlateMessage');
    } else {
      final exemption = createExemption();

      if (_selectedAddressID != '' && _selectedLicensePlate != '') {
        databaseManager.createExemption(exemption);

        openDialog(
            context,
            'Requested Submitted Successfully',
            'Thank you for using R2Park! Enjoy your visit!',
            'Thank you for using R2Park! Enjoy your visit!');
      } else {
        openDialog(
            context,
            'Please select Plate and Location',
            'Please ensure you have selected an address and licence plate',
            'Please ensure you have selected an address and licence plate');
      }
    }
  }

  // ignore: unused_element
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
