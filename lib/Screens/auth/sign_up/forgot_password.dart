import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:http/http.dart' as http;
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'dart:convert';
import 'package:toast/toast.dart';

// ignore: use_key_in_widget_constructors
class ForgotPassword extends StatefulWidget {
  @override
  ForgotPasswordScreen createState() =>
      // ignore: no_logic_in_create_state
      ForgotPasswordScreen();
}

class ForgotPasswordScreen extends State<ForgotPassword> {
  TextEditingController userEmailTextField = TextEditingController();
  TextEditingController masterAccessCodeTextField = TextEditingController();
  TextEditingController resetCodeTextField = TextEditingController();
  TextEditingController newPasswordTextField = TextEditingController();

  final databaseManager = DatabaseManager();

  String? accountEmail;
  String? verifyLink;
  bool showCodeTextField = false;
  bool showNewPasswordTextField = false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        appBar: AppBar(title: Text('Password Recovery')),
        body: SafeArea(
          child: showNewPasswordTextField
          //---------------------------------------------
          //These are widgets for reseting password
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: _createLogoView(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80, 8, 80, 8),
                      child: TextField(
                          controller: resetCodeTextField,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter code')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                          controller: newPasswordTextField,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter New Password')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        color: secondaryColor,
                        onPressed: () {
                          _changePassword();
                        },
                        child: Text('Change Password'),
                      ),
                    ),
                  ],
                )
              //-----------------------------------------------
              //These are widgets for sending reset code to email
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: _createLogoView(),
                    ),
                    showCodeTextField
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              accountEmail ?? '',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600),
                            ),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                    controller: userEmailTextField,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'User Email')),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                    controller: masterAccessCodeTextField,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Master Access Code')),
                              ),
                            ],
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        color:
                            Colors.purple,
                        onPressed: () {
                          _sendCodeToEmail();
                        },
                        child: Text('Recover Password'),
                      ),
                    ),
                  ],
                ),
        ));
  }

  void _changePassword() async {
    print("CHANGE PASSWORD CALLED");
    await databaseManager.changePassword(
        resetCodeTextField.text.trim(), newPasswordTextField.text.trim());
  }

  void _sendCodeToEmail() async {
    print("SEND CODE CALLED");
    await databaseManager.sendPasswordCode(
        userEmailTextField.text.trim(), masterAccessCodeTextField.text.trim());
    setState(() {
      showCodeTextField = true;
      showNewPasswordTextField = true;
    });
  }

  Widget _createLogoView() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 12, 20, 8),
      child: Image.asset('assets/images/3DLogo.png'),
    );
  }
}
