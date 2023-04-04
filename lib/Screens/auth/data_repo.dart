import 'package:r2park_flutter_dev/Managers/UserManager.dart';

import '../../models/user.dart';

class DataRepo {
  var userManager = UserManager();

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
      final allUsers = await userManager.getUsers();
      print('email: $email');
      print('✅ ${allUsers.length}');
      return allUsers.firstWhere((element) => element.email == email);
    } catch (e) {
      print('DATA REPO - getuserbyEmail error: $e');
    }
  }
}
