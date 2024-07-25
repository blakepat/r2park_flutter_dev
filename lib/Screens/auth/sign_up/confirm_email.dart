// ignore: use_key_in_widget_constructors
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:toast/toast.dart';

// ignore: must_be_immutable
class ConfirmEmail extends StatefulWidget {
  String email;
  String newPass;

  ConfirmEmail({super.key, required this.email, required this.newPass});

  @override
  ConfirmEmailScreen createState() =>
      // ignore: no_logic_in_create_state
      ConfirmEmailScreen(accountEmail: email, newPass: newPass);
}

class ConfirmEmailScreen extends State<ConfirmEmail> {
  TextEditingController confirmCodeTextField = TextEditingController();
  String accountEmail;
  String? verifyLink;
  String newPass;

  ConfirmEmailScreen({required this.accountEmail, required this.newPass});

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        appBar: AppBar(title: Text('Confirm Email')),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: _createLogoView(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  accountEmail,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(80, 8, 80, 8),
                child: TextField(
                    controller: confirmCodeTextField,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Enter code')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  color: Colors.purple,
                  onPressed: () {
                    sendEmail(email: accountEmail);
                  },
                  child: Text('Resend Recovery Email'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: MaterialButton(
                  color: secondaryColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Confirm Email'),
                ),
              ),
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

  final _random = Random();
  String next(int min, int max) => '${min + _random.nextInt(max - min)}';

  // Future verfiyAndGetCode(String changePassLink) async {
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

  sendEmail({
    required String email,
  }) async {
    int min = 111111, max = 999999;
    newPass = next(min, max);

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
}
