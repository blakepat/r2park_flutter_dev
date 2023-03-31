import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Utilities/helper_functions.dart';
import 'package:uuid/uuid.dart';
import '../../../models/user.dart';

class NewUser extends StatefulWidget {
  User? user;
  NewUser({this.user});

  @override
  _NewUserState createState() => _NewUserState(loggedInUser: user);
}

class _NewUserState extends State<NewUser> {
  User? loggedInUser;

  TextEditingController? _emailTextFieldController;
  TextEditingController? _firstNameTextFieldController;
  TextEditingController? _lastNameTextFieldController;
  TextEditingController? _mobileNumberTextFieldController;
  TextEditingController? _address1TextFieldController;
  TextEditingController? _address2TextFieldController;
  TextEditingController? _cityTextFieldController;
  TextEditingController? _provinceTextFieldController;
  TextEditingController? _postalCodeTextFieldController;
  TextEditingController? _passwordTextFieldController;

  bool emailValidate = true;
  bool firstNameValidate = true;
  bool lastNameValidate = true;
  bool mobileNumberValidate = true;
  bool address1Validate = true;
  bool address2Validate = true;
  bool cityValidate = true;
  bool provinceValidate = true;
  bool postalCodeValidate = true;
  bool passwordValidate = true;

  isDefault(User user) {
    if (user.firstName == '' && user.lastName == '') {
      return true;
    }
    return false;
  }

  _NewUserState({this.loggedInUser});

  @override
  void initState() {
    super.initState();

    print('😈 ${loggedInUser?.prefix}');

    if (widget.user == null) widget.user = User.def();
    _emailTextFieldController = TextEditingController();
    _emailTextFieldController?.text = widget.user?.email ?? '';

    _firstNameTextFieldController = TextEditingController();
    _firstNameTextFieldController?.text = widget.user?.firstName ?? '';

    _lastNameTextFieldController = TextEditingController();
    _lastNameTextFieldController?.text = widget.user?.lastName ?? '';

    _mobileNumberTextFieldController = TextEditingController();
    _mobileNumberTextFieldController?.text = widget.user?.mobileNumber ?? '';

    _address1TextFieldController = TextEditingController();
    _address1TextFieldController?.text = widget.user?.address1 ?? '';

    _address2TextFieldController = TextEditingController();
    _address2TextFieldController?.text = widget.user?.address2 ?? '';

    _cityTextFieldController = TextEditingController();
    _cityTextFieldController?.text = widget.user?.city ?? '';

    _provinceTextFieldController = TextEditingController();
    _provinceTextFieldController?.text = widget.user?.province ?? '';

    _postalCodeTextFieldController = TextEditingController();
    _postalCodeTextFieldController?.text = widget.user?.postalCode ?? '';

    _passwordTextFieldController = TextEditingController();
    _passwordTextFieldController?.text = widget.user?.password ?? '';
  }

  @override
  void dispose() {
    super.dispose();

    _emailTextFieldController?.dispose();
    _firstNameTextFieldController?.dispose();
    _lastNameTextFieldController?.dispose();
    _mobileNumberTextFieldController?.dispose();
    _address1TextFieldController?.dispose();
    _address2TextFieldController?.dispose();
    _cityTextFieldController?.dispose();
    _provinceTextFieldController?.dispose();
    _postalCodeTextFieldController?.dispose();
    _passwordTextFieldController?.dispose();
  }

