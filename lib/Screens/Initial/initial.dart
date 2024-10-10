import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/Managers/helper_functions.dart';
import 'package:r2park_flutter_dev/Managers/validation_manager.dart';
import 'package:r2park_flutter_dev/Screens/CustomViews/gradient_button.dart';
import 'package:r2park_flutter_dev/Screens/Initial/terms_and_conditions.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:r2park_flutter_dev/Screens/auth/login/login.dart';
import 'package:r2park_flutter_dev/Screens/employee_registration/employee_registration_screen.dart';
import 'package:r2park_flutter_dev/models/city.dart';
import 'package:r2park_flutter_dev/models/database_response_message.dart';
import 'package:r2park_flutter_dev/models/property.dart';
import 'package:r2park_flutter_dev/models/registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Initial extends StatefulWidget {
  final SessionCubit sessionCubit;
  final bool showAppBar;
  @override
  // ignore: no_logic_in_create_state
  InitialState createState() =>
      // ignore: no_logic_in_create_state
      InitialState(sessionCubit: sessionCubit, showAppBar: showAppBar);

  const Initial(
      {super.key, required this.sessionCubit, required this.showAppBar});
}

class InitialState extends State<Initial> {
  final SessionCubit sessionCubit;
  final bool showAppBar;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  // TextEditingController streetNumberController = TextEditingController();
  TextEditingController plateController = TextEditingController();
  // TextEditingController plateProvinceController = TextEditingController();
  var _plateProvince = 'ON';
  var _city = 'Choose a City';
  final _focusNode = FocusNode();

  List<String> streetAddresses = [];

  final secondaryColor = Colors.green[900]!;
  int _selectedDuration = 1;
  Property? _exemptionRequestProperty;
  Property? _previousProperty;
  String formFailedValidationMessage = '';
  bool agreedToTermsAndConditions = false;
  bool selectedFromList = false;

  DatabaseResponseMessage databaseResponseMessage =
      DatabaseResponseMessage.def();

  ScrollController scrollController = ScrollController();

  final _nameKey = 'initialName';
  final _emailKey = 'initialEmail';
  final _phoneKey = 'initialPhone';
  final _plateKey = 'initialPlate';
  final _plateProvKey = 'initialPlateProvince';
  final _propertyIDKey = 'initialPropertyID';
  final _unitNumberKey = 'initialUnitNumber';

  final Uri _url = Uri.parse('https://support.r2park.ca');

  var databaseManager = DatabaseManager();
  SharedPreferences? _prefs;

  InitialState({required this.sessionCubit, required this.showAppBar});

  @override
  void initState() {
    super.initState();
    getPreferences();

    if (kIsWeb) {
      var url = Uri.parse(Uri.base.origin);
      WidgetsBinding.instance.addPostFrameCallback((_) => checkIfEmployee(url));
    }
  }

