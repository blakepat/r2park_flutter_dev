import "package:flutter/material.dart";
import "package:r2park_flutter_dev/Managers/constants.dart";
import "package:r2park_flutter_dev/Managers/database_manager.dart";
import "package:r2park_flutter_dev/Screens/Session/session_cubit.dart";
import "package:r2park_flutter_dev/models/user.dart";

class SessionAccountView extends StatefulWidget {
  final User user;
  final SessionCubit sessionCubit;

  const SessionAccountView(
      {super.key, required this.user, required this.sessionCubit});

  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      SessionAccountScreen(user: user, sessionCubit: sessionCubit);
}

class SessionAccountScreen extends State<SessionAccountView> {
  final User user;
  final SessionCubit sessionCubit;

  final databaseManager = DatabaseManager();

  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();

  // final _resetCodeController = TextEditingController();

  SessionAccountScreen({required this.user, required this.sessionCubit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _createAccountInfoSection(),
          _createChangePasswordSection(),
          _footerTextView(),
        ],
      ),
    );
  }

  Widget _createAccountInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // color: Colors.red,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: tertiaryColor,
            border: Border.all(color: Colors.white)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  user.name ?? "",
                  style: TextStyle(fontSize: 24),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Email: ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        Text(user.email ?? ""),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "Phone: ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        Text(user.mobile ?? ""),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Unit: ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        Text(user.unitNumber ?? "N/A"),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "Address: ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        Text(user.address1 ?? ""),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          "City: ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        Text(user.city ?? ""),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "Province: ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        Text(user.province ?? ""),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Postal Code: ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        Text(user.postalCode ?? ""),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "Master Code: ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 10),
                        Text(user.masterAccessCode ?? ""),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createChangePasswordSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // color: Colors.red,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: tertiaryColor,
            border: Border.all(color: Colors.white)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _password1Controller,
                decoration: textFieldDecoration(
                    icon: Icons.password, labelName: 'Enter New Password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _password2Controller,
                decoration: textFieldDecoration(
                    icon: Icons.password,
                    labelName: 'Enter New Password Again'),
              ),
            )
          ]),
        ),
      ),
    );
  }

  // Widget _createChangePasswordButton() {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
  //     child: GradientButton(
  //         borderRadius: BorderRadius.circular(20),
  //         onPressed: _changePassword,
  //         child: Text("Change Password")),
  //   );
  // }

  // void _changePassword() async {
  //   if (_password1Controller.text.length > 5 &&
  //       _password1Controller.text == _password2Controller.text) {
  //     await databaseManager.changePassword(
  //         _resetCodeController.text.trim(), _password1Controller.text.trim());
  //   } else {
  //     openDialog(
  //         context,
  //         "Password Invalid",
  //         "Please ensure password is at least 6 characters long and matches",
  //         "Please ensure password is at least 6 characters long and matches");
  //   }
  // }

  Widget _footerTextView() {
    return Column(
      children: const [
        Text('Telephone: 905-873-7100 Ext. 304'),
        Text('Toll Free: 1-800-268-7100 Ext. 304'),
        Text('Fax: 905-873-7311'),
        Text('E-mail: Support@R2Park.ca')
      ],
    );
  }
}
