import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
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
  List<String> registrations = ["Test", "Hello", "World", "Blake"];

  RegistrationsScreen({required this.user, required this.sessionCubit});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _addSearchBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          _addResidentsTitle(),
          _addResidentsListView(),
          SizedBox(height: 20) //so scrollview can clear rounded edges of phone
        ]),
      ),
    );
  }

  PreferredSizeWidget _addSearchBar() {
    return EasySearchBar(
      title: const Text('Search Registrations'),
      onSearch: (value) => setState(() => searchValue = value.toLowerCase()),
      suggestions: registrations,
      backgroundColor: Colors.black26,
    );
  }


  Widget _addResidentsTitle() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 4, 0),
        child: Text(
          'Registrations',
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ),
    );
  }

  Widget _addResidentsListView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white30),
              color: Colors.black26,
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: createResidentCells()),
          )),
    );
  }

  

  List<Widget> createResidentCells() {
    final filteredRegistrations = registrations.where((element) =>
        element.contains(searchValue.replaceAll(' ', '')) ||
        // (element.firstName?.toLowerCase().contains(searchValue.trim()) ??
        //     false) ||
        // (element.lastName?.toLowerCase().contains(searchValue.trim()) ??
        //     false) ||
        (element.toLowerCase().contains(searchValue)));
    var listOfResidents = filteredRegistrations.map((e) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(2, 4, 2, 4),
        child: SizedBox(
          child: ElevatedButton(
              style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  backgroundColor: (secondaryColor.withAlpha(150)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () {
               
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          border: Border.all(color: Colors.white30),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            children: [
                              Text(
                                'Code',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              Text(
                                e,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 32),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.visible)),
                            // Text(e.lastName?.toUpperCase() ?? '',
                            //     style: TextStyle(
                            //         color: Colors.white,
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.bold))
                          ]),
                      Text(e,
                          style: TextStyle(color: Colors.white60, fontSize: 14))
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios_outlined, color: Colors.white)
                ],
              )),
        ),
      );
    }).toList();

    if (listOfResidents != null && listOfResidents.isNotEmpty) {
      return listOfResidents;
    } else {
      return [
        SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width - 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Currently No Residents...',
              style: TextStyle(fontSize: 20, color: Colors.white54),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ];
    }
  }
}
