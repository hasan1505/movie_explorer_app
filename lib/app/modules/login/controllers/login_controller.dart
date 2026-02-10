import 'package:get/get.dart';
import 'package:movie_explorer_app/app/modules/login/controllers/auth.dart';
import 'package:movie_explorer_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final RxBool isLoading = false.obs;

  void loginWithGoogle() async {
    try {
      isLoading.value = true;
      
      final userCredential = await _authService.signInWithGoogle();
      
      if (userCredential != null && userCredential.user != null) {
        Get.offAllNamed(Routes.HOME);
        Get.snackbar(
          'Success',
          'Welcome ${userCredential.user!.displayName ?? "User"}!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Cancelled',
          'Google Sign-In was cancelled',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign in: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _authService.signOut();
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to log out: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}