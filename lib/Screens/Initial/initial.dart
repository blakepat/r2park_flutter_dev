import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:r2park_flutter_dev/Screens/auth/login/login.dart';
import 'package:r2park_flutter_dev/models/property.dart';
import 'package:r2park_flutter_dev/models/exemption.dart';

class Initial extends StatefulWidget {
  final SessionCubit sessionCubit;
  @override
  // ignore: no_logic_in_create_state
  InitialState createState() => InitialState(sessionCubit: sessionCubit);

  const Initial({super.key, required this.sessionCubit});
}

class InitialState extends State<Initial> {
  final SessionCubit sessionCubit;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController plateController = TextEditingController();

  final secondaryColor = Colors.green[900]!;
  int _selectedDuration = 1;
  Property? _exemptionRequestProperty;

  var databaseManager = DatabaseManager();

  InitialState({required this.sessionCubit});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: _loginPressed,
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ))
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: ListView(children: [
              _createLogoView(),
              _createInfoView(),
              _createNameField(),
              _createEmailField(),
              _createPhoneField(),
              _createCityField(),
              Row(children: [
                _createUnitField(),
                _createAddressField(),
              ]),
              _createPlateField(),
              _durationInput(),
              _submitButton(),
            ])));
  }

  Widget _createLogoView() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
      child:
          SizedBox(height: 180, child: Image.asset('assets/images/3DLogo.png')),
    );
  }

  Widget _createInfoView() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.fromLTRB(4, 0, 10, 0),
        child: Text(
          'Register your vehicle:',
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _createNameField() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextField(
        controller: nameController,
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: 'Name'),
      ),
    );
  }

  Widget _createEmailField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: emailController,
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: 'Email'),
      ),
    );
  }

  Widget _createPhoneField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: phoneController,
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: 'Phone'),
      ),
    );
  }

  Widget _createCityField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: cityController,
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: 'City'),
      ),
    );
  }

  Widget _createUnitField() {
    return Container(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: TextField(
            controller: unitController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Unit'),
          ),
        ));
  }

  Widget _createAddressField() {
    return Container(
        padding: EdgeInsets.all(10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width -
              (MediaQuery.of(context).size.width / 2.4),
          child: TextField(
            controller: addressController,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Address'),
          ),
        ));
  }

  Widget _createPlateField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: plateController,
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: 'Plate'),
      ),
    );
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
        onPressed: () => _submitPressed(),
        label: Text(
          '  Submit  ',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        icon: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
      ),
    );
  }

  _loginPressed() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Login(
        sessionCubit: sessionCubit,
      ),
    ));
  }

  Exemption createExemption() {
    var selfRegistration = Exemption.def();
    selfRegistration.regDate = DateTime.now().toUtc();
    selfRegistration.plateID = plateController.text;
    selfRegistration.propertyID = _exemptionRequestProperty?.propertyID2;
    selfRegistration.startDate = DateTime.now().toUtc();
    selfRegistration.endDate =
        DateTime.now().add(Duration(days: _selectedDuration)).toUtc();
    selfRegistration.unitNumber = '';
    selfRegistration.email = emailController.text;
    selfRegistration.phone = phoneController.text;
    selfRegistration.name = nameController.text;
    selfRegistration.makeModel = '';
    selfRegistration.numberOfDays = '$_selectedDuration';
    selfRegistration.reason = 'guests';
    selfRegistration.notes = '';
    selfRegistration.authBy = '';
    selfRegistration.isArchived = '';

    var splitAddress = _exemptionRequestProperty?.propertyAddress?.split(',');

    selfRegistration.streetNumber = splitAddress?[0] ?? '0';
    selfRegistration.streetName = 'test';
    selfRegistration.streetSuffix = '';
    selfRegistration.address =
        _exemptionRequestProperty?.propertyAddress ?? 'Error getting addresss';

    return selfRegistration;
  }

  _verifyAddress() {
    var propertyID = sessionCubit.checkIfValidProperty(
        cityController.text.toLowerCase(),
        addressController.text.toLowerCase());

    if (propertyID != null) {
      setState(() {
        _exemptionRequestProperty = sessionCubit.getPropertyFromID(propertyID);
      });
    }
  }

  _resetInterface() {
    setState(() {
      nameController.text = '';
      emailController.text = '';
      phoneController.text = '';
      cityController.text = '';
      addressController.text = '';
      plateController.text = '';
      unitController.text = '';
      _exemptionRequestProperty = null;
    });
  }

  _submitPressed() {
    _verifyAddress();
    final exemption = createExemption();

    if (nameController.text != '' &&
        emailController.text != '' &&
        phoneController.text != '' &&
        cityController.text != '' &&
        addressController.text != '' &&
        plateController.text != '' &&
        _exemptionRequestProperty != null) {
      databaseManager.createExemption(exemption);

      openDialog(
          context,
          'Requested Submitted Successfully',
          'Thank you for using R2Park! Enjoy your visit!',
          'Thank you for using R2Park! Enjoy your visit!');

      _resetInterface();
    } else {
      openDialog(
          context,
          'Please select Plate and Location',
          'Please ensure you have filled out the address form correctly',
          'Please ensure you have filled out the address form correctly');
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
