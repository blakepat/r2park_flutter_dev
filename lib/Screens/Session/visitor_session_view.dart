import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r2park_flutter_dev/Managers/exemption_request_manager.dart';
import 'package:r2park_flutter_dev/Managers/user_manager.dart';
import 'package:r2park_flutter_dev/Screens/Session/resident_session_view.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:r2park_flutter_dev/models/property.dart';
import 'package:r2park_flutter_dev/models/self_registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../auth/sign_up/new_user.dart';
import 'manager_session_view.dart';

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

  late TabController _tabController;
  int _activeIndex = 0;
  bool isResident = false;
  bool isManager = false;

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

  var userManager = UserManager();
  var exemptionManager = ExemptionRequestManager();

  @override
  void initState() {
    super.initState();

    isResident = user.clientDisplayName != '';
    isManager = user.authorityLevel == 6 && user.clientDisplayName != '';
    _tabController = TabController(
        length: isResident ? (isManager ? 4 : 3) : 2, vsync: this);
    licensePlates = sessionCubit.preferences.then((SharedPreferences prefs) {
      var plates = prefs.getStringList('plates') ?? [];
      if (plates.isNotEmpty) {
        _selectedLicensePlate = plates[0];
      }
      return plates;
    });
    setState(() {
      previousProperties =
          sessionCubit.preferences.then((SharedPreferences prefs) {
        var locations = prefs.getStringList('locations') ?? [];
        if (locations.isNotEmpty) {
          _selectedAddressID = locations[0];
          _selectedproperty = sessionCubit.properties
              ?.firstWhere((element) => element.propertyID2 == locations[0]);
        }
        return locations;
      });
    });
  }

  VisitorSessionScreen({required this.user, required this.sessionCubit});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _activeIndex = _tabController.index;
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: _createAppBar(width),
      body: SizedBox(
        width: width,
        child: TabBarView(
          controller: _tabController,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Column(
                  children: [
                    _addPlateTitle(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: MediaQuery.of(context).size.width - 16,
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              border: Border.all(color: Colors.white30),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                _licensePlateList(),
                                _licencePlateForm(),
                              ],
                            ),
                          )),
                    ),
                    _addLocationTitle(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: MediaQuery.of(context).size.width - 16,
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              border: Border.all(color: Colors.white30),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                _previousLocationList(),
                                Row(
                                  children: [
                                    _unitNumberInput(),
                                    _streetInput()
                                  ],
                                ),
                                Row(
                                  children: [
                                    _cityInput(),
                                    _addLocationButton()
                                  ],
                                ),
                              ],
                            ),
                          )),
                    ),

                    _durationInput(),
                    _submitButton(),
                    // _footerView()
                  ],
                ),
              ),
            ),
            if (isResident)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    ResidentSessionView(user: user, sessionCubit: sessionCubit),
              ),
            if (isManager)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    ManagerSessionView(user: user, sessionCubit: sessionCubit),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: NewUser(user: user, sessionCubit: sessionCubit),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _createAppBar(double width) {
    String title = '';
    setState(() {
      if (_activeIndex == 0) {
        title = 'Register To Park';
      } else if (_activeIndex == 1) {
        title = isResident ? 'Register a Vistor' : 'Update Profile';
      } else if (_activeIndex == 2) {
        title = isManager ? 'Manage Residents' : 'Update Profile';
      } else {
        title = 'Update Profile';
      }
    });

    return AppBar(
      bottom: TabBar(
          controller: _tabController,
          labelPadding: EdgeInsets.symmetric(
              horizontal: isResident
                  ? isManager
                      ? width / 8 - 15
                      : width / 6 - 15
                  : width / 4 - 15),
          isScrollable: true,
          tabs: [
            Tab(
              icon: Icon(Icons.create_rounded, color: Colors.white),
            ),
            if (isResident)
              Tab(
                icon: Icon(Icons.people, color: Colors.white),
              ),
            if (isManager)
              Tab(
                icon: Icon(
                  Icons.perm_contact_cal_sharp,
                  color: Colors.white,
                ),
              ),
            Tab(
              icon: Icon(Icons.person, color: Colors.white),
            ),
          ]),
      actions: const [
        // IconButton(
        //   icon: Icon(Icons.person),
        //   onPressed: () {
        //     Navigator.of(context)
        //         .push(MaterialPageRoute(
        //             builder: (context) =>
        //                 NewUser(user: user, sessionCubit: sessionCubit)))
        //         .then((obj) {
        //       if (obj != null) {
        //         userManager.updateUser(obj);
        //       }
        //     });
        //   },
        // )
      ],
      leading: IconButton(
        icon: Icon(Icons.logout),
        onPressed: () => BlocProvider.of<SessionCubit>(context).signOut(),
      ),
      backgroundColor: Colors.blue,
      title: Text(title),
      shadowColor: Colors.black54,
    );
  }

  // void _showActionSheet(BuildContext context) {
  //   // var userDeleted = false;

  //   showCupertinoModalPopup<void>(
  //       context: context,
  //       builder: (BuildContext modalContext) => CupertinoActionSheet(
  //             title: Text(
  //               'Delete User?',
  //               style: TextStyle(fontSize: 20, color: Colors.red),
  //             ),
  //             message: Text(
  //               'Are you sure you want to delete your profile and logout?',
  //               style: TextStyle(fontSize: 16),
  //             ),
  //             actions: [
  //               CupertinoActionSheetAction(
  //                 onPressed: () async {
  //                   userManager.deleteUser(user);
  //                   // user = null;
  //                   Navigator.of(modalContext).pop();
  //                   BlocProvider.of<SessionCubit>(context).signOut();
  //                   Navigator.of(context).pop();
  //                 },
  //                 isDestructiveAction: true,
  //                 child: Text('Delete'),
  //               )
  //             ],
  //             cancelButton: CupertinoActionSheetAction(
  //               onPressed: (() {
  //                 Navigator.pop(modalContext);
  //               }),
  //               child: Text('Cancel'),
  //             ),
  //           ));
  //   // if (userDeleted == true) {
  //   //   print('✅ USER DELETED TRUE');
  //   //   BlocProvider.of<SessionCubit>(context).signOut();
  //   //   Navigator.of(context).pop();
  //   // }
  // }

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
      await sessionCubit.preferences.then((SharedPreferences prefs) {
        updatedPlates = prefs.getStringList('plates') ?? [];
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
      //TODO: show alert
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
                                style: ElevatedButton.styleFrom(),
                                // backgroundColor: Colors.green),
                                onPressed: () {},
                                child: CheckboxListTile(
                                  title: Text(
                                    plate,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
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
              sessionCubit.addLocation(propertyID);

              previousProperties =
                  sessionCubit.preferences.then((SharedPreferences prefs) {
                var locations = prefs.getStringList('locations') ?? [];
                if (locations.isNotEmpty) {
                  _selectedAddressID = locations[0];
                  _selectedproperty = sessionCubit.properties?.firstWhere(
                      (element) => element.propertyID2 == locations[0]);
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
                            listOfaddressIds!.contains(element.propertyID2))
                        .toList();
                  } catch (e) {
                    // ignore: avoid_print
                    print('error gettings list of address: $e');
                  }

                  if (listOfAddress != null) {
                    if (listOfAddress.isNotEmpty) {
                      var listOfAddressTiles = listOfAddress
                          .map((address) => Dismissible(
                                background: Container(color: Colors.red),
                                key: Key(address.propertyName!),
                                onDismissed: (direction) {
                                  setState(() {
                                    snapshot.data!.removeWhere(
                                        // ignore: unrelated_type_equality_checks
                                        (element) => element == address.id);
                                    properties?.remove(address);

                                    sessionCubit
                                        .removeLocation(address.propertyID2!);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(),
                                    // backgroundColor: Colors.pu),
                                    onPressed: () {},
                                    child: CheckboxListTile(
                                      title: Text(
                                        address.propertyAddress!,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      shape: RoundedRectangleBorder(),
                                      value: _selectedAddressID ==
                                          address.propertyID2,
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
                                ),
                              ))
                          .toList();

                      return Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          children: [
                            // SizedBox(
                            //   width: double.infinity,
                            //   child: Text(
                            //     'Select Location:',
                            //     textAlign: TextAlign.left,
                            //     style: TextStyle(
                            //         fontSize: 22,
                            //         fontWeight: FontWeight.w400,
                            //         color: Colors.white),
                            //   ),
                            // ),
                            SizedBox(
                              height: 120,
                              child: ListView(children: listOfAddressTiles),
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
      onPressed: () => _submitPressed(),
      child: Text(
        '  Submit  ',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  SelfRegistration createExemption() {
    var selfRegistration = SelfRegistration.def();
    selfRegistration.regDate = DateTime.now().toUtc();
    selfRegistration.plateID = _selectedLicensePlate;
    selfRegistration.propertyID = _selectedAddressID;
    selfRegistration.startDate = DateTime.now().toUtc();
    selfRegistration.endDate =
        DateTime.now().add(Duration(days: _selectedDuration)).toUtc();
    selfRegistration.unitNumber = ''; //TODO
    selfRegistration.email = user.email;
    selfRegistration.phone = user.homePhone;
    selfRegistration.name = '${user.firstName} ${user.lastName}';
    selfRegistration.makeModel = '';
    selfRegistration.numberOfDays = '$_selectedDuration';
    selfRegistration.reason = 'guests';
    selfRegistration.notes = '';
    selfRegistration.authBy = '';
    selfRegistration.isArchived = '';

    var splitAddress = _selectedproperty?.propertyAddress?.split(',');

    selfRegistration.streetNumber = splitAddress?[0] ?? '0';
    selfRegistration.streetName = 'test';
    selfRegistration.streetSuffix = ''; //TODO
    selfRegistration.address =
        _selectedproperty?.propertyAddress ?? 'Error getting addresss';

    // var exemption = Exemption.def();
    // exemption.name = '${user.firstName} ${user.lastName}';
    // exemption.email = user.email;
    // exemption.phone = user.homePhone;
    // exemption.plateNumber = _selectedLicensePlate;
    // exemption.streetNumber = unitController.text;
    // exemption.streetName = streetController.text;
    // exemption.requestedDays = _selectedDuration;
    // exemption.municipality = cityController.text;
    // exemption.created = DateTime.now().toUtc();
    // exemption.reason = 'guests';

    return selfRegistration;
  }

  _submitPressed() {
    _addNewLicensePlate(_selectedLicensePlate);

    final exemption = createExemption();
    // var propertyID = sessionCubit.checkIfValidProperty(
    //     cityController.text.toLowerCase(), streetController.text.toLowerCase());

    if (_selectedAddressID != '' && _selectedLicensePlate != '') {
      exemptionManager.createExemptionRequest(exemption);

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

  void openDialog(BuildContext context, String dialogTitle, stringContent,
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
