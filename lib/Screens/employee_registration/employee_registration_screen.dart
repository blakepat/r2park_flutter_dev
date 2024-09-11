import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/Managers/helper_functions.dart';
import 'package:r2park_flutter_dev/Managers/validation_manager.dart';
import 'package:r2park_flutter_dev/Screens/CustomViews/gradient_button.dart';
import 'package:r2park_flutter_dev/Screens/Initial/initial.dart';
import 'package:r2park_flutter_dev/Screens/Initial/terms_and_conditions.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:r2park_flutter_dev/Screens/auth/login/login.dart';
import 'package:r2park_flutter_dev/models/database_response_message.dart';
import 'package:r2park_flutter_dev/models/employee_registration.dart';
import 'package:r2park_flutter_dev/models/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeRegistrationScreen extends StatefulWidget {
  final SessionCubit sessionCubit;
  @override
  // ignore: no_logic_in_create_state
  EmployeeRegistrationScreenState createState() =>
      EmployeeRegistrationScreenState(sessionCubit: sessionCubit);

  const EmployeeRegistrationScreen({super.key, required this.sessionCubit});
}

class EmployeeRegistrationScreenState
    extends State<EmployeeRegistrationScreen> {
  final SessionCubit sessionCubit;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController plateController = TextEditingController();
  TextEditingController accessCodeController = TextEditingController();
  var _plateProvince = 'ON';

  List<String> streetAddresses = [];

  final secondaryColor = Colors.green[900]!;
  int _selectedDuration = 1;
  String formFailedValidationMessage = '';
  bool agreedToTermsAndConditions = false;
  bool selectedFromList = false;

  ScrollController scrollController = ScrollController();

  final _nameKey = 'initialName';
  final _emailKey = 'initialEmail';
  final _phoneKey = 'initialPhone';
  final _plateKey = 'initialPlate';
  final _plateProvKey = 'initialPlateProvince';

  final Uri _url = Uri.parse('https://support.r2park.ca');

  var databaseManager = DatabaseManager();
  SharedPreferences? _prefs;

  EmployeeRegistrationScreenState({required this.sessionCubit});

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
    _plateProvince = _prefs?.getString(_plateProvKey) ?? 'ON';
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: statusBarStyle,
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
                onPressed: _visitorPressed,
                child: Text(
                  'Visitor',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
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
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Stack(
                children: [
                  Container(color: backgroundBlueGreyColor),
                  CustomPaint(
                    painter:
                        WaveCustomPaint(backgroundColor: backgroundGreyColor),
                    size: Size.infinite,
                  ),
                  Column(
                    children: [
                      _createInfoView(),
                      Expanded(
                        child: ListView(children: [
                          _createNameField(),
                          _createEmailField(),
                          _createPhoneField(),
                          _createDivider(),
                          _createAccessCodeField(),
                          _createDivider(),
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
                          _durationInput(
                              height: screenHeight, width: screenWidth),
                          // _createTermsAndConditionsText(),
                          _createTermsAndConditionsCheckbox(),
                          _createReadTermsAndConditionsButton(),
                          _submitButton(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: _createDivider(),
                          ),
                          _footerTextView(),
                          _createClearButton()
                        ]),
                      ),
                    ],
                  ),
                  _createSupportButton(),
                ],
              )),
        ));
  }

  // Future<void> _launchInBrowser(Uri url) async {
  //   if (!await launchUrl(
  //     url,
  //     mode: LaunchMode.externalApplication,
  //   )) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

  Future<void> _launchInBrowserView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _createSupportButton() {
    return Column(
      children: [
        Spacer(),
        Row(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  _launchInBrowserView(_url);
                },
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(side: BorderSide(color: Colors.white)),
                  padding: EdgeInsets.all(20),
                  backgroundColor: Colors.green, // <-- Button color
                  foregroundColor: Colors.red,
                  // <-- Splash color
                ),
                child: Icon(Icons.support_agent, color: Colors.white),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _createInfoView() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: tertiaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              alignment: Alignment.center,
              // padding: EdgeInsets.fromLTRB(32, 0, 10, 0),
              child: Text('Employee Registration',
                  style: GoogleFonts.montserrat(fontSize: 28))),
        ));
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

  Widget _createAccessCodeField() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [UpperCaseTextFormatter()],
        controller: accessCodeController,
        decoration: textFieldDecoration(
            icon: Icons.numbers_outlined, labelName: 'Access Code'),
      ),
    );
  }

  Widget _createPlateField() {
    return Expanded(
      flex: 5,
      child: TextField(
        controller: plateController,
        inputFormatters: [UpperCaseTextFormatter()],
        decoration:
            textFieldDecoration(icon: Icons.abc, labelName: 'Licence Plate'),
      ),
    );
  }

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
            fillColor: Colors.black12,
            filled: true,
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

  Widget _createTermsAndConditionsCheckbox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black26,
            border: Border.all(color: Colors.white30),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: CheckboxListTile(
            title: Text('Agree to Terms and Conditions'),
            value: agreedToTermsAndConditions,
            onChanged: (newValue) {
              setState(() {
                agreedToTermsAndConditions = newValue!;
              });
              logFormsForErrorChecking();
            }),
      ),
    );
  }

  Widget _createReadTermsAndConditionsButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
      child: TextButton(
        child: Text('Terms and Conditions'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TermsAndConditionsPage()));
        },
      ),
    );
  }

  void logFormsForErrorChecking() async {
    if (nameController.text != '' &&
            emailController.text != '' &&
            phoneController.text != '' &&
            plateController.text != ''

        // _exemptionRequestProperty != null
        ) {
      Registration log = createLog();
      await databaseManager.createLog(log);
    }
  }

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
    return Divider(
      color: Colors.grey[600],
      indent: 40,
      endIndent: 40,
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

    _resetInterface();
  }

  _visitorPressed() {
    Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (context) => Initial(
            sessionCubit: sessionCubit,
          ),
        ))
        .then((value) => getPreferences());
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
  }

  EmployeeRegistration createRegistration() {
    var registration = EmployeeRegistration.def();

    registration.full_name = nameController.text.trim();
    registration.email = emailController.text.trim();
    registration.phone =
        phoneController.text.trim().replaceAll('-', '').replaceAll(' ', '');
    registration.access_code = accessCodeController.text.trim();
    registration.plate_number = plateController.text.trim();
    registration.province = _plateProvince;

    return registration;
  }

  Registration createLog() {
    var registration = Registration.log();

    registration.name = nameController.text.trim();
    registration.email = emailController.text.trim();
    registration.phone =
        phoneController.text.trim().replaceAll('-', '').replaceAll(' ', '');
    registration.streetNumber = '';
    registration.plateNumber = plateController.text.isEmpty
        ? registration.plateNumber
        : plateController.text.trim();
    registration.province = _plateProvince;
    registration.duration = _selectedDuration.toString();
    registration.createdAt = DateTime.now().toUtc();

    return registration;
  }

  _verifyLicencePlate() {
    if (plateController.text == '') {
      return;
    } else {
      if (isValidPlate(
          plateController.text.toUpperCase().replaceAll(' ', ''))) {
        formFailedValidationMessage = sessionCubit.isPlateBlacklisted(
                licencePlate: plateController.text) ??
            '';
      } else {
        formFailedValidationMessage +=
            "Licence Plate contains invalid characters";
      }
    }
  }

  _verifyForm() {
    formFailedValidationMessage += validateEmail(emailController.text.trim());
    formFailedValidationMessage += validateName(nameController.text.trim());
    formFailedValidationMessage +=
        validateMobile(phoneController.text.trim().replaceAll('-', ''));
    formFailedValidationMessage +=
        validateTermsAndConditions(agreedToTermsAndConditions);
  }

  _resetInterface() {
    setState(() {
      nameController.text = '';
      emailController.text = '';
      phoneController.text = '';
      plateController.text = '';
      _plateProvince = 'ON';
      agreedToTermsAndConditions = false;
    });
  }

  _submitPressed() async {
    _verifyLicencePlate();
    _verifyForm();

    if (formFailedValidationMessage.isNotEmpty) {
      openDialog(
          context,
          'Request Unsuccessful',
          // ignore: unnecessary_string_interpolations
          '$formFailedValidationMessage',
          '$formFailedValidationMessage');
    } else {
      if (nameController.text != '' &&
              emailController.text != '' &&
              phoneController.text != '' &&
              plateController.text != ''

          // _exemptionRequestProperty != null
          ) {
        if (accessCodeController.text != '') {
          _storeInfoPreferences();
          final exemption = createRegistration();
          final response =
              await databaseManager.createEmployeeRegistration(exemption);

          openDialog(context, '✅ Response', response, response);

          // if (databaseResponseMessage.message ==
          //         "Visitor Parking Registration Granted" ||
          //     databaseResponseMessage.message ==
          //         "Visitor Parking Registration Denied") {
          //   _resetInterface();
          // }
        } else {
          openDialog(
              context,
              'Invalid Street Address',
              'Please try again and enter correctly the address!',
              'Please try again and enter correctly the address!');
        }
      } else {
        openDialog(
            context,
            'One or more forms left blank',
            'Please ensure you have filled out all forms correctly',
            'Please ensure you have filled out all forms correctly');
      }
    }
  }
}

// class UpperCaseTextFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     return TextEditingValue(
//       text: newValue.text.toUpperCase(),
//       selection: newValue.selection,
//     );
//   }
// }

// class _WaveCustomPaint extends CustomPainter {
//   Color backgroundColor;
//   _WaveCustomPaint({required this.backgroundColor});

//   @override
//   void paint(Canvas canvas, Size size) {
//     var painter = Paint()
//       ..color = backgroundColor
//       ..strokeWidth = 1
//       ..style = PaintingStyle.fill;
//     var path = Path();
//     var height = size.height;
//     var width = size.width;

//     path.moveTo(0, height / 3 + height / 5);
//     var des1 = width / 4;
//     var des2 = height / 3 + height / 10; //height/5 /2
//     path.quadraticBezierTo(des1, des2, width / 2, height / 3 + height / 10);
//     path.quadraticBezierTo(
//         width / 2 + width / 4, height / 3 + height / 10, width, height / 3);
//     path.lineTo(width, height);
//     path.lineTo(0, height);
//     path.lineTo(0, height / 3 + height / 5);
//     path.close();
//     canvas.drawPath(path, painter);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
