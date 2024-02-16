import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/Managers/helper_functions.dart';
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
  TextEditingController plateProvinceController = TextEditingController();

  final secondaryColor = Colors.green[900]!;
  int _selectedDuration = 1;
  Property? _exemptionRequestProperty;
  String? unauthorizedPlateMessage;

  var databaseManager = DatabaseManager();

  InitialState({required this.sessionCubit});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          leadingWidth: 180,
          toolbarHeight: 80,
          leading: Transform.scale(
            scale: 1.6,
            child: Padding(
              padding: const EdgeInsets.only(left: 28),
              child: Image.asset(
                'assets/images/3DLogo.png',
                fit: BoxFit.contain,
                height: 180,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: _loginPressed,
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ))
          ],
        ),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: ListView(children: [
                _createInfoView(),
                _createNameField(),
                _createEmailField(),
                _createPhoneField(),
                _createCityField(),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(children: [
                    _createUnitField(),
                    SizedBox(width: 12),
                    _createAddressField(),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      _createPlateField(),
                      SizedBox(width: 12),
                      _createPlateProvinceField()
                    ],
                  ),
                ),
                _durationInput(height: screenHeight, width: screenWidth),
                _submitButton(),
                _createDivider(),
                _footerTextView()
              ])),
        ));
  }

  Widget _createInfoView() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.fromLTRB(32, 0, 10, 0),
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
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Name',
            labelStyle: kInitialTextLabelStyle,
            icon: Icon(Icons.person)),
      ),
    );
  }

  Widget _createEmailField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: emailController,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Email',
            labelStyle: kInitialTextLabelStyle,
            icon: Icon(Icons.email)),
      ),
    );
  }

  Widget _createPhoneField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: phoneController,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Phone',
            labelStyle: kInitialTextLabelStyle,
            icon: Icon(Icons.phone)),
      ),
    );
  }

  Widget _createCityField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: cityController,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'City',
            labelStyle: kInitialTextLabelStyle,
            icon: Icon(Icons.location_city_rounded)),
      ),
    );
  }

  Widget _createUnitField() {
    return Expanded(
      flex: 1,
      child: TextField(
        controller: unitController,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Unit',
            labelStyle: kInitialTextLabelStyle,
            icon: Icon(Icons.numbers)),
      ),
    );
  }

  Widget _createAddressField() {
    return Expanded(
      flex: 2,
      child: TextField(
        controller: addressController,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Address',
            labelStyle: kInitialTextLabelStyle,
            icon: Icon(Icons.location_on)),
      ),
    );
  }

  Widget _createPlateField() {
    return Expanded(
      flex: 5,
      child: TextField(
        controller: plateController,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Licence Plate',
            labelStyle: kInitialTextLabelStyle,
            icon: Icon(Icons.rectangle_rounded)),
      ),
    );
  }

  Widget _createPlateProvinceField() {
    return Expanded(
      flex: 4,
      child: TextField(
        maxLength: 2,
        controller: plateProvinceController,
        decoration: InputDecoration(
            counterText: "",
            border: OutlineInputBorder(),
            labelText: 'Plate Prov. (ON, AB)',
            labelStyle: kInitialTextLabelStyle,
            icon: Icon(Icons.sort_by_alpha_rounded)),
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
        padding: const EdgeInsets.fromLTRB(8, 10, 4, 10),
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

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
          onPressed: () => _submitPressed(),
          label: Text(
            '  Submit  ',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _createDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        color: Colors.grey[600],
        indent: 40,
        endIndent: 40,
      ),
    );
  }

  Widget _footerTextView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            alignment: Alignment.center,
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Frequent Visitors: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: kInitialInfoText,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )),
          ),
        ),
        Text('Telephone: 905-873-7100 Ext. 304'),
        Text('Toll Free: 1-800-268-7100 Ext. 304'),
        Text('Fax: 905-873-7311'),
        Text('E-mail: Support@R2Park.ca')
      ],
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
    selfRegistration.plateID =
        '${plateController.text.toUpperCase().replaceAll(' ', '')}_${plateProvinceController.text}';
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

  _verifyProvince() {
    if (!isValidProvince(plateProvinceController.text)) {
      unauthorizedPlateMessage = "Province is invalid";
    }
  }

  _verifyLicencePlate() async {
    if (isValidPlate(plateController.text.toUpperCase().replaceAll(' ', ''))) {
      unauthorizedPlateMessage =
          sessionCubit.isPlateBlacklisted(licencePlate: plateController.text);
    } else {
      unauthorizedPlateMessage = "Licence Plate contains invalid characters";
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
      plateProvinceController.text = '';
      _exemptionRequestProperty = null;
    });
  }

  _submitPressed() {
    _verifyAddress();
    _verifyLicencePlate();
    _verifyProvince();

    if (unauthorizedPlateMessage != null) {
      openDialog(context, 'Request Unsuccessful', '$unauthorizedPlateMessage',
          '$unauthorizedPlateMessage');
    } else {
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
            '✅ Request Submitted Successfully',
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
  }
}
