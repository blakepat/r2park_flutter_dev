import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/Screens/CustomViews/gradient_button.dart';
import 'package:r2park_flutter_dev/Screens/Initial/initial.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:r2park_flutter_dev/Managers/helper_functions.dart';
import 'package:r2park_flutter_dev/models/access_code_property.dart';
import 'package:r2park_flutter_dev/models/role.dart';
import '../../../models/user.dart';

// ignore: must_be_immutable
class NewUser extends StatefulWidget {
  SessionCubit? sessionCubit;
  bool isManagerScreen;

  NewUser({super.key, required this.isManagerScreen, this.sessionCubit});

  @override
  NewUserState createState() =>
      // ignore: no_logic_in_create_state
      NewUserState(
          isManagerScreen: isManagerScreen, sessionCubit: sessionCubit);
}

class NewUserState extends State<NewUser> {
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

  NewUserState({required this.isManagerScreen, this.sessionCubit});

  @override
  void initState() {
    super.initState();

    accessCodeFocus.addListener(() async {
      if (!accessCodeFocus.hasFocus) {
        accessCodeProperty = await databaseManager
            .checkAccessCode(_accessCodeTextFieldController.text);
        if (accessCodeProperty != null) {
          setState(() {
            addressSplitter(accessCodeProperty?.propertyAddress ?? 'failed');
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
      appBar: AppBar(title: Text('Create an Account')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _createRoleDropdown(),
                _createAccessCodeField(),
                _createEmailField(),
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
                _createAccountButton(),
                SizedBox(height: 12),
              ],
            ),
          )
        ],
      ),
    );
  }

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
        decoration: textFieldDecoration(
            icon: Icons.abc_rounded, labelName: 'Access Code'),
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
          decoration:
              textFieldDecoration(icon: Icons.css, labelName: 'Postal Code'),
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

  Widget _createAccountButton() {
    return Container(
      height: 40,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: GradientButton(
          borderRadius: BorderRadius.circular(20),
          width: 200,
          child: Text('Create', style: TextStyle(color: Colors.white)),
          onPressed: () async {
            _validateTextFields();

            if (_textFieldsAreAllValid()) {
              final user = User.def();
              user.email = _emailTextFieldController.text;

              user.name = _fullNameTextFieldController.text;
              user.registerAs = _role;
              user.masterAccessCode =
                  _accessCodeTextFieldController.text.trim();
              user.mobile = _mobileNumberTextFieldController.text;
              user.address1 = _address1TextFieldController.text;
              user.unitNumber = _unitNumberTextFieldController.text;
              user.city = _cityTextFieldController.text;
              user.province = _province;
              user.postalCode = _postalCodeTextFieldController.text;
              user.authLevel = '13';
              user.status = '1';

              final response = await databaseManager.createUser(user);
              // ignore: use_build_context_synchronously
              if (context.mounted) Navigator.of(context).pop();
              // ignore: use_build_context_synchronously
              openDialog(context, '✅ User Created!', response, response);
              
            }
          }),
    );
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
}
