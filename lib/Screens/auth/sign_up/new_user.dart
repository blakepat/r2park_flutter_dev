import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:r2park_flutter_dev/Managers/helper_functions.dart';
import 'package:r2park_flutter_dev/Screens/auth/sign_up/confirm_email.dart';
import 'package:r2park_flutter_dev/main.dart';
import 'package:toast/toast.dart';
import '../../../Managers/exemption_request_manager.dart';
import '../../../models/user.dart';

// ignore: must_be_immutable
class NewUser extends StatefulWidget {
  User? user;
  SessionCubit? sessionCubit;

  NewUser({super.key, this.user, this.sessionCubit});

  @override
  NewUserState createState() =>
      // ignore: no_logic_in_create_state
      NewUserState(loggedInUser: user, sessionCubit: sessionCubit);
}

class NewUserState extends State<NewUser> {
  User? loggedInUser;
  SessionCubit? sessionCubit;
  var exemptionManager = ExemptionRequestManager();

  TextEditingController? _emailTextFieldController;
  TextEditingController? _firstNameTextFieldController;
  TextEditingController? _lastNameTextFieldController;
  TextEditingController? _mobileNumberTextFieldController;
  TextEditingController? _address1TextFieldController;
  TextEditingController? _unitNumberTextFieldController;
  TextEditingController? _cityTextFieldController;
  TextEditingController? _provinceTextFieldController;
  TextEditingController? _postalCodeTextFieldController;
  TextEditingController? _companyAddressTextFieldController;
  TextEditingController? _companyCityTextFieldController;
  TextEditingController? _password1TextFieldController;
  TextEditingController? _password2TextFieldController;

  bool emailValidate = true;
  bool firstNameValidate = true;
  bool lastNameValidate = true;
  bool mobileNumberValidate = true;
  bool address1Validate = true;
  bool address2Validate = true;
  bool cityValidate = true;
  bool provinceValidate = true;
  bool postalCodeValidate = true;
  bool companyAddressValidate = true;
  bool companyCityValidate = true;
  bool password1Validate = true;
  bool password2Validate = true;

  bool isNewUser = true;

  String newPass = '0';

  checkifNewUser(User user) {
    if (user.fullName == '') {
      return true;
    }
    return false;
  }

  NewUserState({this.loggedInUser, this.sessionCubit});

  @override
  void initState() {
    super.initState();

    isNewUser = checkifNewUser(widget.user ?? User.def());

    widget.user ??= User.def();
    _emailTextFieldController = TextEditingController();
    _emailTextFieldController?.text = widget.user?.email ?? '';

    _firstNameTextFieldController = TextEditingController();
    _firstNameTextFieldController?.text = widget.user?.fullName ?? '';

    _mobileNumberTextFieldController = TextEditingController();
    _mobileNumberTextFieldController?.text = widget.user?.mobileNumber ?? '';

    _address1TextFieldController = TextEditingController();
    _address1TextFieldController?.text = widget.user?.address ?? '';

    _unitNumberTextFieldController = TextEditingController();
    _unitNumberTextFieldController?.text = widget.user?.unitNumber ?? '';

    _cityTextFieldController = TextEditingController();
    _cityTextFieldController?.text = widget.user?.city ?? '';

    _provinceTextFieldController = TextEditingController();
    _provinceTextFieldController?.text =
        widget.user?.province?.toUpperCase() ?? '';

    _postalCodeTextFieldController = TextEditingController();
    _postalCodeTextFieldController?.text = widget.user?.postalCode ?? '';

    _companyAddressTextFieldController = TextEditingController();
    _companyAddressTextFieldController?.text =
        widget.user?.companyAddress ?? '';

    _companyCityTextFieldController = TextEditingController();
    _companyCityTextFieldController?.text = widget.user?.companyId ?? '';

    _password1TextFieldController = TextEditingController();
    _password1TextFieldController?.text = widget.user?.password ?? '';

    _password2TextFieldController = TextEditingController();
    _password2TextFieldController?.text = widget.user?.password ?? '';
  }

