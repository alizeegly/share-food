import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sharefood/SplashScreen/splash_screen.dart';
import 'package:sharefood/authentication/auth_screen.dart';
import 'package:sharefood/mainScreens/home_screen.dart';
import 'package:sharefood/repository/authentication_repository/auth_failure.dart';

class AuthRepository extends GetxController {

  static AuthRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady(){
    Future.delayed(const Duration(seconds: 2));
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }
  
  _setInitialScreen(User? user){
    user == null ? Get.offAll(() => const AuthScreen()) : Get.offAll(() => const HomeScreen());
  }


  

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null ? Get.offAll(() => const HomeScreen()) : Get.to(() => const SplashScreen());
    } on FirebaseAuthException catch(e){
      final ex = SignInWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    } catch(_){
      const ex = SignInWithEmailAndPasswordFailure();
      print('EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch(e){
    } catch(_){
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}