  Widget _textField(
      String labelText, TextEditingController? controller, bool validate,
      {bool hideText = false}) {
    return TextField(
      obscureText: hideText,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: validate ? null : 'Field Can\'t be empty',
      ),
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
          _textField('Email', _emailTextFieldController, emailValidate),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Expanded(
                  child: _textField('First Name', _firstNameTextFieldController,
                      firstNameValidate)),
              SizedBox(
                width: 12,
              ),
              Expanded(
                  child: _textField('Last Name', _lastNameTextFieldController,
                      lastNameValidate)),
            ],
          ),
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
                    'Apt #', _address2TextFieldController, address2Validate),
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
          Row(
            children: [
              Expanded(
                  child: _textField('Province', _provinceTextFieldController,
                      provinceValidate)),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: _textField('PostalCode', _postalCodeTextFieldController,
                    postalCodeValidate),
              )
            ],
          ),
          SizedBox(
            height: 4,
          ),
          _textField('Password', _passwordTextFieldController, passwordValidate,
              hideText: true),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              child: isDefault(widget.user ?? User.def())
                  ? Text('Create')
                  : Text('Update'),
              onPressed: () {
                String? email = _emailTextFieldController?.text;
                String? firstName = _firstNameTextFieldController?.text;
                String? lastName = _lastNameTextFieldController?.text;
                String? mobileNumber = _mobileNumberTextFieldController?.text;
                String? address1 = _address1TextFieldController?.text;
                String? address2 = _address2TextFieldController?.text;
                String? city = _cityTextFieldController?.text;
                String? province = _provinceTextFieldController?.text;
                String? postalCode = _postalCodeTextFieldController?.text;
                String? password = _passwordTextFieldController?.text;

                setState(() {
                  isNullOrEmpty(email)
                      ? emailValidate = false
                      : emailValidate = true;
                  isNullOrEmpty(firstName)
                      ? firstNameValidate = false
                      : firstNameValidate = true;
                  isNullOrEmpty(lastName)
                      ? lastNameValidate = false
                      : lastNameValidate = true;
                  isNullOrEmpty(mobileNumber)
                      ? mobileNumberValidate = false
                      : mobileNumberValidate = true;
                  isNullOrEmpty(address1)
                      ? address1Validate = false
                      : address1Validate = true;
                  // isNullOrEmpty(address2)
                  //     ? address2Validate = false
                  //     : address2Validate = true;
                  isNullOrEmpty(city)
                      ? cityValidate = false
                      : cityValidate = true;
                  isNullOrEmpty(province)
                      ? provinceValidate = false
                      : provinceValidate = true;
                  isNullOrEmpty(postalCode)
                      ? postalCodeValidate = false
                      : postalCodeValidate = true;
                  isNullOrEmpty(password)
                      ? passwordValidate = false
                      : passwordValidate = true;
                });
                if (emailValidate &&
                    firstNameValidate &&
                    lastNameValidate &&
                    mobileNumberValidate &&
                    address1Validate &&
                    address2Validate &&
                    cityValidate &&
                    provinceValidate &&
                    postalCodeValidate &&
                    passwordValidate) {
                  final now = DateTime.now();
                  // final id = now.microsecondsSinceEpoch.toInt();

                  if (loggedInUser != null) {
                    print('🥶${loggedInUser?.id}');
                    // loggedInUser?.id = id;
                    loggedInUser?.email = email;
                    loggedInUser?.firstName = firstName;
                    loggedInUser?.lastName = lastName;
                    loggedInUser?.mobileNumber = mobileNumber;
                    loggedInUser?.address1 = address1;
                    loggedInUser?.address2 = address2;
                    loggedInUser?.city = city;
                    loggedInUser?.province = province;
                    loggedInUser?.postalCode = postalCode;
                    loggedInUser?.password = password;

                    widget.user = loggedInUser;
                  } else {
                    print('😡${loggedInUser?.id}');
                    var newUser = User.def();
                    // newUser.id = id;
                    newUser.email = email;
                    newUser.firstName = firstName;
                    newUser.lastName = lastName;
                    newUser.mobileNumber = mobileNumber;
                    newUser.address1 = address1;
                    newUser.address2 = address2;
                    newUser.city = city;
                    newUser.province = province;
                    newUser.postalCode = postalCode;
                    newUser.password = password;

                    widget.user = newUser;
                  }
                  Navigator.of(context).pop(widget.user);
                }
              },
            ),
          ),
          SizedBox(height: 12)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isDefault(widget.user ?? User.def())
            ? Text('Create an Account')
            : Text('Update User'),
      ),
      body: Center(child: _inputData(context)),
    );
  }
}
