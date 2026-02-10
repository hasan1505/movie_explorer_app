import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<User?> firebaseUser = Rx<User?>(null);
  
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  AuthService() {
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  bool get isAuthenticated => firebaseUser.value != null;
  User? get user => firebaseUser.value;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('🔵 Starting Google Sign-In...');

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('🔴 User cancelled sign-in');
        return null;
      }

      print('🟢 Google user selected: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      print('🟢 Got authentication tokens');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🟢 Created Firebase credential');

      final userCredential = await _auth.signInWithCredential(credential);
      
      print('🟢 Signed in to Firebase: ${userCredential.user?.email}');

      return userCredential;
    } catch (e, stackTrace) {
      print('🔴 Error signing in with Google: $e');
      print('🔴 Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      print('🟢 Signed out successfully');
    } catch (e) {
      print('🔴 Error signing out: $e');
      rethrow;
    }
  }
}