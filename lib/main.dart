import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/app_navigator.dart';
import 'package:r2park_flutter_dev/models/city.dart';
import 'package:r2park_flutter_dev/models/role.dart';
import 'Screens/Session/session_cubit.dart';
import 'Screens/auth/auth_utilities/auth_repo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var databaseManager = DatabaseManager();
  List<City> _cities = [];
  List<Role> _roles = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'R2Park',
        home: StreamBuilder(
            stream: Stream.fromFuture(getData()),
            builder: (context, snapshot) {
              if (_cities.isEmpty) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [CircularProgressIndicator()]));
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return MultiRepositoryProvider(
                  providers: [
                    RepositoryProvider(create: (context) => AuthRepo()),
                  ],
                  child: BlocProvider(
                    create: (context) => SessionCubit(
                        authRepo: context.read<AuthRepo>(),
                        cities: _cities,
                        roles: _roles),
                    child: AppNavigator(),
                  ),
                );
              }
            }));
  }

  Future<void> getData() async {
    var cities = await databaseManager.getCities();
    var roles = await databaseManager.getRoles();

    if (_cities.isEmpty) {
      setState(() {
        _cities = cities;
      });
    }

    if (_roles.isEmpty) {
      setState(() {
        _roles = roles;
      });
    }
  }
}
