import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:r2park_flutter_dev/Managers/ExemptionRequestManager.dart';
import 'package:r2park_flutter_dev/Screens/Session/resident_session_view.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_state.dart';
import 'package:r2park_flutter_dev/Screens/CustomViews/loading_view.dart';
import 'package:r2park_flutter_dev/Screens/Session/visitor_session_view.dart';
import 'package:r2park_flutter_dev/models/property.dart';
import 'Managers/UserManager.dart';
import 'Screens/Session/session_cubit.dart';
import 'Screens/auth/login/login.dart';
import 'models/user.dart';

class AppNavigator extends StatelessWidget {
  var userManager = UserManager();
  var exemptionManager = ExemptionRequestManager();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Navigator(
        pages: [
          // show loading screen
          if (state is UnknownSessionState) MaterialPage(child: LoadingView()),

          //show auth flow
          if (state is Unauthenticated)
            MaterialPage(
                child: StreamBuilder(
              stream: Stream.fromFuture(userManager.getUsers()),
              builder: (context, response) {
                if (!response.hasData) {
                  return Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [CircularProgressIndicator()]));
                } else if (response.hasError) {
                  return Center(child: Text(response.error.toString()));
                } else {
                  return MultiProvider(
                    providers: [
                      Provider<List<User>>.value(value: response.data!),
                    ],
                    child: MaterialApp(
                      title: 'Login Flutter',
                      theme: ThemeData(
                          brightness: Brightness.dark,
                          primaryColor: Colors.blue,
                          colorScheme: ColorScheme.dark()),
                      home: Login(
                        sessionCubit: context.read<SessionCubit>(),
                      ),
                    ),
                  );
                }
              },
            )),

          //show session flow
          if (state is Authenticated)
            MaterialPage(
                child: StreamBuilder(
                    stream: Stream.fromFuture(exemptionManager.getProperties()),
                    builder: (context, response) {
                      if (!response.hasData) {
                        print('no data!');
                        return Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [CircularProgressIndicator()]));
                      } else if (response.hasError) {
                        print(response.error);
                        return Center(child: Text(response.error.toString()));
                      } else {
                        return MultiProvider(
                          providers: [
                            Provider<List<Property>>.value(
                                value: response.data!)
                          ],
                          child: MaterialApp(
                            theme: ThemeData(
                                brightness: Brightness.dark,
                                primaryColor: Colors.blue,
                                colorScheme: ColorScheme.dark()),
                            home: VisitorSessionView(
                              user: state.user,
                              sessionCubit: context.read<SessionCubit>(),
                            ),
                          ),
                        );
                      }
                    })),
          // if (state is Authenticated && state.user.firstName != "blake")
          //   MaterialPage(
          //       child: StreamBuilder(
          //           stream: Stream.fromFuture(exemptionManager.getProperties()),
          //           builder: (context, response) {
          //             if (!response.hasData) {
          //               print('no data!');
          //               return Center(
          //                   child: Column(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: [CircularProgressIndicator()]));
          //             } else if (response.hasError) {
          //               print(response.error);
          //               return Center(child: Text(response.error.toString()));
          //             } else {
          //               return MultiProvider(
          //                 providers: [
          //                   Provider<List<Property>>.value(
          //                       value: response.data!)
          //                 ],
          //                 child: MaterialApp(
          //                   home: VisitorSessionView(
          //                     user: state.user,
          //                     sessionCubit: context.read<SessionCubit>(),
          //                   ),
          //                 ),
          //               );
          //             }
          //           }))
        ],
        onPopPage: (route, result) => route.didPop(result),
      );
    });
  }
}
