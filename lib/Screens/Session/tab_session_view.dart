import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r2park_flutter_dev/Screens/Initial/initial.dart';
import 'package:r2park_flutter_dev/Screens/Session/generate_code_view.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_account_view.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_cubit.dart';
import '../../models/user.dart';
import 'registrations_view.dart';

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
    _tabController = TabController(length: 4, vsync: this);
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
      backgroundColor: Color(0xff121212),
      appBar: _createAppBar(width),
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          width: width,
          child: TabBarView(
            controller: _tabController,
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Initial(showAppBar: false, sessionCubit: sessionCubit),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: GenerateCodeView(user: user, sessionCubit: sessionCubit),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child:
                    RegistrationsView(user: user, sessionCubit: sessionCubit),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: SessionAccountView(
                  sessionCubit: sessionCubit,
                  user: user,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _createAppBar(double width) {
    double screenWidth = width < 700 ? width : 700;

    String title = '';
    setState(() {
      if (_activeIndex == 0) {
        title = 'Register To Park';
      } else if (_activeIndex == 1) {
        title = 'Access Codes';
      } else if (_activeIndex == 2) {
        title = 'Registrations';
      } else {
        title = 'Account';
      }
    });

    return AppBar(
      surfaceTintColor: Colors.green[900],
      bottom: TabBar(
          controller: _tabController,
          tabAlignment: TabAlignment.center,
          labelPadding: EdgeInsets.symmetric(horizontal: screenWidth / 8 - 15),
          isScrollable: true,
          tabs: const [
            Tab(
              icon: Icon(Icons.home, color: Colors.white),
            ),
            Tab(
              icon: Icon(Icons.add_circle_rounded, color: Colors.white),
            ),
            Tab(
              icon: Icon(Icons.checklist, color: Colors.white),
            ),
            Tab(
              icon: Icon(Icons.person, color: Colors.white),
            ),
          ]),
      leading: IconButton(
        icon: Icon(Icons.logout),
        onPressed: () => BlocProvider.of<SessionCubit>(context).signOut(),
      ),
      backgroundColor: Colors.blueGrey[800],
      title: Text(title),
      shadowColor: Colors.black54,
    );
  }
}
