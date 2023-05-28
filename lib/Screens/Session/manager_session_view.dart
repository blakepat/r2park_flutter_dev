import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/UserManager.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';

import '../../models/user.dart';
import '../auth/sign_up/new_user.dart';

class ManagerSessionView extends StatefulWidget {
  final User user;
  final SessionCubit sessionCubit;

  ManagerSessionView({required this.user, required this.sessionCubit});
  @override
  State<StatefulWidget> createState() =>
      ManagerSessionScreen(user: user, sessionCubit: sessionCubit);
}

class ManagerSessionScreen extends State<ManagerSessionView> {
  final User user;
  final SessionCubit sessionCubit;
  final userManager = UserManager();

  List<User>? residentRequests;
  List<User>? residents;

  ManagerSessionScreen({required this.user, required this.sessionCubit});

  @override
  void initState() {
    super.initState();

    setState(() {
      residentRequests = sessionCubit.getResidentRequests(
          addressID: user.clientDisplayName ?? '');

      residents =
          sessionCubit.getResidents(addressID: user.clientDisplayName ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        _addRequestTitle(),
        _addResidentRequestView(),
        _addResidentsTitle(),
        _addResidentsListView(),
      ]),
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
      return ElevatedButton(
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
              Container(
                decoration: BoxDecoration(
                    color: Colors.black26,
                    border: Border.all(color: Colors.white30),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                  child: Text(
                    e.address2 == null ? e.address ?? '' : e.address2 ?? '',
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${e.firstName ?? ''} ',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    Text(e.lastName ?? '',
                        style: TextStyle(color: Colors.black, fontSize: 18))
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
                      e.authorityLevel = 12;
                      userManager.updateUser(e);
                      residentRequests
                          ?.removeWhere((element) => element.id == e.id);
                      residents?.add(e);
                    });
                  },
                  icon: Icon(
                    Icons.check_box,
                    size: 40,
                    color: Colors.green,
                    shadows: [
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
                      e.clientDisplayName == '';
                      e.authorityLevel = 12;
                      userManager.updateUser(e);
                      residentRequests
                          ?.removeWhere((element) => element.id == e.id);
                    });
                    //TO:DO - change user authority level so its accepted / isConfirmed Variable
                  },
                  icon: Icon(
                    Icons.indeterminate_check_box,
                    size: 40,
                    color: Colors.red,
                    shadows: [
                      Shadow(
                          color: Colors.black,
                          blurRadius: 8,
                          offset: Offset(0, 2))
                    ],
                  ),
                ),
              )
            ],
          ));
    }).toList();
    if (newRequests != null && newRequests.isNotEmpty) {
      return newRequests;
    } else {
      return [SizedBox(height: 100)];
    }
  }

  List<Widget> createResidentCells() {
    var listOfResidents = residents?.map((e) {
      return ElevatedButton(
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
              Container(
                decoration: BoxDecoration(
                    color: Colors.black26,
                    border: Border.all(color: Colors.white30),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                  child: Text(
                    e.address2 == null ? e.address ?? '' : e.address2 ?? '',
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${e.firstName ?? ''} ',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    Text(e.lastName ?? '',
                        style: TextStyle(color: Colors.black, fontSize: 18))
                  ]),
                  Text(e.mobileNumber ?? '',
                      style: TextStyle(color: Colors.white60, fontSize: 14))
                ],
              ),
              Spacer(),
            ],
          ));
    }).toList();

    if (listOfResidents != null && listOfResidents.isNotEmpty) {
      return listOfResidents;
    } else {
      return [SizedBox(height: 100)];
    }
  }
}
