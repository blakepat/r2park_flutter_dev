import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:r2park_flutter_dev/Managers/exemption_request_manager.dart';
import 'package:r2park_flutter_dev/app_navigator.dart';
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
  var exemptionManager = ExemptionRequestManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: StreamBuilder(
            stream: Stream.fromFuture(exemptionManager.getProperties()),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [CircularProgressIndicator()]));
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return MultiRepositoryProvider(
                  providers: [
                    Provider<List<Property>>.value(value: snapshot.data!),
                    RepositoryProvider(create: (context) => AuthRepo()),
                  ],
                  child: BlocProvider(
                    create: (context) => SessionCubit(
                      properties: context.read<List<Property>>(),
                      authRepo: context.read<AuthRepo>(),
                    ),
                    child: AppNavigator(),
                  ),
                );
              }
            }));
  }
}
