import 'package:flutter/material.dart';

Color primaryColor = Colors.blue[900]!;
Color secondaryColor = Colors.green[900]!;

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
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Fermentum posuere urna nec tincidunt praesent semper feugiat. Neque aliquam vestibulum morbi blandit cursus risus at. Enim tortor at auctor urna nunc id cursus metus aliquam. Pellentesque id nibh tortor id. Tellus pellentesque eu tincidunt tortor aliquam. Vitae congue eu consequat ac felis donec et odio. Amet massa vitae tortor condimentum lacinia quis vel eros. Consectetur adipiscing elit ut aliquam purus sit amet. Nunc pulvinar sapien et ligula ullamcorper malesuada proin libero nunc. Pellentesque diam volutpat commodo sed egestas egestas fringilla phasellus. Tellus pellentesque eu tincidunt tortor. Eu consequat ac felis donec et odio pellentesque diam volutpat. Non odio euismod lacinia at. Donec ultrices tincidunt arcu non. Tincidunt augue interdum velit euismod in pellentesque massa. Mattis molestie a iaculis at erat pellentesque adipiscing commodo elit. Diam maecenas ultricies mi eget mauris pharetra et ultrices neque. Hac habitasse platea dictumst vestibulum. Sit amet aliquam id diam. Ridiculus mus mauris vitae ultricies leo integer malesuada nunc. Scelerisque mauris pellentesque pulvinar pellentesque habitant morbi tristique senectus et. Enim nunc faucibus a pellentesque sit amet porttitor eget dolor. Mattis rhoncus urna neque viverra justo nec ultrices. In dictum non consectetur a. Gravida quis blandit turpis cursus. Facilisi morbi tempus iaculis urna id. Ullamcorper velit sed ullamcorper morbi tincidunt ornare massa. Amet nisl purus in mollis nunc sed id semper risus. Turpis egestas pretium aenean pharetra magna ac placerat. Vitae tortor condimentum lacinia quis vel eros. Pulvinar pellentesque habitant morbi tristique senectus et netus. Ac auctor augue mauris augue. Duis convallis convallis tellus id. Sit amet commodo nulla facilisi. Eget magna fermentum iaculis eu non diam. Cursus risus at ultrices mi tempus imperdiet nulla malesuada pellentesque. Dictumst vestibulum rhoncus est pellentesque elit ullamcorper dignissim cras tincidunt. Amet venenatis urna cursus eget nunc scelerisque. Amet aliquam id diam maecenas. Consequat nisl vel pretium lectus quam id leo. Enim eu turpis egestas pretium aenean pharetra magna ac placerat. Dignissim cras tincidunt lobortis feugiat vivamus at augue. Enim lobortis scelerisque fermentum dui faucibus in ornare. Ultricies integer quis auctor elit sed vulputate. Ac turpis egestas integer eget aliquet. Imperdiet dui accumsan sit amet nulla facilisi. Vitae justo eget magna fermentum. Orci porta non pulvinar neque laoreet suspendisse interdum consectetur. Non nisi est sit amet facilisis magna. Aliquet lectus proin nibh nisl condimentum id venenatis a. Orci phasellus egestas tellus rutrum tellus pellentesque. Nulla facilisi morbi tempus iaculis. Arcu cursus vitae congue mauris rhoncus aenean vel elit scelerisque. Elit ut aliquam purus sit amet luctus venenatis lectus magna. Amet dictum sit amet justo donec enim diam vulputate ut. In cursus turpis massa tincidunt dui. Vel quam elementum pulvinar etiam non quam. Nisl rhoncus mattis rhoncus urna neque viverra justo nec. Est ullamcorper eget nulla facilisi etiam dignissim diam. Tristique senectus et netus et. Pellentesque habitant morbi tristique senectus et. Malesuada fames ac turpis egestas integer. Massa eget egestas purus viverra accumsan. Faucibus nisl tincidunt eget nullam non nisi est sit amet. Tincidunt id aliquet risus feugiat in ante metus. Vestibulum mattis ullamcorper velit sed ullamcorper. Eu facilisis sed odio morbi quis commodo odio aenean sed. Elit eget gravida cum sociis natoque penatibus et. Condimentum lacinia quis vel eros donec ac odio tempor orci. Nunc id cursus metus aliquam eleifend mi in nulla.';
