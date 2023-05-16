import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:r2park_flutter_dev/Managers/ExemptionRequestManager.dart';
import 'package:r2park_flutter_dev/app_navigator.dart';
import 'Screens/Session/session_cubit.dart';
import 'Screens/auth/auth_utilities/auth_repo.dart';
import 'Screens/auth/data_repo.dart';
import 'models/property.dart';
import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var exemptionManager = ExemptionRequestManager();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: StreamBuilder(
            stream: Stream.fromFuture(exemptionManager.getProperties()),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                print('no data!');
                return Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()]));
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return MultiRepositoryProvider(
                  providers: [
                    Provider<List<Property>>.value(value: snapshot.data!),
                    RepositoryProvider(create: (context) => AuthRepo()),
                    RepositoryProvider(create: (context) => DataRepo()),
                  ],
                  child: BlocProvider(
                    create: (context) => SessionCubit(
                      properties: context.read<List<Property>>(),
                      authRepo: context.read<AuthRepo>(),
                      dataRepo: context.read<DataRepo>(),
                    ),
                    child: AppNavigator(),
                  ),
                );
              }
            }));
  }
}







// class MyApp extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(),
//     );
//   }
// }
