import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/app_navigator.dart';
import 'package:r2park_flutter_dev/models/city.dart';
import 'package:r2park_flutter_dev/models/user.dart';
import 'Screens/Session/session_cubit.dart';
import 'Screens/auth/auth_utilities/auth_repo.dart';
import 'models/property.dart';

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

  List<User> _users = [];
  List<Property> _properties = [];
  List<City> _cities = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'R2Park',
        home: StreamBuilder(
            stream: Stream.fromFuture(getData()),
            builder: (context, snapshot) {
              if (_users.isEmpty) {
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
                        properties: _properties,
                        authRepo: context.read<AuthRepo>(),
                        users: _users,
                        cities: _cities),
                    child: AppNavigator(),
                  ),
                );
              }
            }));
  }

  Future<void> getData() async {
    // var users = await databaseManager.getUsersFromJson();
    var properties = await databaseManager.getPropertiesFromJson();
    var users = await databaseManager.getUsersFromDevelopment();
    var cities = await databaseManager.getCities();

    // print(testUsers.length);

    if (_users.isEmpty) {
      setState(() {
        _users = users;
      });
    }

    if (_properties.isEmpty) {
      setState(() {
        _properties = properties;
      });
    }

    if (_cities.isEmpty) {
      setState(() {
        _cities = cities;
      });
    }
  }
}
