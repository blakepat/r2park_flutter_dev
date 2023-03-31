// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:r2park_flutter_dev/Screens/auth/sign_up/new_user.dart';
// import '../login/login.dart';
// import 'auth_cubit.dart';

// class AuthNavigator extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
//       return Navigator(
//         pages: [
//           // show login
//           if (state == AuthState.login) MaterialPage(child: Login()),

//           // allow push animation
//           if (state == AuthState.signUp ||
//               state == AuthState.confirmSignUp) ...[
//             //show material page
//             MaterialPage(child: NewUser()),

//             // //show confirm sign up
//             // if (state == AuthState.confirmSignUp)
//             //   MaterialPage(child: ConfirmationView())
//           ]
//         ],
//         onPopPage: (route, result) => route.didPop(result),
//       );
//     });
//   }
// }
