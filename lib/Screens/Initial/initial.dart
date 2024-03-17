import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/Managers/helper_functions.dart';
import 'package:r2park_flutter_dev/Screens/CustomViews/gradient_button.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:r2park_flutter_dev/Screens/auth/login/login.dart';
import 'package:r2park_flutter_dev/models/property.dart';
import 'package:r2park_flutter_dev/models/exemption.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // TextEditingController plateProvinceController = TextEditingController();
  var _plateProvince = 'ON';

  final secondaryColor = Colors.green[900]!;
  int _selectedDuration = 1;
  Property? _exemptionRequestProperty;
  Property? _previousProperty;
  String? unauthorizedPlateMessage;

  final _nameKey = 'initialName';
  final _emailKey = 'initialEmail';
  final _phoneKey = 'initialPhone';
  final _plateKey = 'initialPlate';
  final _plateProvKey = 'initialPlateProvince';
  final _propertyIDKey = 'initialPropertyID';
  final _unitNumberKey = 'initialUnitNumber';

  var databaseManager = DatabaseManager();
  SharedPreferences? _prefs;

  InitialState({required this.sessionCubit});

  @override
  void initState() {
    super.initState();
    getPreferences();
  }

  void getPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    nameController.text = _prefs?.getString(_nameKey) ?? '';
    emailController.text = _prefs?.getString(_emailKey) ?? '';
    phoneController.text = _prefs?.getString(_phoneKey) ?? '';
    plateController.text = _prefs?.getString(_plateKey) ?? '';
    unitController.text = _prefs?.getString(_unitNumberKey) ?? '';
    _plateProvince = _prefs?.getString(_plateProvKey) ?? 'ON';

    final propertyID = _prefs?.getString(_propertyIDKey);
    if (propertyID != null) {
      setState(() {
        _previousProperty = sessionCubit.getPropertyFromID(propertyID);
      });
    }
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
            child: Hero(
              tag: 'logo',
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
                      // _createPlateProvinceField()
                      _createPlateProvinceDropDownMenu()
                    ],
                  ),
                ),
                _createPreviousPropertyView(),
                _durationInput(height: screenHeight, width: screenWidth),
                _submitButton(),
                _createDivider(),
                _footerTextView(),
                _createClearButton()
              ])),
        ));
  }

  Widget _createInfoView() {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            padding: EdgeInsets.fromLTRB(32, 0, 10, 0),
            child: Text('Register your vehicle:',
                style: GoogleFonts.montserrat(fontSize: 32))));
  }

  Widget _createNameField() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextField(
        controller: nameController,
        decoration: textFieldDecoration(icon: Icons.person, labelName: 'Name'),
      ),
    );
  }

  Widget _createEmailField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: emailController,
        decoration: textFieldDecoration(icon: Icons.email, labelName: 'Email'),
      ),
    );
  }

  Widget _createPhoneField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: phoneController,
        decoration: textFieldDecoration(icon: Icons.phone, labelName: 'Phone'),
      ),
    );
  }

  Widget _createCityField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: cityController,
        decoration: textFieldDecoration(
            icon: Icons.location_city_rounded, labelName: 'City'),
      ),
    );
  }

  Widget _createUnitField() {
    return Expanded(
      flex: 1,
      child: TextField(
        controller: unitController,
        decoration: textFieldDecoration(icon: Icons.numbers, labelName: 'Unit'),
      ),
    );
  }

  Widget _createAddressField() {
    return Expanded(
      flex: 2,
      child: TextField(
        controller: addressController,
        decoration:
            textFieldDecoration(icon: Icons.location_on, labelName: 'Address'),
      ),
    );
  }

  Widget _createPlateField() {
    return Expanded(
      flex: 5,
      child: TextField(
        controller: plateController,
        decoration: textFieldDecoration(
            icon: IconData(0xe1d7, fontFamily: 'MaterialIcons'),
            labelName: 'Licence Plate'),
      ),
    );
  }

  // Widget _createPlateProvinceField() {
  //   return Expanded(
  //     flex: 4,
  //     child: TextField(
  //       maxLength: 2,
  //       controller: plateProvinceController,
  //       decoration: InputDecoration(
  //           counterText: "",
  //           border: OutlineInputBorder(),
  //           labelText: 'Plate Prov. (ON, AB)',
  //           labelStyle: kInitialTextLabelStyle,
  //           icon: Icon(Icons.sort_by_alpha_rounded)),
  //     ),
  //   );
  // }

  Widget _createPlateProvinceDropDownMenu() {
    return Expanded(
        flex: 3,
        child: DropdownButtonFormField(
          hint: Text(
            "Plate Prov.",
            style: kInitialTextLabelStyle,
          ),
          // alignment: Alignment.center,
          decoration: InputDecoration(
            labelText: "Plate Province",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 2, color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(width: 2, color: Colors.green),
            ),
          ),
          menuMaxHeight: 400,
          dropdownColor: Colors.blueGrey,
          items: statesAndProvinces,
          value: _plateProvince,
          onChanged: dropdownCallback,
        ));
  }

  void dropdownCallback(dynamic selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _plateProvince = selectedValue;
      });
    }
  }

  Widget _createPreviousPropertyView() {
    if (_previousProperty != null) {
      return Container(
        padding: EdgeInsets.all(4),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CheckboxListTile(
            tileColor: Colors.black26,
            checkboxShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                    color: Colors.green, style: BorderStyle.solid, width: 2)),
            title: Text(
              _previousProperty?.propertyAddress ?? '',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                    color: Colors.green, style: BorderStyle.solid, width: 4)),
            value: _exemptionRequestProperty == _previousProperty,
            onChanged: (newValue) {
              if (newValue != null) {
                newValue
                    ? setState(
                        () => _exemptionRequestProperty = _previousProperty)
                    : setState(() => _exemptionRequestProperty = null);
              }
            },
          ),
        ),
      );
    } else {
      return SizedBox();
    }
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

  // Widget _submitButton() {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
  //     child: Directionality(
  //       textDirection: TextDirection.rtl,
  //       child: Stack(
  //         children: [ElevatedButton.icon(
  //           style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
  //           onPressed: () => _submitPressed(),
  //           label: Text(
  //             '  Submit  ',
  //             style: TextStyle(color: Colors.white, fontSize: 18),
  //           ),
  //           icon: Icon(
  //             Icons.arrow_back_ios,
  //             color: Colors.white,
  //           ),

  //         ),
  //       ]),
  //     ),
  //   );
  // }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GradientButton(
        onPressed: () => _submitPressed(),
        borderRadius: BorderRadius.circular(20),
        child: Text(
          'Submit',
          style: kButtonTextStyle,
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

  Widget _createClearButton() {
    return TextButton(
        onPressed: () => _clearPressed(), child: Text('Clear saved data'));
  }

  _clearPressed() {
    _prefs?.remove(_nameKey);
    _prefs?.remove(_emailKey);
    _prefs?.remove(_phoneKey);
    _prefs?.remove(_plateKey);
    _prefs?.remove(_plateProvKey);
    _prefs?.remove(_propertyIDKey);
    _prefs?.remove(_unitNumberKey);
    _resetInterface();
    setState(() {
      _exemptionRequestProperty = null;
      _previousProperty = null;
    });
  }

  _loginPressed() {
    Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (context) => Login(
            sessionCubit: sessionCubit,
          ),
        ))
        .then((value) => getPreferences());
  }

  _storeInfoPreferences() {
    _prefs?.setString(_nameKey, nameController.text);
    _prefs?.setString(_emailKey, emailController.text);
    _prefs?.setString(_phoneKey, phoneController.text);
    _prefs?.setString(_plateKey, plateController.text);
    _prefs?.setString(_plateProvKey, _plateProvince);
    _prefs?.setString(_unitNumberKey, unitController.text);
  }

  Exemption createExemption() {
    var selfRegistration = Exemption.def();
    selfRegistration.regDate = DateTime.now().toUtc();
    selfRegistration.plateID =
        '${plateController.text.toUpperCase().replaceAll(' ', '')}_${_plateProvince}';
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
        _prefs?.setString(_propertyIDKey, propertyID);
      });
    }
  }

  // _verifyProvince() {
  //   if (!isValidProvince(plateProvinceController.text)) {
  //     unauthorizedPlateMessage = "Province is invalid";
  //   }
  // }

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
      _plateProvince = 'ON';
      _exemptionRequestProperty = null;
    });
  }

  _submitPressed() {
    if (_exemptionRequestProperty == null) {
      _verifyAddress();
    }

    _verifyLicencePlate();
    // _verifyProvince();

    if (unauthorizedPlateMessage != null) {
      openDialog(context, 'Request Unsuccessful', '$unauthorizedPlateMessage',
          '$unauthorizedPlateMessage');
    } else {
      if (nameController.text != '' &&
          emailController.text != '' &&
          phoneController.text != '' &&
          plateController.text != '' &&
          _exemptionRequestProperty != null) {
        _storeInfoPreferences();
        final exemption = createExemption();
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
