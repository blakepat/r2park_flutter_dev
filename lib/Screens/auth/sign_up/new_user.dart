import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/Screens/CustomViews/gradient_button.dart';
import 'package:r2park_flutter_dev/Screens/Initial/initial.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:r2park_flutter_dev/Managers/helper_functions.dart';
import 'package:r2park_flutter_dev/Screens/auth/sign_up/confirm_email.dart';
import 'package:r2park_flutter_dev/models/access_code_property.dart';
import 'package:r2park_flutter_dev/models/role.dart';
import '../../../models/user.dart';

// ignore: must_be_immutable
class NewUser extends StatefulWidget {
  User? user;
  SessionCubit? sessionCubit;
  bool isManagerScreen;

  NewUser(
      {super.key, required this.isManagerScreen, this.user, this.sessionCubit});

  @override
  NewUserState createState() =>
      // ignore: no_logic_in_create_state
      NewUserState(
          isManagerScreen: isManagerScreen,
          loggedInUser: user,
          sessionCubit: sessionCubit);
}

class NewUserState extends State<NewUser> {
  User? loggedInUser;
  SessionCubit? sessionCubit;
  bool isManagerScreen;

  var databaseManager = DatabaseManager();

  final _emailTextFieldController = TextEditingController();
  final _fullNameTextFieldController = TextEditingController();
  final _mobileNumberTextFieldController = TextEditingController();
  final _address1TextFieldController = TextEditingController();
  final _unitNumberTextFieldController = TextEditingController();
  final _cityTextFieldController = TextEditingController();
  final _accessCodeTextFieldController = TextEditingController();
  var _province = 'ON';
  final _postalCodeTextFieldController = TextEditingController();

  bool emailValidate = true;
  bool fullNameValidate = true;
  bool mobileNumberValidate = true;
  bool address1Validate = true;
  bool address2Validate = true;
  bool cityValidate = true;
  bool postalCodeValidate = true;

  bool isNewUser = true;
  String newPass = '0';
  String errorText = "";
  String passwordInadequateMessage = "";
  var _role = 'Choose a Role';

  AccessCodeProperty? accessCodeProperty;
  FocusNode accessCodeFocus = FocusNode();

  NewUserState(
      {required this.isManagerScreen, this.loggedInUser, this.sessionCubit});

