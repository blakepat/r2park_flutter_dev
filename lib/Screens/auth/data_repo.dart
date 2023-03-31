import 'package:r2park_flutter_dev/Managers/UserManager.dart';

import '../../models/user.dart';

class DataRepo {
  Future<void> updateSavedLicensePlates(
      {required List<String> plates, user: User}) async {
    User updatedUser = user.copyWith(licensePlates: plates);
    try {
      // await Amplify.DataStore.save(updatedUser);
    } catch (e) {
      print('auth repo - error saving license plates: $e');
      throw (e);
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      final allUsers = await UserManager().getUsers();
      if (allUsers != null) {
        print('email: $email');
        print('✅ ${allUsers.length}');
        return allUsers.firstWhere((element) => element.email == email);
      }

      // final allUsers = await Amplify.DataStore.query(User.classType);
      // print('ALL USERS: $allUsers');

      // final users = await Amplify.DataStore.query(
      //   User.classType,
      //   where: User.ID.eq(userId),
      // );

      // print('getuserbyID users: $users');
      // return users.isNotEmpty ? users.first : null;
    } catch (e) {
      print('DATA REPO - getuserbyEmail error: $e');
      // throw e;
    }
  }

//   Future<User> createUser() async {
//     //     {required String userId,
//     //     required String email,
//     //     required String phoneNumber,
//     //     required String firstName,
//     //     required String lastName}) async {
//     //   final newUser = User(
//     //       given_name: firstName,
//     //       family_name: lastName,
//     //       email: email,
//     //       id: userId,
//     //       phone_number: phoneNumber);
//     //   try {
//     //     await Amplify.DataStore.save(newUser);
//     //     return newUser;
//     //   } catch (e) {
//     //     print('error creating user in data repo: $e');
//     //     throw e;
//     //   }
//     // }
//     try {
//       return User(id: 1);
//     } catch (e) {
//       throw e;
//     }
//   }
}
