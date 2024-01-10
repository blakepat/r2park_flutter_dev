import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r2park_flutter_dev/Managers/exemption_request_manager.dart';
import 'package:r2park_flutter_dev/app_navigator.dart';
import 'package:r2park_flutter_dev/models/user.dart';
import 'Screens/Session/session_cubit.dart';
import 'Screens/auth/auth_utilities/auth_repo.dart';
import 'models/property.dart';

void main() {
  runApp(MyApp());
}

final primaryColor = Colors.blue[900]!;
final secondaryColor = Colors.green[900]!;

class MyApp extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var exemptionManager = ExemptionRequestManager();

  List<User> _users = [];
  List<Property> _properties = [];

  Future<void> getUsersFromJson() async {
    final String response =
        await rootBundle.loadString('assets/r2park_table.json');
    final data = await json.decode(response);
    setState(() {
      List jsonUsers = data["users"];
      List jsonProperties = data["properties"];

      if (_users.isEmpty) {
        _users = jsonUsers.map((entry) => User.convertFromJson(entry)).toList();
      }

      if (_properties.isEmpty) {
        _properties = jsonProperties
            .map((entry) => Property.convertFromJson(entry))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: StreamBuilder(
            stream: Stream.fromFuture(getUsersFromJson()),
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
                        users: _users),
                    child: AppNavigator(),
                  ),
                );
              }
            }));
  }
}
