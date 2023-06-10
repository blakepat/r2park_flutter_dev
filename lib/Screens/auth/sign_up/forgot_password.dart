import 'package:flutter/material.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:r2park_flutter_dev/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mailer/mailer.dart';
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

  String? verifyLink;
  bool verifyButton = false;
  Future checkUser() async {
    // var url = Uri.http('localhost', 'check.php');
    var url = Uri.parse('http://192.168.68.102/check.php');
    var response = await http.post(url, body: {
      'email': userEmailTextField.text,
    });
    var link = json.decode(response.body);
    print(link);
    if (link == 'INVALIDUSER') {
      showToast('This user does not exist, please double check and try again!',
          duration: 3, gravity: Toast.bottom);
    } else {
      setState(() {
        verifyLink = link;
        verifyButton = true;
      });
      showToast('Click Verify Button to Reset Password',
          duration: 3, gravity: Toast.bottom);
    }
  }

  int newPass = 0;

  Future resetPassword(String verifyLink) async {
    var url = Uri.parse(verifyLink);
    print('❌$url');

    var response = await http.post(url);

    print('😈${response.body}');
    var link = json.decode(response.body);
    print(link);
    sendEmail(email: userEmailTextField.text);
    setState(() {
      newPass = link;
      verifyButton = false;
    });

    showToast('Your password has been reset $newPass',
        duration: 3, gravity: Toast.bottom);
  }

  // sendMail() async {
  //   String username = 'blakepatenaude84@gmail.com';
  //   String key = '';

  //   final smtpServer = gmailSaslXoauth2(username, key);

  //   final message = Message()
  //     ..from = Address(username)
  //     ..recipients.add('signaturesoftit@gmail.com ')
  //     ..subject = 'Password recover link from R2Park: ${DateTime.now}'
  //     ..html =
  //         '<h3>Thanks for using R2Park. Please click the link to reset your password</h3>\n<p> <a href=$verifyLink>Reset Password</a></p>';

  //   try {
  //     final sendReport = await send(message, smtpServer);
  //     print('Message sent: ${sendReport.toString()}');
  //   } on MailerException catch (e) {
  //     print('Message not sent. + ${e.toString()}\n');
  //   }
  // }

  sendEmail({
    required String email,
  }) async {
    final subject = 'Password Reset for R2Park';
    final message =
        '<h3>Thanks for using R2Park. Please click the link to reset your password</h3>\n<p> <a href=$verifyLink>Reset Password</a></p>';

    final serviceId = 'service_r92qfro';
    final templateId = 'template_3bcglw2';
    final userId = 'O3E-2XbChA0kAiyXd';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
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

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        appBar: AppBar(title: Text('Password Recovery')),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    controller: userEmailTextField,
                    decoration: InputDecoration(hintText: 'User Email')),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  color: secondaryColor,
                  onPressed: () {
                    checkUser();
                  },
                  child: Text('Recover Password'),
                ),
              ),
              verifyButton
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        color: primaryColor,
                        onPressed: () {
                          resetPassword(verifyLink ?? '');
                        },
                        child: Text('Verify'),
                      ),
                    )
                  : Container(),
              newPass == 0 ? Container() : Text('New Password is $newPass')
            ],
          ),
        ));
  }

  showToast(String msg, {required int duration, required int gravity}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }
}
