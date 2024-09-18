import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/Screens/CustomViews/gradient_button.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:r2park_flutter_dev/models/access_code.dart';
import 'package:r2park_flutter_dev/models/access_code_request.dart';
import '../../models/user.dart';

class GenerateCodeView extends StatefulWidget {
  final User user;
  final SessionCubit sessionCubit;

  const GenerateCodeView(
      {super.key, required this.user, required this.sessionCubit});
  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      ResidentSessionScreen(user: user, sessionCubit: sessionCubit);
}

class ResidentSessionScreen extends State<GenerateCodeView> {
  final User user;
  final SessionCubit sessionCubit;

  ResidentSessionScreen({
    required this.user,
    required this.sessionCubit,
  });

  var databaseManager = DatabaseManager();

  final _numberOfCodesController = TextEditingController();
  final _purposeController = TextEditingController();
  final _durationController = TextEditingController();

  List<AccessCode> access_codes = [];

  @override
  void initState() {
    super.initState();

    final testCode = AccessCode(
        user_id: '1455',
        access_code: 'H65253',
        description: 'TEST',
        duration: '4',
        expiry: 'Sept 4, 2023',
        created_at: 'Sept 1, 2034',
        last_increment: 'TEST');

    for (int i = 0; i < 10; i++) {
      access_codes.add(testCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _createGenerateAccessCodeView(),
            _createAccessCodeList(),
          ],
        ),
      ),
    ));
  }

  Widget _createGenerateAccessCodeView() {
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
          child: Column(
            children: [
              _createNumberOfCodesField(),
              _createPurposeField(),
              Row(
                children: [
                  Expanded(child: _createDurationField()),
                  _createGenerateButton(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _createNumberOfCodesField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _numberOfCodesController,
        decoration: textFieldDecoration(
            icon: Icons.numbers, labelName: 'Number Of Codes'),
      ),
    );
  }

  Widget _createPurposeField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _purposeController,
        decoration: textFieldDecoration(
            icon: Icons.message, labelName: 'Reason for codes'),
      ),
    );
  }

  Widget _createDurationField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _durationController,
        decoration:
            textFieldDecoration(icon: Icons.punch_clock, labelName: 'Duration'),
      ),
    );
  }

  Widget _createGenerateButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GradientButton(
          borderRadius: BorderRadius.circular(20),
          onPressed: _generateCodes,
          child: Text(
            "Generate",
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  void _generateCodes() {
    final accessCodeRequest = AccessCodeRequest(
      user_id: user.userId ?? '',
      description: _purposeController.text,
      duration: _durationController.text,
      number_of_codes: _numberOfCodesController.text,
    );

    databaseManager.generateAccessCodes(accessCodeRequest);
  }

  //------------------------------------------------------
  //Access Code List
  Widget _createAccessCodeList() {
    return Column(
      children: [
        _createTitleText(),
        _createListView(),
      ],
    );
  }

  Widget _createTitleText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Access Codes",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _createListView() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            // color: Colors.red,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: tertiaryColor,
                border: Border.all(color: Colors.white)),
            child: Column(
                    children: [ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: _createListObjects())])));
  }

  List<Widget> _createListObjects() {
    return access_codes
        .map((code) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                // color: Colors.red,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color.fromRGBO(18, 60, 56, 1),
                    border: Border.all(color: Colors.white)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('ACCESS CODE: ${code.access_code ?? ''}'),
                            Spacer(),
                            Text('USER_ID: ${code.user_id ?? ''}'),
                          ],
                        ),
                        Row(children: [
                          Text('DESCRIPTION: ${code.description ?? ''}'),
                          Spacer(),
                          Text('DURATION: ${code.duration ?? ''}'),
                        ]),
                        Row(
                          children: [
                            Text('CREATED AT: ${code.created_at ?? ''}'),
                            Spacer(),
                            Text('EXPIRY DATE: ${code.expiry ?? ''}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ))))
        .toList();
  }
}
