import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/Managers/helper_functions.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:r2park_flutter_dev/models/property.dart';
import 'package:r2park_flutter_dev/models/visitor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../models/exemption.dart';
import '../../models/user.dart';

class ResidentSessionView extends StatefulWidget {
  final User user;
  final SessionCubit sessionCubit;

  const ResidentSessionView(
      {super.key, required this.user, required this.sessionCubit});
  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      ResidentSessionScreen(user: user, sessionCubit: sessionCubit);
}

class ResidentSessionScreen extends State<ResidentSessionView> {
  final User user;
  final SessionCubit sessionCubit;
  Property? residence;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final plateController = TextEditingController();
  int _selectedDuration = 1;

  String? unauthorizedPlateMessage;

  var databaseManager = DatabaseManager();

  late Future<List<Visitor>> visitors;
  Visitor? _selectedVisitor;

  ResidentSessionScreen({
    required this.user,
    required this.sessionCubit,
  });

  @override
  void initState() {
    super.initState();
    residence = sessionCubit.properties
        ?.firstWhere((element) => element.propertyID == user.propertyId);

    visitors = sessionCubit.preferences.then((SharedPreferences prefs) {
      return sessionCubit.getVisitors(user: user);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _residenceSummary(),
            _previousVisitorsList(),
            _visitorSummary(),
            Row(
              children: [
                _visitorFirstNameTextForm(),
                _visitorLastNameTextForm(),
              ],
            ),
            _visitorPlateTextForm(),
            _durationInput(height: screenHeight, width: screenWidth),
            _submitButton()
          ],
        ),
      ),
    ));
  }

  Widget _residenceSummary() {
    final addressSplitUp = residence?.propertyAddress?.split(',');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white30),
          color: Colors.black26,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (addressSplitUp != null)
              Text(
                addressSplitUp[0],
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
              ),
            if (addressSplitUp != null)
              Text(
                '${addressSplitUp[1].trim()}, ${residence?.province ?? ''}',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 24),
              ),
          ],
        ),
      ),
    );
  }

  Widget _visitorSummary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          'Visitor Information:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget _previousVisitorsList() {
    return FutureBuilder<List<Visitor>>(
        future: visitors,
        builder: (BuildContext context, AsyncSnapshot<List<Visitor>> snapshot) {
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
                  var listOfVisitors = snapshot.data!
                      .map((visitor) => Dismissible(
                            background: Container(color: Colors.red),
                            key: Key(visitor.name),
                            onDismissed: (direction) {
                              setState(() {
                                snapshot.data!.removeWhere(
                                    (element) => element == visitor);
                                var stringVisitors = snapshot.data
                                    ?.map((e) => "${e.name},${e.plateNumber}")
                                    .toList();
                                sessionCubit.updateVisitors(
                                    visitors: stringVisitors ?? [], user: user);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CheckboxListTile(
                                checkboxShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                tileColor: secondaryColor,
                                title: Text(
                                  '${visitor.name.toUpperCase()}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                subtitle: Text(
                                  visitor.plateNumber.toUpperCase(),
                                  style: TextStyle(fontSize: 14),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                value: _selectedVisitor == visitor,
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    newValue
                                        ? setState(
                                            () => _selectedVisitor = visitor)
                                        : setState(
                                            () => _selectedVisitor = null);
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
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                            child: Text(
                              'Previous Visitors:',
                              // ${_selectedLicensePlate.toUpperCase().trim()}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              border: Border.all(color: Colors.white30),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          height: 180,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                                child: ListView(children: listOfVisitors)),
                          ),
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

  Widget _visitorFirstNameTextForm() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth < 700 ? 130 : 160,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: firstNameController,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  hintText: 'First Name',
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

  Widget _visitorLastNameTextForm() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth < 700 ? 180 : 220,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: lastNameController,
              decoration: InputDecoration(
                  //     icon: Icon(
                  //       Icons.person_2_outlined,
                  //       color: Colors.white,
                  //     ),

                  hintText: 'Last Name',
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

  Widget _visitorPlateTextForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 300,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: plateController,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.rectangle_rounded,
                    color: Colors.white,
                  ),
                  hintText: 'License Plate',
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

  Widget _durationInput({required double height, required double width}) {
    final durationsList = [1, 2, 3, 4]
        .map(
          (duration) => SizedBox(
            height: 64,
            width: width < 700 ? width / 4 : 90,
            child: Container(
              alignment: Alignment.centerLeft,
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
          ),
        )
        .toList();
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black26,
              border: Border.all(color: Colors.white30),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Days Requested:',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                ),
              ),
              FittedBox(
                  child: Row(
                      mainAxisSize: MainAxisSize.min, children: durationsList)),
            ],
          ),
        ));
  }

  // Widget _durationInput() {
  //   final durationsList = [1, 2, 3, 4]
  //       .map(
  //         (duration) => SizedBox(
  //           height: 64,
  //           width: 90,
  //           child: CheckboxListTile(
  //             checkColor: Colors.red,
  //             activeColor: Colors.white,
  //             title: Text(
  //               duration.toString(),
  //               style: TextStyle(color: Colors.white),
  //             ),
  //             value: duration == _selectedDuration,
  //             onChanged: (newValue) => setState(() {
  //               if (newValue != null) {
  //                 _selectedDuration = duration;
  //               }
  //             }),
  //           ),
  //         ),
  //       )
  //       .toList();
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(6, 24, 6, 10),
  //     child: Column(
  //       children: [
  //         SizedBox(
  //           width: double.infinity,
  //           child: Padding(
  //             padding: const EdgeInsets.all(4.0),
  //             child: Text(
  //               'Days Requested:',
  //               textAlign: TextAlign.left,
  //               style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.w400,
  //                   color: Colors.white),
  //             ),
  //           ),
  //         ),
  //         Row(children: durationsList),
  //       ],
  //     ),
  //   );
  // }

  Widget _submitButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
        onPressed: () => _submitPressed(),
        child: Text(
          '  Submit  ',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ));
  }

  Exemption createExemption() {
    var selfRegistration = Exemption.def();
    selfRegistration.regDate = DateTime.now().toUtc();
    selfRegistration.plateID = _selectedVisitor == null
        ? plateController.text.toUpperCase().replaceAll(' ', '')
        : _selectedVisitor?.plateNumber;
    selfRegistration.propertyID = residence!.propertyID2;
    selfRegistration.startDate = DateTime.now().toUtc();
    selfRegistration.endDate =
        DateTime.now().add(Duration(days: _selectedDuration)).toUtc();
    selfRegistration.unitNumber = '';
    selfRegistration.email = user.email;
    selfRegistration.phone = user.mobileNumber;
    selfRegistration.name =
        '${firstNameController.text} ${lastNameController.text}';
    selfRegistration.makeModel = '';
    selfRegistration.numberOfDays = '$_selectedDuration';
    selfRegistration.reason = 'Visiting: ${user.fullName}';
    selfRegistration.notes = '';
    selfRegistration.authBy = '';
    selfRegistration.isArchived = '';

    var splitAddress = residence?.propertyAddress?.split(',');

    selfRegistration.streetNumber = splitAddress?[0] ?? '0';
    selfRegistration.streetName = 'test';
    selfRegistration.streetSuffix = '';
    selfRegistration.address =
        residence?.propertyAddress ?? 'Error getting addresss';

    return selfRegistration;
  }

  _verifyLicencePlate() async {
    if (_selectedVisitor != null) {
      unauthorizedPlateMessage = sessionCubit.isPlateBlacklisted(
          licencePlate: _selectedVisitor!.plateNumber);
    } else {
      unauthorizedPlateMessage =
          sessionCubit.isPlateBlacklisted(licencePlate: plateController.text);
    }
  }

  _resetTextFields() {
    setState(() {
      firstNameController.text = "";
      lastNameController.text = "";
      plateController.text = "";
    });
  }

  _submitPressed() {
    //check to see if licence plate is blacklisted (either selected previous visitor or entered licence plate)
    _verifyLicencePlate();
    if (unauthorizedPlateMessage != null) {
      openDialog(context, 'Request Unsuccessful', '$unauthorizedPlateMessage',
          '$unauthorizedPlateMessage');
      // if licence plate is confirmed has NOT blacklisted continue process
    } else {
      //if its a previous visitor licence plate has already been verified, create exemption
      if (_selectedVisitor != null) {
        final exemption = createExemption();
        databaseManager.createExemption(exemption);
        openDialog(
            context,
            '✅ Registration Successful',
            'Your guest ${_selectedVisitor!.name}, ${_selectedVisitor!.plateNumber} has been successfully registered!',
            'Your guest ${_selectedVisitor!.name}, ${_selectedVisitor!.plateNumber} has been successfully registered!');
        _resetTextFields();
      } else {
        //if not a previous visitor check licence plate
        if (isValidPlate(plateController.text.toUpperCase().trim())) {
          final exemption = createExemption();
          //ensure form is filled out properly
          if (firstNameController.text != '' &&
              lastNameController.text != '' &&
              plateController.text != '') {
            //if filled out correctly save visitor for future registrations
            var visitor = Visitor(
                name:
                    "${firstNameController.text.trim()} ${lastNameController.text.trim()}",
                plateNumber:
                    plateController.text.toUpperCase().replaceAll(' ', ''));
            sessionCubit.saveVisitor(visitor: visitor, user: user);
            //create exemption!
            databaseManager.createExemption(exemption);

            openDialog(
                context,
                '✅ Registration Successful',
                'Your guest ${firstNameController.text} ${lastNameController.text}, ${plateController.text.toUpperCase().trim()} has been successfully registered!',
                'Your guest ${firstNameController.text} ${lastNameController.text}, ${plateController.text.toUpperCase().trim()} has been successfully registered!');
            _resetTextFields();
          } else {
            openDialog(
                context,
                'Please select previous visitor or enter complete all 3 fields',
                'Please ensure you have selected an address and licence plate',
                'Please ensure you have selected an address and licence plate');
          }
        } else {
          openDialog(
              context,
              'Licence Plate invalid',
              'Please double check licence plate and try again',
              'Please double check licence plate and try again');
        }
      }
    }
  }
}
