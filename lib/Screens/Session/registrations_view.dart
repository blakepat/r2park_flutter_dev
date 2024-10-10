import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:r2park_flutter_dev/models/registration_list_item.dart';
import '../../models/user.dart';

class RegistrationsView extends StatefulWidget {
  final User user;
  final SessionCubit sessionCubit;

  const RegistrationsView(
      {super.key, required this.user, required this.sessionCubit});
  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      RegistrationsScreen(user: user, sessionCubit: sessionCubit);
}

class RegistrationsScreen extends State<RegistrationsView> {
  final User user;
  final SessionCubit sessionCubit;
  final databaseManager = DatabaseManager();

  String searchValue = '';
  List<RegistrationListItem> registrations = [];
  List<RegistrationListItem> registrationsToShow = [];

  RegistrationsScreen({required this.user, required this.sessionCubit});

  @override
  void initState() {
    super.initState();
    getRegistrations();
  }

  void getRegistrations() async {
    final registrationsFromDatabase =
        await databaseManager.getRegistrations(user.userId ?? "");
    setState(() {
      registrations = registrationsFromDatabase;
      registrationsToShow = registrationsFromDatabase;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _addSearchBar(),
      body: SingleChildScrollView(
        child: Column(children: [_createRegistrationList()]),
      ),
    );
  }

  PreferredSizeWidget _addSearchBar() {
    return EasySearchBar(
      title: const Text('Search Registrations'),
      onSearch: (value) => setState(() {
        searchValue = value.toLowerCase();
        registrationsToShow =
            registrations.where((item) => item.id!.contains(value)).toList();
      }),
      suggestions: registrations.map((item) => (item.id ?? "")).toList(),
      backgroundColor: Colors.black26,
    );
  }

  //------------------------------------------------------
  //Registrations List
  Widget _createRegistrationList() {
    return Column(
      children: [
        _createTitleText(),
        registrations.isEmpty ? _createEmptyView() : _createListView(),
      ],
    );
  }

  Widget _createTitleText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Registrations",
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
                "No Registrations found.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            )));
  }

  List<Widget> _createListObjects() {
    return registrationsToShow
        .map((registration) => Padding(
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
                            Text('Registration ID: ${registration.id ?? ''}'),
                            Spacer(),
                            Text(
                                'Master Access Code: ${registration.masterAccessCode ?? ''}'),
                          ],
                        ),
                        Row(children: [
                          Text(
                              'Employee Access Code: ${registration.employeeAccessCode}'),
                          Spacer(),
                          Text(
                              'Location ID: ${registration.fkLocationId ?? ''}'),
                        ]),
                        Row(children: [
                          Text('Licence Plate: ${registration.fkPlateId}'),
                          Spacer(),
                          Text('Province: ${registration.prov ?? ''}'),
                        ]),
                        Text('Start Date: ${registration.startDate ?? ''}'),
                        Text('End Date: ${registration.endDate ?? ''}'),
                      ],
                    ),
                  ),
                ))))
        .toList();
  }
}
