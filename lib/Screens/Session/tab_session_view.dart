import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r2park_flutter_dev/Screens/Session/resident_session_view.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import 'package:r2park_flutter_dev/Screens/Session/visitor_session_view.dart';
import 'package:r2park_flutter_dev/main.dart';
import '../../models/user.dart';
import '../auth/sign_up/new_user.dart';
import 'manager_session_view.dart';

class TabSessionView extends StatefulWidget {
  final User user;
  final SessionCubit sessionCubit;

  const TabSessionView(
      {super.key, required this.user, required this.sessionCubit});
  @override
  State<StatefulWidget> createState() =>
      // ignore: no_logic_in_create_state
      TabSessionScreen(user: user, sessionCubit: sessionCubit);
}

class TabSessionScreen extends State<TabSessionView>
    with SingleTickerProviderStateMixin {
  final User user;
  final SessionCubit sessionCubit;

  late TabController _tabController;
  int _activeIndex = 0;
  bool isResident = false;
  bool isManager = false;

  TabSessionScreen({required this.user, required this.sessionCubit});

  @override
  void initState() {
    super.initState();

    isResident = user.propertyId != '';
    isManager = user.userType == "Manager" && user.propertyId != '';
    _tabController = TabController(
        length: isResident ? (isManager ? 4 : 3) : 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _activeIndex = _tabController.index;
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: _createAppBar(width),
      body: SizedBox(
        width: width,
        child: TabBarView(
          controller: _tabController,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: VisitorSessionView(user: user, sessionCubit: sessionCubit),
            ),
            if (isResident)
              Padding(
                padding: const EdgeInsets.all(0.0),
                child:
                    ResidentSessionView(user: user, sessionCubit: sessionCubit),
              ),
            if (isManager)
              Padding(
                padding: const EdgeInsets.all(0.0),
                child:
                    ManagerSessionView(user: user, sessionCubit: sessionCubit),
              ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: NewUser(user: user, sessionCubit: sessionCubit),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _createAppBar(double width) {
    String title = '';
    setState(() {
      if (_activeIndex == 0) {
        title = 'Register To Park';
      } else if (_activeIndex == 1) {
        title = isResident ? 'Register a Vistor' : 'Update Profile';
      } else if (_activeIndex == 2) {
        title = isManager ? 'Manage Residents' : 'Update Profile';
      } else {
        title = 'Update Profile';
      }
    });

    return AppBar(
      surfaceTintColor: Colors.green[900],
      bottom: TabBar(
          controller: _tabController,
          tabAlignment: TabAlignment.center,
          labelPadding: EdgeInsets.symmetric(
              horizontal: isResident
                  ? isManager
                      ? width / 8 - 15
                      : width / 6 - 15
                  : width / 4 - 15),
          isScrollable: true,
          tabs: [
            Tab(
              icon: Icon(Icons.create_rounded, color: Colors.white),
            ),
            if (isResident)
              Tab(
                icon: Icon(Icons.people, color: Colors.white),
              ),
            if (isManager)
              Tab(
                icon: Icon(
                  Icons.perm_contact_cal_sharp,
                  color: Colors.white,
                ),
              ),
            Tab(
              icon: Icon(Icons.person, color: Colors.white),
            ),
          ]),
      leading: IconButton(
        icon: Icon(Icons.logout),
        onPressed: () => BlocProvider.of<SessionCubit>(context).signOut(),
      ),
      backgroundColor: primaryColor,
      title: Text(title),
      shadowColor: Colors.black54,
    );
  }
}
