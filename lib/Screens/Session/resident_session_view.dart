import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:r2park_flutter_dev/models/property.dart';
import 'package:r2park_flutter_dev/models/visitor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Managers/exemption_request_manager.dart';
import '../../main.dart';
import '../../models/self_registration.dart';
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

  var exemptionManager = ExemptionRequestManager();

  late Future<List<Visitor>> visitors;
  Visitor? _selectedVisitor;

  ResidentSessionScreen({
    required this.user,
    required this.sessionCubit,
  });

  @override
  void initState() {
    super.initState();
    residence = sessionCubit.properties?.firstWhere(
        (element) => element.propertyID2 == user.clientDisplayName);

    visitors = sessionCubit.preferences.then((SharedPreferences prefs) {
      return sessionCubit.getVisitors();
    });
  }

  @override
  Widget build(BuildContext context) {
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
            _durationInput(),
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
                            key: Key(visitor.firstName),
                            onDismissed: (direction) {
                              setState(() {
                                snapshot.data!.removeWhere(
                                    (element) => element == visitor);
                                // sessionCubit.updateLicensePlates(
                                //     plates: snapshot.data!, user: user);
                              });
                            },
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: secondaryColor),
                              onPressed: () {},
                              child: CheckboxListTile(
                                title: Text(
                                  '${visitor.firstName.toUpperCase()} ${visitor.lastName.toUpperCase()}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                subtitle: Text(
                                  visitor.plateNumber.toUpperCase(),
                                  style: TextStyle(fontSize: 14),
                                ),
                                shape: RoundedRectangleBorder(),
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
                            child: ListView(children: listOfVisitors),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3 + 22,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3 + 36,
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
            width: MediaQuery.of(context).size.width - 64,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: plateController,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.rectangle_rounded,
                    color: Colors.white,
                  ),
                  hintText: 'License Plate...',
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
          (duration) => SizedBox(
            height: 64,
            width: (MediaQuery.of(context).size.width / 4) - 12,
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
      padding: const EdgeInsets.fromLTRB(6, 24, 6, 10),
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
        ));
  }

  SelfRegistration createExemption() {
    var selfRegistration = SelfRegistration.def();
    selfRegistration.regDate = DateTime.now().toUtc();
    selfRegistration.plateID = _selectedVisitor == null
        ? plateController.text
        : _selectedVisitor?.plateNumber;
    selfRegistration.propertyID = residence!.propertyID2;
    selfRegistration.startDate = DateTime.now().toUtc();
    selfRegistration.endDate =
        DateTime.now().add(Duration(days: _selectedDuration)).toUtc();
    selfRegistration.unitNumber = ''; //TODO
    selfRegistration.email = user.email;
    selfRegistration.phone = user.homePhone;
    selfRegistration.name =
        '${firstNameController.text} ${lastNameController.text}';
    selfRegistration.makeModel = '';
    selfRegistration.numberOfDays = '$_selectedDuration';
    selfRegistration.reason = 'Visiting: ${user.firstName} ${user.lastName}';
    selfRegistration.notes = '';
    selfRegistration.authBy = '';
    selfRegistration.isArchived = '';

    var splitAddress = residence?.propertyAddress?.split(',');

    selfRegistration.streetNumber = splitAddress?[0] ?? '0';
    selfRegistration.streetName = 'test';
    selfRegistration.streetSuffix = ''; //TODO
    selfRegistration.address =
        residence?.propertyAddress ?? 'Error getting addresss';

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
    // _addNewLicensePlate(_selectedLicensePlate);

    final exemption = createExemption();

    if (firstNameController.text != '' &&
            lastNameController.text != '' &&
            plateController.text != '' ||
        _selectedVisitor != null) {
      if (_selectedVisitor == null) {
        var visitor = Visitor(
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            plateNumber: plateController.text);

        sessionCubit.saveVisitor(visitor);
      }

      // print(
      //     '✅ ${residence!.propertyID2}, ${plateController.text} submit pressed!');
      exemptionManager.createExemptionRequest(exemption);
    } else {
      openDialog(
          context,
          'Please select previous visitor or enter complete all 3 fields',
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
}
