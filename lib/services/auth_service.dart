import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<String?> get onAuthStateChanged =>
      _firebaseAuth.authStateChanges().map(
            (user) => user!.uid,
          );

  /// Get uid of current user
  String getCurrentUID() {
    return _firebaseAuth.currentUser!.uid;
  }

  /// Get the current user
  User getCurrentUser() {
    return _firebaseAuth.currentUser!;
  }

  /// Sign Up With email and password
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    UserCredential currentUser = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    if (name != '') {
      await currentUser.user!.updateDisplayName(name);
    }

    return currentUser.user!.uid;
  }

  /// Sign in with email and password
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user!
        .uid;
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  /// reset password
  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// google sign in
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth =
        await account!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: _googleAuth.accessToken,
      idToken: _googleAuth.idToken,
    );

    return (await _firebaseAuth.signInWithCredential(credential)).user!.uid;
  }

  /// Get profile image from third party (google)
  String getProfileImageUrl() {
    return _firebaseAuth.currentUser!.photoURL!;
  }

  /// Update User's information
  Future<void> updateUserInfo(String name) async {
    await _firebaseAuth.currentUser!.updateDisplayName(name);
  }

  /// Change the user's password
  Future<void> changePassword(String oldPassword, String newPassword) async {
    String email = _firebaseAuth.currentUser!.email!;

    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: oldPassword);
    await _firebaseAuth.currentUser!.updatePassword(newPassword);
  }
}
