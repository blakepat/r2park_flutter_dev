import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/Managers/helper_functions.dart';
import 'package:r2park_flutter_dev/Screens/CustomViews/bottom_assign_sheet.dart';
import 'package:r2park_flutter_dev/Screens/CustomViews/bottom_edit_sheet.dart';
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

  List<AccessCode> accessCodes = [];

  @override
  void initState() {
    super.initState();

    getAccessCodes();
  }

  void getAccessCodes() async {
    final acArray = await databaseManager.getAccessCodes(user.userId ?? "");
    acArray.sort((a, b) => DateTime.parse(b.createdAt ?? "")
        .compareTo(DateTime.parse(a.createdAt ?? "")));

    setState(() {
      accessCodes = acArray;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        keyboardType: TextInputType.number,
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
        keyboardType: TextInputType.number,
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

  void _generateCodes() async {
    final accessCodeRequest = AccessCodeRequest(
      userId: user.userId ?? '',
      description: _purposeController.text,
      duration: _durationController.text,
      numberOfCodes: _numberOfCodesController.text,
    );

    var numberOfCodes = int.tryParse(_numberOfCodesController.text);
    var duration = int.tryParse(_durationController.text);

    if (numberOfCodes != null && duration != null) {
      if (numberOfCodes < 21 &&
          numberOfCodes > 0 &&
          duration > 0 &&
          duration < 5) {
        final response =
            await databaseManager.generateAccessCodes(accessCodeRequest);

        // ignore: use_build_context_synchronously
        openDialog(context, "Response from Server", response, response);
        var newCodes = await databaseManager.getAccessCodes(user.userId ?? "");
        setState(() {
          _purposeController.text = "";
          _durationController.text = "";
          _numberOfCodesController.text = "";
          accessCodes = newCodes;
          getAccessCodes();
        });
      } else {
        openDialog(
            context,
            "Error in form",
            "Enter number between 1-20 for Number of codes and 1-4 for duration",
            "Enter number between 1-20 for Number of codes and 1-4 for duration");
      }
    } else {
      openDialog(
          context,
          "Error in form",
          "Enter number between 1-20 for Number of codes and 1-4 for duration",
          "Enter number between 1-20 for Number of codes and 1-4 for duration");
    }
  }

  //------------------------------------------------------
  //Access Code List
  Widget _createAccessCodeList() {
    return Column(
      children: [
        _createTitleText(),
        accessCodes.isEmpty ? _createEmptyView() : _createListView(),
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
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Container(
            // color: Colors.red,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: tertiaryColor,
                border: Border.all(color: Colors.white)),
            child: Column(children: [
              ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: _createListObjects())
            ])));
  }

  Widget _createEmptyView() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Container(
            // color: Colors.red,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: tertiaryColor,
                border: Border.all(color: Colors.white)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "No Access Codes found.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            )));
  }

  List<Widget> _createListObjects() {
    return accessCodes
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
                            Text('ACCESS CODE: ${code.accessCode ?? ''}'),
                            Spacer(),
                            Text('USER ID: ${code.userId ?? ''}'),
                          ],
                        ),
                        Row(children: [
                          Text(
                              'STATUS: ${code.status == "1" ? "Active" : "Deactive"}'),
                          Spacer(),
                          Text('DURATION: ${code.duration ?? ''}'),
                        ]),
                        Text('NAME: ${code.name ?? ''}'),
                        Text('EMAIL: ${code.email ?? ''}'),
                        Text('CREATED AT: ${code.createdAt ?? ''}'),
                        Text('EXPIRY DATE: ${code.expiry ?? ''}'),
                        ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.8),
                            child: Text(
                              'DESCRIPTION: ${code.description ?? ''}',
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              GradientButton(
                                  borderRadius: BorderRadius.circular(20),
                                  onPressed: () => {
                                        _activateAccessCode(
                                            code.accessCode ?? "")
                                      },
                                  child: Text(
                                    code.status == "1"
                                        ? "DEACTIVATE"
                                        : "ACTIVATE",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: GradientButton(
                                    borderRadius: BorderRadius.circular(20),
                                    onPressed: () => {_showEditSheet(code)},
                                    child: Text(
                                      "EDIT",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                              GradientButton(
                                  borderRadius: BorderRadius.circular(20),
                                  onPressed: () => {_showAssignSheet(code)},
                                  child: Text(
                                    "ASSIGN",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ))))
        .toList();
  }

  void _activateAccessCode(String code) async {
    await databaseManager.activateAccessCode(code, user.userId ?? "");
    getAccessCodes();
  }

  void _showAssignSheet(AccessCode code) async {
    showModalBottomSheet(
        context: context,
        builder: (context) => BottomAssignSheet(accessCode: code)).then(
      (value) async {
        if (value != null) {
          await databaseManager.assignAccessCode(
              code.accessCode ?? "", user.userId ?? "", value[1], value[0]);
        }
        getAccessCodes();
      },
    );
  }

  void _showEditSheet(AccessCode code) async {
    showModalBottomSheet(
        context: context,
        builder: (context) => BottomEditSheet(accessCode: code)).then(
      (value) async {
        if (value != null) {
          await databaseManager.editAccessCode(
              accessCode: code.accessCode ?? "",
              userId: code.userId ?? "",
              description: value[0],
              duration: value[1],
              id: code.id ?? "");
        }
        getAccessCodes();
      },
    );
  }
}
