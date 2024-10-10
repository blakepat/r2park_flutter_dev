import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/Managers/helper_functions.dart';
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
                ? ListView(
                    // mainAxisAlignment: MainAxisAlignment.center,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          color: Colors.purple,
                          onPressed: () {
                            _sendCodeToEmail();
                          },
                          child: Text('Resend Reset Code'),
                        ),
                      ),
                    ],
                  )
                //-----------------------------------------------
                //These are widgets for sending reset code to email
                : ListView(
                    // mainAxisAlignment: MainAxisAlignment.center,
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
                          color: Colors.purple,
                          onPressed: () {
                            _sendCodeToEmail();
                          },
                          child: Text('Send Reset Code to Email'),
                        ),
                      ),
                    ],
                  ),
        ));
  }

  void _changePassword() async {
    if (newPasswordTextField.text.length > 5) {
      await databaseManager.changePassword(
          resetCodeTextField.text.trim(), newPasswordTextField.text.trim());
    } else {
      openDialog(
          context,
          "Password Invalid",
          "Please ensure password is at least 6 characters long",
          "Please ensure password is at least 6 characters long");
    }
  }

  void _sendCodeToEmail() async {
    var apiResponse = ("", "");
    apiResponse = await databaseManager.sendPasswordCode(
        userEmailTextField.text.trim(), masterAccessCodeTextField.text.trim());

    setState(() {
      if (apiResponse.$2 == "1") {
        showCodeTextField = true;
        showNewPasswordTextField = true;
      }

      openDialog(context, apiResponse.$2 == "1" ? "Reset Code sent" : "Error",
          apiResponse.$1, apiResponse.$1);
    });
  }

  Widget _createLogoView() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 12, 20, 8),
      child: Image.asset('assets/images/3DLogo.png'),
    );
  }
}
