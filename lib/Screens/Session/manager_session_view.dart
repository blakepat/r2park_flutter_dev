import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:r2park_flutter_dev/main.dart';
import '../../models/user.dart';
import '../auth/sign_up/new_user.dart';

class ManagerSessionView extends StatefulWidget {
  final User user;
  final SessionCubit sessionCubit;

  const ManagerSessionView(
      {super.key, required this.user, required this.sessionCubit});
  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      ManagerSessionScreen(user: user, sessionCubit: sessionCubit);
}

class ManagerSessionScreen extends State<ManagerSessionView> {
  final User user;
  final SessionCubit sessionCubit;
  // final userManager = UserManager();

  List<User>? residentRequests;
  List<User>? residents;
  List<String>? residentNames;

  String searchValue = '';

  ManagerSessionScreen({required this.user, required this.sessionCubit});

  @override
  void initState() {
    super.initState();

    setState(() {
      residentRequests =
          sessionCubit.getResidentRequests(addressID: user.propertyId ?? '');

      residents = sessionCubit.getResidents(addressID: user.propertyId ?? '');

      residentNames = residents?.map((e) => '${e.fullName}').toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _addSearchBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          _addRequestTitle(),
          _addResidentRequestView(),
          _addResidentsTitle(),
          _addResidentsListView(),
          SizedBox(height: 20) //so scrollview can clear rounded edges of phone
        ]),
      ),
    );
  }

  // Future<List<User>?> _fetchSuggestions(String searchValue) async {
  //   await Future.delayed(const Duration(milliseconds: 750));

  //   return residents?.where((element) {
  //     return element.fullName
  //             ?.toLowerCase()
  //             .contains(searchValue.toLowerCase()) ??
  //         false;
  //   }).toList();
  // }

  PreferredSizeWidget _addSearchBar() {
    return EasySearchBar(
      title: const Text('Search residents'),
      onSearch: (value) => setState(() => searchValue = value.toLowerCase()),
      suggestions: residentNames,
      backgroundColor: Colors.black26,
    );
  }

  Widget _addRequestTitle() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 4, 0),
        child: Text(
          'Resident Requests',
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ),
    );
  }

  Widget _addResidentRequestView() {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white30),
            color: Colors.black26,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: createRequestCells()),
        ));
  }

  Widget _addResidentsTitle() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 4, 0),
        child: Text(
          'Residents',
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
        ),
      ),
    );
  }

  Widget _addResidentsListView() {
    return Container(
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
        ));
  }

  List<Widget> createRequestCells() {
    var newRequests = residentRequests?.map((e) {
      return Padding(
          padding: const EdgeInsets.fromLTRB(2, 4, 2, 4),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: (secondaryColor.withAlpha(150)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text('Update User'),
                      ),
                      body: NewUser(
                        sessionCubit: sessionCubit,
                        user: e,
                      )),
                ));
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
                        padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            children: [
                              Text(
                                'Unit',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              Text(
                                e.unitNumber == null
                                    ? e.address ?? ''
                                    : e.unitNumber ?? '',
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
                            Text('${e.fullName?.toUpperCase() ?? ''} ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            // Text(e.lastName?.toUpperCase() ?? '',
                            //     style: TextStyle(
                            //         color: Colors.white,
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.bold))
                          ]),
                      Text(e.mobileNumber ?? '',
                          style: TextStyle(color: Colors.white60, fontSize: 14))
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: IconButton(
                      onPressed: () {
                        //TO:DO - change user authority level so its accepted / isConfirmed Variable
                        setState(() {
                          e.userType = "Resident";
                          // userManager.updateUser(e);
                          sessionCubit.users?.removeWhere(
                              (element) => element.userId == e.userId);
                          sessionCubit.users?.add(e);
                          residentRequests?.removeWhere(
                              (element) => element.userId == e.userId);
                          residents?.add(e);
                        });
                      },
                      icon: Icon(
                        Icons.check_box,
                        size: 40,
                        color: Colors.green,
                        shadows: const [
                          Shadow(
                              color: Colors.black,
                              blurRadius: 8,
                              offset: Offset(0, 2))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          e.propertyId == '';
                          e.userType = "Visitor";
                          // userManager.updateUser(e);
                          sessionCubit.users?.removeWhere(
                              (element) => element.userId == e.userId);
                          sessionCubit.users?.add(e);
                          residentRequests?.removeWhere(
                              (element) => element.userId == e.userId);
                        });
                        //TO:DO - change user authority level so its accepted / isConfirmed Variable
                      },
                      icon: Icon(
                        Icons.indeterminate_check_box,
                        size: 40,
                        color: Colors.red,
                        shadows: const [
                          Shadow(
                              color: Colors.black,
                              blurRadius: 8,
                              offset: Offset(0, 2))
                        ],
                      ),
                    ),
                  )
                ],
              )));
    }).toList();
    if (newRequests != null && newRequests.isNotEmpty) {
      return newRequests;
    } else {
      return [
        SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width - 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Currently No Resident Requests...',
              style: TextStyle(fontSize: 20, color: Colors.white54),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ];
    }
  }

  List<Widget> createResidentCells() {
    final filteredResidents = residents?.where((element) =>
        fullNameTrimmed(element).contains(searchValue.replaceAll(' ', '')) ||
        // (element.firstName?.toLowerCase().contains(searchValue.trim()) ??
        //     false) ||
        // (element.lastName?.toLowerCase().contains(searchValue.trim()) ??
        //     false) ||
        (element.address.toString().toLowerCase().contains(searchValue)));
    var listOfResidents = filteredResidents?.map((e) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(2, 4, 2, 4),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: (secondaryColor.withAlpha(150)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text('Update User'),
                    ),
                    body: NewUser(
                      sessionCubit: sessionCubit,
                      user: e,
                    )),
              ));
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
                      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          children: [
                            Text(
                              'Unit',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            Text(
                              e.unitNumber == null
                                  ? e.address ?? ''
                                  : e.unitNumber ?? '',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 32),
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
                          Text('${e.fullName?.toUpperCase() ?? ''} ',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          // Text(e.lastName?.toUpperCase() ?? '',
                          //     style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.bold))
                        ]),
                    Text(e.mobileNumber ?? '',
                        style: TextStyle(color: Colors.white60, fontSize: 14))
                  ],
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios_outlined, color: Colors.white)
              ],
            )),
      );
    }).toList();

    if (listOfResidents != null && listOfResidents.isNotEmpty) {
      return listOfResidents;
    } else {
      return [SizedBox(height: 100)];
    }
  }

  String fullNameTrimmed(User user) {
    return '${user.fullName?.toLowerCase()}';
  }
}