  @override
  void dispose() {
    super.dispose();

    _emailTextFieldController?.dispose();
    _firstNameTextFieldController?.dispose();
    _lastNameTextFieldController?.dispose();
    _mobileNumberTextFieldController?.dispose();
    _address1TextFieldController?.dispose();
    _unitNumberTextFieldController?.dispose();
    _cityTextFieldController?.dispose();
    _provinceTextFieldController?.dispose();
    _postalCodeTextFieldController?.dispose();
    _companyAddressTextFieldController?.dispose();
    _companyCityTextFieldController?.dispose();
    _password1TextFieldController?.dispose();
    _password2TextFieldController?.dispose();
  }

  Widget _textField(
      String labelText, TextEditingController? controller, bool validate,
      {bool passwordConfirmField = false, bool hideText = false}) {
    return TextField(
      obscureText: hideText,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: validate
            ? null
            : passwordConfirmField
                ? "Passwords do not match"
                : 'Field Can\'t be empty',
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
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: _textField(
                      'Company Address',
                      _companyAddressTextFieldController,
                      companyAddressValidate)),
              SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 2,
                child: _textField('Company City',
                    _companyCityTextFieldController, companyCityValidate),
              )
            ],
          ),
          SizedBox(
            height: 4,
          ),
          _textField(
              'Password', _password1TextFieldController, password1Validate,
              hideText: true),
          SizedBox(
            height: 4,
          ),
          checkifNewUser(widget.user ?? User.def())
              ? _textField('Confirm Password', _password2TextFieldController,
                  password2Validate,
                  passwordConfirmField: true, hideText: true)
              : SizedBox(height: 2),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
              child: checkifNewUser(widget.user ?? User.def())
                  ? Text('Create', style: TextStyle(color: Colors.white))
                  : Text('Update', style: TextStyle(color: Colors.white)),
              onPressed: () {
                String? email = _emailTextFieldController?.text;
                String? firstName = _firstNameTextFieldController?.text;
                String? lastName = _lastNameTextFieldController?.text;
                String? mobileNumber = _mobileNumberTextFieldController?.text;
                String? address1 = _address1TextFieldController?.text;
                String? address2 = _unitNumberTextFieldController?.text;
                String? city = _cityTextFieldController?.text;
                String? province = _provinceTextFieldController?.text;
                String? postalCode = _postalCodeTextFieldController?.text;
                String? password = _password1TextFieldController?.text;

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
                      ? password1Validate = false
                      : password1Validate = true;
                  if (checkifNewUser(widget.user ?? User.def())) {
                    _password1TextFieldController?.text ==
                            _password2TextFieldController?.text
                        ? password2Validate = true
                        : password2Validate = false;
                  }
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
                    password1Validate &&
                    password2Validate) {
                  var newUser = User.def();
                  if (loggedInUser != null) {
                    // print('🥶${loggedInUser?.id}');
                    // loggedInUser?.id = id;
                    loggedInUser?.email = email;
                    loggedInUser?.fullName = firstName;
                    loggedInUser?.mobileNumber = mobileNumber;
                    loggedInUser?.address = address1;
                    loggedInUser?.unitNumber = address2;
                    loggedInUser?.city = city;
                    loggedInUser?.province = province;
                    loggedInUser?.postalCode = postalCode;
                    loggedInUser?.password = password;

                    widget.user = loggedInUser;
                  } else {
                    // newUser.id = id;
                    newUser.email = email;
                    newUser.fullName = firstName;
                    newUser.mobileNumber = mobileNumber;
                    newUser.address = address1;
                    newUser.unitNumber = address2;
                    newUser.city = city;
                    newUser.province = province;
                    newUser.postalCode = postalCode;
                    newUser.password = password;

                    widget.user = newUser;
                  }
                  //if address matches property assign property ID to user
                  var propertyID = sessionCubit?.checkIfValidProperty(
                      _cityTextFieldController?.text.toLowerCase() ?? '',
                      _address1TextFieldController?.text.toLowerCase() ?? '');

                  var companyID = sessionCubit?.checkIfValidProperty(
                      _companyCityTextFieldController?.text.toLowerCase() ?? '',
                      _companyAddressTextFieldController?.text.toLowerCase() ??
                          '');

                  if (propertyID != null) {
                    widget.user?.propertyId = propertyID;

                    if (isNewUser) {
                      openDialog(
                          context,
                          '✅ User Created!',
                          "You can now login! Your address matches one of our properties, we have sent a request to your property manager to give you residence access!",
                          "You can now login! Your address matches one of our properties, we have sent a request to your property manager to give you residence access!");
                    }
                  } else if (companyID != null) {
                    widget.user?.companyId = companyID;

                    if (isNewUser) {
                      openDialog(
                          context,
                          '✅ User Created!',
                          "You can now login! Your company address matches one of our properties, we have sent a request to your manager!",
                          "You can now login! Your company address matches one of our properties, we have sent a request to your manager!");
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
                        sendEmail(email: _emailTextFieldController!.text);
                      });

                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => ConfirmEmail(
                                    email: _emailTextFieldController!.text,
                                    newPass: newPass,
                                  )))
                          .then((value) =>
                              Navigator.of(context).pop(widget.user));
                    }
                  } else {
                    // userManager.updateUser(widget.user!);
                  }
                }
              },
            ),
          ),
          SizedBox(height: 12),
          if (isNewUser == false)
            TextButton(
                onPressed: () => _showActionSheet(context),
                child: Text(
                  'Delete Profile',
                  style: TextStyle(color: Colors.red),
                ))
        ],
      ),
    );
  }

  void _showActionSheet(BuildContext context) {
    // var userDeleted = false;

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
                    // userManager.deleteUser(loggedInUser!);
                    widget.user = null;
                    Navigator.of(modalContext).pop();
                    BlocProvider.of<SessionCubit>(context).signOut();
                    Navigator.of(context).pop();
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
    // if (userDeleted == true) {
    //   print('✅ USER DELETED TRUE');
    //   BlocProvider.of<SessionCubit>(context).signOut();
    //   Navigator.of(context).pop();
    // }
  }

  final _random = Random();
  String randomIntString(int min, int max) =>
      '${min + _random.nextInt(max - min)}';

  // Future verfiyAndGetCode(String changePassLink, String accountEmail) async {
  //   var url = Uri.parse(changePassLink);
  //   var response = await http.post(url);
  //   print(response.body);
  //   var link = json.decode(response.body);
  //   print(link);
  //   setState(() {
  //     int min = 111111, max = 999999;
  //     newPass = next(min, max);

  //     sendEmail(email: accountEmail);
  //   });
  //   showToast(
  //       'Your password reset email has been sent, please check your email',
  //       duration: 3,
  //       gravity: Toast.bottom);
  // }

  showToast(String msg, {required int duration, required int gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }

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
            // 'user_name': name,
            'user_email': email,
            // 'to_email': email,
            'user_subject': subject,
            'user_message': message,
          }
        }));

    // print(response.body);
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

  //   @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: SingleChildScrollView(
  //     child: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
  //         child: Column(
  //           children: [
  //             _addPlateTitle(),
  //             _licencePlateSeciton(),
  //             _addLocationTitle(),
  //             _locationSection(),
  //             _durationInput(),
  //             _submitButton(),
  //             // _footerView()
  //           ],
  //         ),
  //       ),
  //     ),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loggedInUser == null
          ? AppBar(
              title: checkifNewUser(widget.user ?? User.def())
                  ? Text('Create an Account')
                  : Text('Update User'),
              actions: const [
                // loggedInUser == null
                //     ? SizedBox()
                //     : IconButton(
                //         onPressed: () {
                //           _showActionSheet(context);
                //         },
                //         icon: Icon(Icons.delete_forever))
              ],
            )
          : null,
      body: SingleChildScrollView(child: Center(child: _inputData(context))),
    );
  }
}

void openDialog(BuildContext context, String s, String t, String u) {}