  @override
  void initState() {
    super.initState();

    isNewUser = checkifNewUser(widget.user ?? User.def());
    widget.user ??= User.def();

    _emailTextFieldController.text = widget.user?.email ?? '';
    _fullNameTextFieldController.text = widget.user?.name ?? '';
    _mobileNumberTextFieldController.text = widget.user?.mobile ?? '';
    _address1TextFieldController.text = widget.user?.address1 ?? '';
    _unitNumberTextFieldController.text = widget.user?.unitNumber ?? '';
    _cityTextFieldController.text = widget.user?.city ?? '';
    _province = widget.user?.province?.toUpperCase() ?? 'ON';
    _province.isEmpty ? {_province = 'ON'} : '';
    _postalCodeTextFieldController.text = widget.user?.postalCode ?? '';

    accessCodeFocus.addListener(() async {
      print('🚒🚒');
      if (!accessCodeFocus.hasFocus) {
        accessCodeProperty = await databaseManager
            .checkAccessCode(_accessCodeTextFieldController.text);
        if (accessCodeProperty != null) {
          setState(() {
            addressSplitter(accessCodeProperty?.property_address ?? 'failed');
            _province = accessCodeProperty?.province ?? 'ON';
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _emailTextFieldController.dispose();
    _fullNameTextFieldController.dispose();
    _mobileNumberTextFieldController.dispose();
    _address1TextFieldController.dispose();
    _unitNumberTextFieldController.dispose();
    _cityTextFieldController.dispose();
    _province = "ON";
    _postalCodeTextFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loggedInUser == null
          ? AppBar(
              title: checkifNewUser(widget.user ?? User.def())
                  ? Text('Create an Account')
                  : Text('Update User'),
            )
          : null,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _createRoleDropdown(),
                _createAccessCodeField(),
                isNewUser
                    ? _createEmailField()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Text(
                          '${widget.user?.email}',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 22),
                        ),
                      ),
                _createNameField(),
                _createPhoneField(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    children: [_createUnitField(), _createAddressField()],
                  ),
                ),
                _createCityField(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      _createProvinceDropDownMenu(),
                      _createPostalCodeField()
                    ],
                  ),
                ),
                SizedBox(height: 32),
                _createUpdateButton(),
                SizedBox(height: 12),
                if (isNewUser == false)
                  TextButton(
                      onPressed: () => isManagerScreen
                          ? _showActionSheetForRemoveResident(context)
                          : _showActionSheetForDelete(context),
                      child: Text(
                        isManagerScreen ? 'Remove Resident' : 'Delete Profile',
                        style: TextStyle(color: Colors.red),
                      ))
              ],
            ),
          )
        ],
      ),
    );
  }

  // Widget _textField(
  //     String labelText, TextEditingController? controller, bool validate,
  //     {bool passwordConfirmField = false,
  //     bool hideText = false,
  //     int? maxLength,
  //     String errorText = ""}) {
  //   return TextField(
  //     maxLength: maxLength,
  //     obscureText: hideText,
  //     decoration: InputDecoration(
  //         counterText: '',
  //         labelText: labelText,
  //         errorText: errorText.isEmpty
  //             ? validate
  //                 ? null
  //                 : passwordConfirmField
  //                     ? "Passwords do not match"
  //                     : 'Field Can\'t be empty'
  //             : errorText),
  //     controller: controller,
  //   );
  // }

  Widget _createRoleDropdown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 20, 8, 12),
      child: DropdownButtonFormField(
        isExpanded: true,
        hint: Text(
          _role,
          style: kInitialTextLabelStyle,
        ),
        // alignment: Alignment.center,
        decoration: InputDecoration(
          labelText: "Role",
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
        items: sessionCubit?.roles?.map((role) {
          return DropdownMenuItem(value: role, child: Text(role.name ?? ''));
        }).toList(),
        onChanged: roleDropdownCallback,
      ),
    );
  }

  void roleDropdownCallback(Role? selectedValue) {
    setState(() {
      _role = selectedValue?.name ?? '';
    });
  }

  Widget _createAccessCodeField() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextField(
        controller: _accessCodeTextFieldController,
        focusNode: accessCodeFocus,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [UpperCaseTextFormatter()],
        decoration:
            textFieldDecoration(icon: Icons.abc_rounded, labelName: 'Access Code'),
        // onChanged: (value) async {
        //   if (value.length == 6) {
        //     accessCodeProperty = await databaseManager.checkAccessCode(value);

        //     if (accessCodeProperty != null) {
        //       setState(() {
        //         addressSplitter(
        //             accessCodeProperty?.property_address ?? 'failed');
        //         _province = accessCodeProperty?.province ?? 'ON';
        //       });
        //     }
        //   }
        // },
      ),
    );
  }

  void addressSplitter(String address) {
    var splitAddress = address.split(',');
    _address1TextFieldController.text = splitAddress[0];
    _cityTextFieldController.text = splitAddress[1];

    var postalCode = splitAddress[2].split(' ');

    _postalCodeTextFieldController.text = '${postalCode[2]} ${postalCode[3]}';
  }

  Widget _createEmailField() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _emailTextFieldController,
        decoration: textFieldDecoration(icon: Icons.email, labelName: 'Email'),
      ),
    );
  }

  Widget _createNameField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: TextField(
        controller: _fullNameTextFieldController,
        decoration: textFieldDecoration(icon: Icons.person, labelName: 'Name'),
      ),
    );
  }

  Widget _createPhoneField() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _mobileNumberTextFieldController,
        decoration: textFieldDecoration(icon: Icons.phone, labelName: 'Phone'),
      ),
    );
  }

  Widget _createUnitField() {
    return Expanded(
      flex: 2,
      child: TextField(
        controller: _unitNumberTextFieldController,
        decoration: textFieldDecoration(icon: Icons.numbers, labelName: 'Unit'),
      ),
    );
  }

  Widget _createAddressField() {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
        child: TextField(
          controller: _address1TextFieldController,
          decoration:
              textFieldDecoration(icon: Icons.house, labelName: 'Address'),
        ),
      ),
    );
  }

  Widget _createCityField() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextField(
        controller: _cityTextFieldController,
        decoration:
            textFieldDecoration(icon: Icons.location_city, labelName: 'City'),
      ),
    );
  }

  Widget _createPostalCodeField() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: TextField(
          controller: _postalCodeTextFieldController,
          decoration: textFieldDecoration(
              icon: Icons.css, labelName: 'Postal Code'),
        ),
      ),
    );
  }

  Widget _createProvinceDropDownMenu() {
    return Expanded(
        flex: 2,
        child: DropdownButtonFormField(
          hint: Text(
            "Province",
            style: kInitialTextLabelStyle,
          ),
          // alignment: Alignment.center,
          decoration: InputDecoration(
            labelText: "Province",
            icon: Icon(Icons.pin_drop),
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
          value: _province,
          onChanged: dropdownCallback,
        ));
  }

  void dropdownCallback(dynamic selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _province = selectedValue;
      });
    }
  }

  Widget _createUpdateButton() {
    return Container(
      height: 40,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: GradientButton(
          borderRadius: BorderRadius.circular(20),
          width: 200,
          child: checkifNewUser(widget.user ?? User.def())
              ? Text('Create', style: TextStyle(color: Colors.white))
              : Text('Update', style: TextStyle(color: Colors.white)),
          onPressed: () async {
            _validateTextFields();

            if (_textFieldsAreAllValid()) {
              if (loggedInUser == null) {
                widget.user = User.def();
                widget.user?.email = _emailTextFieldController.text;
              }
              widget.user?.name = _fullNameTextFieldController.text;
              widget.user?.register_as = _role;
              widget.user?.master_access_code =
                  _accessCodeTextFieldController.text.trim();
              widget.user?.mobile = _mobileNumberTextFieldController.text;
              widget.user?.address1 = _address1TextFieldController.text;
              widget.user?.unitNumber = _unitNumberTextFieldController.text;
              widget.user?.city = _cityTextFieldController.text;
              widget.user?.province = _province;
              widget.user?.postalCode = _postalCodeTextFieldController.text;
              widget.user?.auth_level = '13';
              widget.user?.status = '1';

              final response = await databaseManager.createUser(widget.user!);

              openDialog(context, '✅ User Created!', response, response);
            }
          }),
    );
  }

  checkifNewUser(User user) {
    if (user.name == '') {
      return true;
    }
    return false;
  }

  _textFieldsAreAllValid() {
    return emailValidate &&
        fullNameValidate &&
        mobileNumberValidate &&
        address1Validate &&
        address2Validate &&
        cityValidate &&
        postalCodeValidate;
  }

  _validateTextFields() {
    setState(() {
      isNullOrEmpty(_emailTextFieldController.text)
          ? emailValidate = false
          : emailValidate = true;
      isNullOrEmpty(_fullNameTextFieldController.text)
          ? fullNameValidate = false
          : fullNameValidate = true;
      isNullOrEmpty(_mobileNumberTextFieldController.text)
          ? mobileNumberValidate = false
          : mobileNumberValidate = true;
      isNullOrEmpty(_address1TextFieldController.text)
          ? address1Validate = false
          : address1Validate = true;
      isNullOrEmpty(_cityTextFieldController.text)
          ? cityValidate = false
          : cityValidate = true;
      isNullOrEmpty(_postalCodeTextFieldController.text)
          ? postalCodeValidate = false
          : postalCodeValidate = true;
    });
  }

  void _showActionSheetForDelete(BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext modalContext) => CupertinoActionSheet(
              title: Text(
                'Delete User?',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
              message: Text(
                'Are you sure you want to delete your profile and logout?',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () async {
                    databaseManager.deleteUser(loggedInUser!);
                    widget.user = null;
                    Navigator.of(modalContext).pop();
                    BlocProvider.of<SessionCubit>(context).signOut();
                    // Navigator.of(context).pop();
                  },
                  isDestructiveAction: true,
                  child: Text('Delete'),
                )
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: (() {
                  Navigator.pop(modalContext);
                }),
                child: Text('Cancel'),
              ),
            ));
  }

  void _showActionSheetForRemoveResident(BuildContext context) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext modalContext) => CupertinoActionSheet(
              title: Text(
                'Remove Resident From Property?',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
              message: Text(
                'Are you sure you want to remove this resident from the property',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () async {
                    User residentToRemove = loggedInUser!;
                    residentToRemove.master_access_code = "";
                    residentToRemove.register_as = "Visitor";
                    residentToRemove.address1 = "";
                    residentToRemove.unitNumber = "";

                    databaseManager.updateUser(residentToRemove);
                    widget.user = null;
                    Navigator.of(modalContext).pop();
                    Navigator.of(context).pop();
                  },
                  isDestructiveAction: true,
                  child: Text('Remove'),
                )
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: (() {
                  Navigator.pop(modalContext);
                }),
                child: Text('Cancel'),
              ),
            ));
  }

  // final _random = Random();
  // String randomIntString(int min, int max) =>
  //     '${min + _random.nextInt(max - min)}';

  // sendEmail({
  //   required String email,
  // }) async {
  //   int min = 111111, max = 999999;
  //   newPass = randomIntString(min, max);

  //   const subject = 'Password Reset for R2Park';
  //   final message =
  //       'Thank you for using R2Park!\n\n the code to confirm your email is: $newPass \n\n';

  //   const serviceId = 'service_r92qfro';
  //   const templateId = 'template_3bcglw2';
  //   const userId = 'O3E-2XbChA0kAiyXd';

  //   final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  //   final _ = await http.post(url,
  //       headers: {
  //         'origin': 'http://localhost',
  //         'Content-Type': 'application/json',
  //       },
  //       body: json.encode({
  //         'service_id': serviceId,
  //         'template_id': templateId,
  //         'user_id': userId,
  //         'template_params': {
  //           'user_email': email,
  //           'user_subject': subject,
  //           'user_message': message,
  //         }
  //       }));
  // }
}
