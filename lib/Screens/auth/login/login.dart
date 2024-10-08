import 'package:flutter/material.dart';
import 'package:r2park_flutter_dev/Managers/constants.dart';
import 'package:r2park_flutter_dev/Managers/database_manager.dart';
import 'package:r2park_flutter_dev/Screens/CustomViews/gradient_button.dart';
import 'package:r2park_flutter_dev/Screens/Session/session_state.dart';
import 'package:r2park_flutter_dev/Screens/auth/sign_up/forgot_password.dart';
import '../../../models/user.dart';
import '../../Session/session_cubit.dart';
import '../sign_up/new_user.dart';

class Login extends StatefulWidget {
  final SessionCubit sessionCubit;
  // List<User> allUsers;
  @override
  // ignore: no_logic_in_create_state
  LoginState createState() => LoginState(sessionCubit: sessionCubit);

  const Login({super.key, required this.sessionCubit});
}

class LoginState extends State<Login> {
  final SessionCubit sessionCubit;
  var databaseManager = DatabaseManager();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;
  String? newPassword;
  String? newEmail;
  List<User>? users;
  User? loggedInUser;

  LoginState({required this.sessionCubit});

  @override
  void initState() {
    super.initState();
  }

  void openDialog(BuildContext context, String dialogTitle, stringContent,
      String dialogContent) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text(dialogTitle),
            content: Text(dialogContent),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Back'))
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    users = sessionCubit.users;
    if (sessionCubit.users == null) {
      sessionCubit.users = users;
      sessionCubit.attemptAutoLogin();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: _createLogoView(),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Email'),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: hidePassword,
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(hidePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      )),
                ),
              ),
              InkWell(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => ForgotPassword()))
                        .then(
                      (obj) {
                        if (obj != null) {
                          //get user
                          final user = users?.firstWhere(
                              (element) => element.email == obj[0]);
                          if (user != null && users != null) {
                            user.password = obj[1];
                            users![users!.indexWhere(
                                    (element) => element.email == user.email)] =
                                user;
                          }
                        }
                      },
                    );
                  },
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: GradientButton(
                    borderRadius: BorderRadius.circular(30),
                    onPressed: () async {
                      final user = await databaseManager.login(
                          usernameController.text, passwordController.text);

                      if (user != null) {
                        print(user.email);
                        Navigator.of(context).pop(widget);
                        sessionCubit.showSession(user);
                      } else {
                        openDialog(context, 'Invalid Data', 'invalid password',
                            'Make sure your username and password are correct');
                      }
                    },
                    child: Text(
                      'Login',
                      style: kButtonTextStyle,
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?',
                      style: TextStyle(fontSize: 18)),
                  InkWell(
                    child: TextButton(
                      child: Text(
                        'Sign up!',
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (context) => NewUser(
                            isManagerScreen: false,
                            sessionCubit: sessionCubit,
                          ),
                        ))
                            .then(
                          (obj) {
                            if (obj != null) {
                              databaseManager.createUser(obj);
                              if (obj.userId == null) {
                                final now = DateTime.now();
                                int id = now.microsecondsSinceEpoch.toInt();
                                obj.userId = id.toString();
                                setState(() {
                                  users?.add(obj as User);
                                });
                              } else {
                                setState(() {
                                  users?.removeWhere((element) =>
                                      element.userId == obj.userId);
                                  users?.add(obj as User);
                                });
                              }
                            }
                          },
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _createLogoView() {
    return Hero(
      tag: 'logo',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: SizedBox(
            height: 180, child: Image.asset('assets/images/3DLogo.png')),
      ),
    );
  }
}
