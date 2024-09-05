import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/Managers/validation_manager.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:r2park_flutter_dev/Managers/helper_functions.dart';
import 'package:r2park_flutter_dev/Screens/auth/sign_up/confirm_email.dart';
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

  NewUserState(
      {required this.isManagerScreen, this.loggedInUser, this.sessionCubit});

  @override
  void initState() {
    super.initState();

    isNewUser = checkifNewUser(widget.user ?? User.def());
    widget.user ??= User.def();

    print("💜💜 ${sessionCubit?.roles}");

    _emailTextFieldController.text = widget.user?.email ?? '';
    _fullNameTextFieldController.text = widget.user?.fullName ?? '';
    _mobileNumberTextFieldController.text = widget.user?.mobileNumber ?? '';
    _address1TextFieldController.text = widget.user?.address ?? '';
    _unitNumberTextFieldController.text = widget.user?.unitNumber ?? '';
    _cityTextFieldController.text = widget.user?.city ?? '';
    _province = widget.user?.province?.toUpperCase() ?? 'ON';
    _province.isEmpty ? {_province = 'ON'} : '';
    _postalCodeTextFieldController.text = widget.user?.postalCode ?? '';
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: _inputData(context),
          ),
        ),
      ),
    );
  }

  Widget _textField(
      String labelText, TextEditingController? controller, bool validate,
      {bool passwordConfirmField = false,
      bool hideText = false,
      int? maxLength,
      String errorText = ""}) {
    return TextField(
      maxLength: maxLength,
      obscureText: hideText,
      decoration: InputDecoration(
          counterText: '',
          labelText: labelText,
          errorText: errorText.isEmpty
              ? validate
                  ? null
                  : passwordConfirmField
                      ? "Passwords do not match"
                      : 'Field Can\'t be empty'
              : errorText),
      controller: controller,
    );
  }

  Widget _inputData(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _createRoleDropdown(),
          isNewUser
              ? _textField('Email', _emailTextFieldController, emailValidate)
              : Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Text(
                    '${widget.user?.email}',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                  ),
                ),
          SizedBox(
            height: 4,
          ),
          _textField(
              'Full Name', _fullNameTextFieldController, fullNameValidate),
          SizedBox(
            height: 4,
          ),
          _textField('Mobile Number', _mobileNumberTextFieldController,
              mobileNumberValidate),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: _textField(
                    'Apt #', _unitNumberTextFieldController, address2Validate),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _textField(
                    'Address', _address1TextFieldController, address1Validate),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          _textField('City', _cityTextFieldController, cityValidate),
          SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Expanded(flex: 2, child: _createPlateProvinceDropDownMenu()),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  flex: 3,
                  child: _textField('PostalCode',
                      _postalCodeTextFieldController, postalCodeValidate),
                )
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
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
    );
  }

  Widget _createRoleDropdown() {
    return DropdownButtonFormField(
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
        return DropdownMenuItem(child: Text(role.name ?? ''), value: role);
      }).toList(),
      onChanged: roleDropdownCallback,
    );
  }

  void roleDropdownCallback(Role? selectedValue) {
    setState(() {
      print(selectedValue?.name ?? '');
      _role = selectedValue?.name ?? '';
    });
  }

  Widget _createPlateProvinceDropDownMenu() {
    return Padding(
        padding: EdgeInsets.all(8),
        child: DropdownButtonFormField(
          hint: Text(
            "Province",
            style: kInitialTextLabelStyle,
          ),
          // alignment: Alignment.center,
          decoration: InputDecoration(
            labelText: "Province",
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
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
        child: checkifNewUser(widget.user ?? User.def())
            ? Text('Create', style: TextStyle(color: Colors.white))
            : Text('Update', style: TextStyle(color: Colors.white)),
        onPressed: () {
          if (passwordInadequateMessage.isNotEmpty) {
            openDialog(context, 'Insufficient Password',
                passwordInadequateMessage, passwordInadequateMessage);
          } else {
            _validateTextFields();

            if (_textFieldsAreAllValid()) {
              if (loggedInUser == null) {
                widget.user = User.def();
                widget.user?.email = _emailTextFieldController.text;
              }
              widget.user?.fullName = _fullNameTextFieldController.text;
              widget.user?.userType = 'visitor';
              widget.user?.userId = "666";
              widget.user?.mobileNumber = _mobileNumberTextFieldController.text;
              widget.user?.address = _address1TextFieldController.text;
              widget.user?.unitNumber = _unitNumberTextFieldController.text;
              widget.user?.city = _cityTextFieldController.text;
              widget.user?.province = _province;
              widget.user?.postalCode = _postalCodeTextFieldController.text;

              //if address matches property assign property ID to user
              var propertyID = sessionCubit?.checkIfValidProperty(
                  _cityTextFieldController.text.toLowerCase(),
                  _address1TextFieldController.text.toLowerCase());

              if (propertyID != null) {
                widget.user?.propertyId = propertyID;

                if (isNewUser) {
                  openDialog(
                      context,
                      '✅ User Created!',
                      "You can now login! Your address matches one of our properties, we have sent a request to your property manager to give you residence access!",
                      "You can now login! Your address matches one of our properties, we have sent a request to your property manager to give you residence access!");
                }
              } else {
                if (isNewUser) {
                  openDialog(
                      context,
                      '✅ User Created!',
                      "Thank you very using R2Park, sign in to register your vehicle!",
                      "Thank you very using R2Park, sign in to register your vehicle!");
                } else {
                  openDialog(
                      context,
                      'Success ✅',
                      "Your account has been updated!",
                      "Your account has been updated!");
                }
              }
              if (isNewUser) {
                if (widget.user?.email != null) {
                  setState(() {
                    sendEmail(email: _emailTextFieldController.text);
                  });

                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => ConfirmEmail(
                                email: _emailTextFieldController.text,
                                newPass: newPass,
                              )))
                      .then((value) => Navigator.of(context).pop(widget.user));
                }
              } else {
                databaseManager.updateUser(widget.user!);
              }
            }
          }
        },
      ),
    );
  }

  checkifNewUser(User user) {
    if (user.fullName == '') {
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
                    residentToRemove.propertyId = "";
                    residentToRemove.userType = "Visitor";
                    residentToRemove.address = "";
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

  final _random = Random();
  String randomIntString(int min, int max) =>
      '${min + _random.nextInt(max - min)}';

  sendEmail({
    required String email,
  }) async {
    int min = 111111, max = 999999;
    newPass = randomIntString(min, max);

    const subject = 'Password Reset for R2Park';
    final message =
        'Thank you for using R2Park!\n\n the code to confirm your email is: $newPass \n\n';

    const serviceId = 'service_r92qfro';
    const templateId = 'template_3bcglw2';
    const userId = 'O3E-2XbChA0kAiyXd';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final _ = await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'user_email': email,
            'user_subject': subject,
            'user_message': message,
          }
        }));
  }
}