  void checkIfEmployee(Uri url) {
    // print(url);
    if (url.pathSegments.length > 2) {
      var urlType = url.pathSegments[1];
      if (urlType == 'c') {
        _employeePressed();
      }
    }
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
        // _previousProperty = sessionCubit.getPropertyFromID(propertyID);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: (showAppBar
            ? AppBar(
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
                      onPressed: _employeePressed,
                      child: Text(
                        'Employee',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                  TextButton(
                      onPressed: _loginPressed,
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ))
                ],
              )
            : null),
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
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(children: [
                              _createUnitField(),
                              SizedBox(width: 12),
                              _createCityDropDownMenu(),
                            ]),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8),
                          //   child: Row(children: [
                          //     _createStreetNumberField(),
                          //     SizedBox(width: 12),
                          //     _createStreetNameField(),
                          //   ]),
                          // ),
                          Padding(
                              padding: const EdgeInsets.all(8),
                              child: _createAddressField(screenWidth - 100)),
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
                          _createPreviousPropertyView(),
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

  // Future<void> _launchInWebView(Uri url) async {
  //   if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

  // Future<void> _launchInAppWithBrowserOptions(Uri url) async {
  //   if (!await launchUrl(
  //     url,
  //     mode: LaunchMode.inAppBrowserView,
  //     browserConfiguration: const BrowserConfiguration(showTitle: true),
  //   )) {
  //     throw Exception('Could not launch $url');
  //   }
  // }

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
              child: Text('Visitior Registration',
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

  Widget _createCityDropDownMenu() {
    return Expanded(
        flex: 4,
        child: DropdownButtonFormField(
          isExpanded: true,
          hint: Text(
            _city,
            style: kInitialTextLabelStyle,
          ),
          // alignment: Alignment.center,
          decoration: InputDecoration(
            labelText: "City",
            fillColor: Colors.black12,
            filled: true,
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
          items: sessionCubit.cities?.map((city) {
            return DropdownMenuItem(
                value: city, child: Text(city.description ?? ''));
          }).toList(),
          onChanged: cityDropdownCallback,
        ));
  }

  void cityDropdownCallback(City? selectedValue) async {
    _city = selectedValue?.description ?? '';
    streetAddresses = await databaseManager
        .getAddressesForCity(selectedValue?.description ?? '')
        .whenComplete(() => setState(() {
              streetAddresses = streetAddresses;
            }));
    addressController.text = '';
  }

  Widget _createUnitField() {
    return Expanded(
      flex: 2,
      child: TextField(
        controller: unitController,
        decoration: textFieldDecoration(icon: Icons.numbers, labelName: 'Unit'),
      ),
    );
  }

  Widget _createAddressField(double width) {
    return RawAutocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        selectedFromList = false;
        if (textEditingValue.text == '' || textEditingValue.text.length < 3) {
          return const Iterable<String>.empty();
        }

        // var split = textEditingValue.text.toLowerCase().split(' ');
        //
        // List<String> matches = streetAddresses.where((String option) {
        //   return split.every((word) {
        //     return option.toLowerCase().contains(word);
        //   });
        // }).toList();
        // return matches;
        return streetAddresses.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      textEditingController: addressController,
      focusNode: _focusNode,
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
        addressController.text = selection;
        selectedFromList = true;
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController addressController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextField(
          controller: addressController,
          focusNode: focusNode,
          decoration: textFieldDecoration(
              icon: Icons.location_on, labelName: 'Address'),
        );
      },
      optionsViewBuilder: (BuildContext context,
          void Function(String) onSelected, Iterable<String> options) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(36, 0, 0, 0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Material(
              borderRadius: BorderRadius.circular(12),
              elevation: 4.0,
              child: SizedBox(
                height: null,
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  width: min(width, 600),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return GestureDetector(
                        onTap: () {
                          onSelected(option);
                        },
                        child: ListTile(
                          title: Text(option),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
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

  // const IconData(0xe1d7, fontFamily: 'MaterialIcons'),

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

  // Widget _createTermsAndConditionsText() {
  //   return Column(
  //     children: [
  //       Row(
  //         children: const [
  //           Padding(
  //             padding: EdgeInsets.symmetric(vertical: 4),
  //             child: Text(
  //               'Terms and Conditions',
  //               style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
  //               textAlign: TextAlign.left,
  //             ),
  //           ),
  //           Spacer()
  //         ],
  //       ),
  //       Container(
  //         decoration: BoxDecoration(
  //             color: Colors.black26,
  //             border: Border.all(color: Colors.white30),
  //             borderRadius: BorderRadius.all(Radius.circular(8))),
  //         height: 120,
  //         child: Padding(
  //             padding: EdgeInsets.all(8),
  //             child: SingleChildScrollView(
  //               child: Text(termsAndConditions),
  //             )),
  //       ),
  //     ],
  //   );
  // }

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
            plateController.text != '' &&
            _city != 'Choose a City' &&
            addressController.text != ''

        // _exemptionRequestProperty != null
        ) {
      Registration log = createLog();
      await databaseManager.createLog(log);
    }
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

  _employeePressed() {
    Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (context) => EmployeeRegistrationScreen(
            showAppBar: true,
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

  Registration createRegistration() {
    var registration = Registration.def();

    registration.userType = 'Visitor';
    registration.name = nameController.text.trim();
    registration.email = emailController.text.trim();
    registration.phone =
        phoneController.text.trim().replaceAll('-', '').replaceAll(' ', '');
    registration.streetNumber = '';
    registration.streetName = addressController.text;
    registration.city = _city;
    registration.plateNumber = plateController.text.trim();
    registration.province = _plateProvince;
    registration.unitNumber = unitController.text.trim();
    registration.duration = _selectedDuration.toString();
    registration.createdAt = DateTime.now().toUtc();

    return registration;
  }

  Registration createLog() {
    var registration = Registration.log();

    registration.name = nameController.text.trim();
    registration.email = emailController.text.trim();
    registration.phone =
        phoneController.text.trim().replaceAll('-', '').replaceAll(' ', '');
    registration.streetNumber = '';
    registration.streetName = addressController.text.isEmpty
        ? registration.streetName
        : addressController.text;
    registration.city = _city;
    registration.plateNumber = plateController.text.isEmpty
        ? registration.plateNumber
        : plateController.text.trim();
    registration.province = _plateProvince;
    registration.unitNumber = unitController.text.isEmpty
        ? registration.unitNumber
        : unitController.text.trim();
    registration.duration = _selectedDuration.toString();
    registration.createdAt = DateTime.now().toUtc();

    return registration;
  }

  // Exemption createExemption() {
  //   var selfRegistration = Exemption.def();
  //   selfRegistration.regDate = DateTime.now().toUtc();
  //   selfRegistration.plateID =
  //       '${plateController.text.toUpperCase().replaceAll(' ', '')}_${_plateProvince}';
  //   selfRegistration.propertyID = _exemptionRequestProperty?.propertyID2;
  //   selfRegistration.startDate = DateTime.now().toUtc();
  //   selfRegistration.endDate =
  //       DateTime.now().add(Duration(days: _selectedDuration)).toUtc();
  //   selfRegistration.unitNumber = '';
  //   selfRegistration.email = emailController.text;
  //   selfRegistration.phone = phoneController.text;
  //   selfRegistration.name = nameController.text;
  //   selfRegistration.makeModel = '';
  //   selfRegistration.numberOfDays = '$_selectedDuration';
  //   selfRegistration.reason = 'guests';
  //   selfRegistration.notes = '';
  //   selfRegistration.authBy = '';
  //   selfRegistration.isArchived = '';

  //   var splitAddress = _exemptionRequestProperty?.propertyAddress?.split(',');

  //   selfRegistration.streetNumber = splitAddress?[0] ?? '0';
  //   selfRegistration.streetName = 'test';
  //   selfRegistration.streetSuffix = '';
  //   selfRegistration.address =
  //       _exemptionRequestProperty?.propertyAddress ?? 'Error getting addresss';

  //   return selfRegistration;
  // }

  // _verifyAddress() {
  //   var propertyID = sessionCubit.checkIfValidProperty(
  //       cityController.text.toLowerCase(),
  //       addressController.text.toLowerCase());

  //   if (propertyID != null) {
  //     setState(() {
  //       _exemptionRequestProperty = sessionCubit.getPropertyFromID(propertyID);
  //       _prefs?.setString(_propertyIDKey, propertyID);
  //     });
  //   }
  // }

  // _verifyProvince() {
  //   if (!isValidProvince(plateProvinceController.text)) {
  //     unauthorizedPlateMessage = "Province is invalid";
  //   }
  // }

  _verifyLicencePlate() {
    if (isValidPlate(plateController.text.toUpperCase().replaceAll(' ', ''))) {
    } else {
      formFailedValidationMessage +=
          "Licence Plate contains invalid characters";
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
      addressController.text = '';
      plateController.text = '';
      unitController.text = '';
      _plateProvince = 'ON';
      agreedToTermsAndConditions = false;
      _exemptionRequestProperty = null;
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
          formFailedValidationMessage,
          formFailedValidationMessage);
    } else {
      if (nameController.text != '' &&
              emailController.text != '' &&
              phoneController.text != '' &&
              plateController.text != '' &&
              _city != 'Choose a City'

          // _exemptionRequestProperty != null
          ) {
        if (addressController.text != '') {
          Iterable<String> fillAddress =
              streetAddresses.where((String option) {
            return option
                .toLowerCase()
                .contains(addressController.text.toLowerCase());
          });
          if (fillAddress.length == 1) {
            addressController.text = fillAddress.first.toString();
            selectedFromList = true;
          }

          // bypass select form list
          selectedFromList = true;

          if (selectedFromList) {
            _storeInfoPreferences();
            final exemption = createRegistration();
            databaseResponseMessage =
                await databaseManager.createExemption(exemption);

            openDialog(
                // ignore: use_build_context_synchronously
                context,
                '✅ ${databaseResponseMessage.message ?? ''}',
                databaseResponseMessage.description,
                databaseResponseMessage.description ?? '');

            if (databaseResponseMessage.message ==
                    "Visitor Parking Registration Granted" ||
                databaseResponseMessage.message ==
                    "Visitor Parking Registration Denied") {
              _resetInterface();
            }
          } else {
            openDialog(
                context,
                'Invalid Street Address',
                'Please type and select an address from the list provided.',
                'Please type and select an address from the list provided.');
          }
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class WaveCustomPaint extends CustomPainter {
  Color backgroundColor;
  WaveCustomPaint({required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    var painter = Paint()
      ..color = backgroundColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    var path = Path();
    var height = size.height;
    var width = size.width;

    path.moveTo(0, height / 3 + height / 5);
    var des1 = width / 4;
    var des2 = height / 3 + height / 10; //height/5 /2
    path.quadraticBezierTo(des1, des2, width / 2, height / 3 + height / 10);
    path.quadraticBezierTo(
        width / 2 + width / 4, height / 3 + height / 10, width, height / 3);
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.lineTo(0, height / 3 + height / 5);
    path.close();
    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
