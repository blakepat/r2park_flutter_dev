import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/main.dart';
import 'package:http/http.dart' as http;
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
  TextEditingController resetCodeTextField = TextEditingController();
  TextEditingController newPasswordTextField = TextEditingController();

  String? accountEmail;
  String? verifyLink;
  bool showCodeTextField = false;
  bool showNewPasswordTextField = false;
  Future checkUser() async {
    // var url = Uri.http('localhost', 'check.php');
    var url = Uri.parse('http://localhost/check.php');
    var response = await http.post(url, body: {
      'email': userEmailTextField.text,
    });
    var link = json.decode(response.body);
    if (link == 'INVALIDUSER') {
      showToast('This user does not exist, please double check and try again!',
          duration: 3, gravity: Toast.bottom);
    } else {
      setState(() {
        verifyLink = link;
        showCodeTextField = true;
        verfiyAndGetCode(verifyLink ?? '');
      });
      //   showToast('Click Verify Button to Reset Password',
      //       duration: 3, gravity: Toast.bottom);
    }
  }

  String newPass = '0';

  Future verfiyAndGetCode(String changePassLink) async {
    var url = Uri.parse(changePassLink);
    var response = await http.post(url);
    var link = json.decode(response.body);
    setState(() {
      newPass = link;
      accountEmail = userEmailTextField.text;
      sendEmail(email: userEmailTextField.text);
    });

    showToast(
        'Your password reset email has been sent, please check your email',
        duration: 3,
        gravity: Toast.bottom);
  }

  Future changePassword() async {
    // var url = Uri.http('localhost', 'check.php');
    var url = Uri.parse('http://localhost/changepass.php');
    var response = await http.post(url, body: {
      'email': userEmailTextField.text,
      'newPassword': newPasswordTextField.text
    });
    var link = json.decode(response.body);
    if (link == 'COUNT3') {
      showToast('This user does not exist, please double check and try again!',
          duration: 3, gravity: Toast.bottom);
    } else {
      setState(() {
        Navigator.of(context)
            .pop(([userEmailTextField.text, newPasswordTextField.text]));
      });
      //   showToast('Click Verify Button to Reset Password',
      //       duration: 3, gravity: Toast.bottom);
    }
  }

  sendEmail({
    required String email,
  }) async {
    const subject = 'Password Reset for R2Park';
    final message =
        'Thank you for using R2Park!\n\n Your reset Password code is: $newPass \n\n';

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

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        appBar: AppBar(title: Text('Password Recovery')),
        body: SafeArea(
          child: showNewPasswordTextField
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: _createLogoView(),
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
                          //change password
                          changePassword();
                        },
                        child: Text('Change Password'),
                      ),
                    ),
                  ],
                )
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
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                                controller: userEmailTextField,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'User Email')),
                          ),
                    showCodeTextField
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(80, 8, 80, 8),
                            child: TextField(
                                controller: resetCodeTextField,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter code')),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        color:
                            showCodeTextField ? Colors.purple : secondaryColor,
                        onPressed: () {
                          checkUser();
                        },
                        child: Text(showCodeTextField
                            ? 'Resend Recovery Email'
                            : 'Recover Password'),
                      ),
                    ),
                    showCodeTextField
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MaterialButton(
                              color: secondaryColor,
                              onPressed: () {
                                //show change password screen
                                if (newPass == resetCodeTextField.text.trim()) {
                                  setState(() {
                                    showNewPasswordTextField = true;
                                  });
                                } else {
                                  showToast('Reset Code does not match',
                                      duration: 3, gravity: Toast.bottom);
                                }
                              },
                              child: Text('Reset Password'),
                            ),
                          )
                        : Container()
                  ],
                ),
        ));
  }

  showToast(String msg, {required int duration, required int gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }

  Widget _createLogoView() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 12, 20, 8),
      child: Image.asset('assets/images/3DLogo.png'),
    );
  }
}
