import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color primaryColor = Colors.blue[900]!;
Color secondaryColor = Colors.green[900]!;
Color tertiaryColor = Color.fromARGB(100, 0, 150, 136);
Color backgroundGreyColor = Color(0xff121212);
Color? backgroundBlueGreyColor = Colors.blueGrey[900];

var statusBarStyle = SystemUiOverlayStyle(
  systemNavigationBarColor: backgroundBlueGreyColor, // navigation bar color
  statusBarColor: backgroundBlueGreyColor, // status bar color
);

String kInitialInfoText =
    'please contact Parking Support at the following telephone numbers during regular business hours \n(M-F 9:00am - 5:00pm) or e-mail anytime.';

TextStyle kInitialTextLabelStyle = TextStyle(
    color: Colors.grey[400],
    fontSize: 14,
    textBaseline: TextBaseline.alphabetic);

TextStyle kButtonTextStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white);

InputDecoration textFieldDecoration({icon: Icons, labelName: String}) {
  return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      // borderSide: BorderSide(width: 0, style: BorderStyle.none)),
      labelText: labelName,
      fillColor: Colors.black26,
      filled: true,
      labelStyle: kInitialTextLabelStyle,
      icon: Icon(icon));
}

List<DropdownMenuItem<String>> statesAndProvinces = [
  //Provinces and territories
  DropdownMenuItem(value: 'ON', child: Text('ON')),
  DropdownMenuItem(value: 'BC', child: Text('BC')),
  DropdownMenuItem(value: 'AB', child: Text('AB')),
  DropdownMenuItem(value: 'MB', child: Text('MB')),
  DropdownMenuItem(value: 'NB', child: Text('NB')),
  DropdownMenuItem(value: 'NL', child: Text('NL')),
  DropdownMenuItem(value: 'NT', child: Text('NT')),
  DropdownMenuItem(value: 'NS', child: Text('NS')),
  DropdownMenuItem(value: 'NU', child: Text('NU')),
  DropdownMenuItem(value: 'PE', child: Text('PE')),
  DropdownMenuItem(value: 'QC', child: Text('QC')),
  DropdownMenuItem(value: 'SK', child: Text('SK')),
  DropdownMenuItem(value: 'YT', child: Text('YT')),

  //States
  DropdownMenuItem(value: 'AL', child: Text('AL')),
  DropdownMenuItem(value: 'AK', child: Text('AK')),
  DropdownMenuItem(value: 'AZ', child: Text('AZ')),
  DropdownMenuItem(value: 'AR', child: Text('AR')),
  DropdownMenuItem(value: 'CA', child: Text('CA')),
  DropdownMenuItem(value: 'CO', child: Text('CO')),
  DropdownMenuItem(value: 'CT', child: Text('CT')),
  DropdownMenuItem(value: 'DE', child: Text('DE')),
  DropdownMenuItem(value: 'FL', child: Text('FL')),
  DropdownMenuItem(value: 'GA', child: Text('GA')),
  DropdownMenuItem(value: 'HI', child: Text('HI')),
  DropdownMenuItem(value: 'ID', child: Text('ID')),
  DropdownMenuItem(value: 'IL', child: Text('IL')),
  DropdownMenuItem(value: 'IN', child: Text('IN')),
  DropdownMenuItem(value: 'IA', child: Text('IA')),
  DropdownMenuItem(value: 'KS', child: Text('KS')),
  DropdownMenuItem(value: 'KY', child: Text('KY')),
  DropdownMenuItem(value: 'LA', child: Text('LA')),
  DropdownMenuItem(value: 'ME', child: Text('ME')),
  DropdownMenuItem(value: 'MH', child: Text('MH')),
  DropdownMenuItem(value: 'MD', child: Text('MD')),
  DropdownMenuItem(value: 'MA', child: Text('MA')),
  DropdownMenuItem(value: 'MI', child: Text('MI')),
  DropdownMenuItem(value: 'MN', child: Text('MN')),
  DropdownMenuItem(value: 'MS', child: Text('MS')),
  DropdownMenuItem(value: 'MO', child: Text('MO')),
  DropdownMenuItem(value: 'MT', child: Text('MT')),
  DropdownMenuItem(value: 'NE', child: Text('NE')),
  DropdownMenuItem(value: 'NV', child: Text('NV')),
  DropdownMenuItem(value: 'NJ', child: Text('NJ')),
  DropdownMenuItem(value: 'NM', child: Text('NM')),
  DropdownMenuItem(value: 'NY', child: Text('NY')),
  DropdownMenuItem(value: 'NC', child: Text('NC')),
  DropdownMenuItem(value: 'ND', child: Text('ND')),
  DropdownMenuItem(value: 'OH', child: Text('OH')),
  DropdownMenuItem(value: 'OK', child: Text('OK')),
  DropdownMenuItem(value: 'OR', child: Text('OR')),
  DropdownMenuItem(value: 'PA', child: Text('PA')),
  DropdownMenuItem(value: 'RI', child: Text('RI')),
  DropdownMenuItem(value: 'SC', child: Text('SC')),
  DropdownMenuItem(value: 'SD', child: Text('SD')),
  DropdownMenuItem(value: 'TN', child: Text('TN')),
  DropdownMenuItem(value: 'TX', child: Text('TX')),
  DropdownMenuItem(value: 'UT', child: Text('UT')),
  DropdownMenuItem(value: 'VT', child: Text('VT')),
  DropdownMenuItem(value: 'VA', child: Text('VA')),
  DropdownMenuItem(value: 'WA', child: Text('WA')),
  DropdownMenuItem(value: 'WI', child: Text('WI')),
  DropdownMenuItem(value: 'WY', child: Text('WY')),
];

String termsAndConditions =
    'By using our online vehicle registry for parking services, you agree to provide accurate information and comply with all posted parking regulations. This service is intended solely for vehicle registration for parking purposes, and any unlawful use is prohibited. We are not responsible for any damages, loss, or theft of vehicles while parked. Fees must be paid as specified during registration, and refunds are subject to the facility\'s policy. Your personal information will be used and protected according to our Privacy Policy. We reserve the right to terminate accounts for any breach of these terms, and we are not liable for any indirect or consequential damages. These terms may be modified at any time, and continued use constitutes acceptance of any changes. The governing law will be that of the service provider\'s operating jurisdiction. By registering, you acknowledge and accept these terms and conditions.';
