import 'package:get/get.dart';
import 'package:sharefood/models/user_model.dart';
import 'package:sharefood/repository/authentication_repository/auth_repository.dart';
import 'package:sharefood/repository/user_repository/user_repository.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthRepository());
  final _userRepo = Get.put(UserRepository());


  // Get user email and password and pass to repository to fetch user record
  getUserData(){
    final email = _authRepo.firebaseUser.value?.email;
    if(email != null){
      return _userRepo.getUserDetails(email);
    } else {
      Get.snackbar("Error", "Login to continue");
    }
  }

  updateRecord(UserModel user) async {
    await _userRepo.updateUserRecord(user);
  }

}