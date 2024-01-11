import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r2park_flutter_dev/Old_Files/exemption_request_manager.dart';
import 'package:r2park_flutter_dev/Screens/Initial/initial.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_state.dart';
import 'package:r2park_flutter_dev/Screens/CustomViews/loading_view.dart';
import 'package:r2park_flutter_dev/Screens/Session/tab_session_view.dart';
import 'package:r2park_flutter_dev/main.dart';
import 'Screens/Session/session_cubit.dart';

class AppNavigator extends StatelessWidget {
  AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
      return Navigator(
          pages: [
            // show loading screen
            if (state is UnknownSessionState)
              MaterialPage(child: LoadingView()),

            //show auth flow
            if (state is Unauthenticated)
              MaterialPage(
                  child:
                      //     child: StreamBuilder(
                      //   stream: Stream.fromFuture(userManager.getUsers()),
                      //   builder: (context, response) {
                      //     if (!response.hasData) {
                      //       return
                      // Center(
                      //     child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: const [CircularProgressIndicator()]));
                      // } else if (response.hasError) {
                      //   return Center(child: Text(response.error.toString()));
                      // } else {
                      //   return MultiProvider(
                      //     providers: [
                      //       Provider<List<User>>.value(value: response.data!),
                      //     ],
                      //     child:
                      MaterialApp(
                title: 'Login Flutter',
                theme: ThemeData(
                    appBarTheme: AppBarTheme(color: primaryColor),
                    brightness: Brightness.dark,
                    primaryColor: primaryColor,
                    colorScheme: ColorScheme.dark()),
                home: Initial(
                  // Login(
                  sessionCubit: context.read<SessionCubit>(),
                ),
              )),

            //show session flow
            if (state is Authenticated)
              MaterialPage(
                // child:
                // StreamBuilder(
                //     stream:
                //         Stream.fromFuture(exemptionManager.getProperties()),
                //     builder: (context, response) {
                //       if (!response.hasData) {
                //         return Center(
                //             child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: const [
                //               CircularProgressIndicator()
                //             ]));
                //       } else if (response.hasError) {
                //         return Center(child: Text(response.error.toString()));
                //       } else {
                //         return MultiProvider(
                //           providers: [
                //             Provider<List<Property>>.value(
                //                 value: response.data!)
                //           ],
                child: MaterialApp(
                  theme: ThemeData(
                      appBarTheme: AppBarTheme(color: primaryColor),
                      brightness: Brightness.dark,
                      primaryColor: primaryColor,
                      colorScheme: ColorScheme.dark()),
                  home: TabSessionView(
                    user: state.user,
                    sessionCubit: context.read<SessionCubit>(),
                  ),
                ),
              )
          ],
          onPopPage: (route, result) {
            return route.didPop(result);
          });
    });
  }
}
