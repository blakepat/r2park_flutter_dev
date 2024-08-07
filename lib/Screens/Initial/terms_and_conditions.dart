import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:r2park_flutter_dev/Screens/CustomViews/gradient_button.dart';

// ignore: must_be_immutable
class TermsAndConditionsPage extends StatefulWidget {
  @override
  TermsAndConditionsState createState() => TermsAndConditionsState();
  // ignore: no_logic_in_create_state
}

class TermsAndConditionsState extends State<TermsAndConditionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Terms and Conditions",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black26,
                  border: Border.all(color: Colors.white30),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              // height: 120,
              child: Padding(
                  padding: EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    child: Text(termsAndConditions),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientButton(
                      onPressed: agreeToTermsAndConditions,
                      borderRadius: BorderRadius.circular(20),
                      child: Text(
                        'Agree',
                        style: kButtonTextStyle,
                      )),
                  Container(width: 100),
                  GradientButton(
                      onPressed: declineTermsAndConditions,
                      borderRadius: BorderRadius.circular(20),
                      child: Text(
                        'Decline',
                        style: kButtonTextStyle,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    )));
  }

  void agreeToTermsAndConditions() {
    Navigator.of(context).pop(true);
  }

  void declineTermsAndConditions() {
    Navigator.of(context).pop(false);
  }
}
