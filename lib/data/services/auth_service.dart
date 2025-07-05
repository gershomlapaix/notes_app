import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      // print('🔐 Attempting sign in for: $email');
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // print('✅ Sign in successful for: ${credential.user?.email}');
      return credential;
    } on FirebaseAuthException catch (e) {
      // print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      // print('❌ General Auth Error: $e');
      throw 'An unexpected error occurred during sign in.';
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email,
      String password,
      ) async {
    try {
      // print('📝 Attempting sign up for: $email');
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // print('✅ Sign up successful for: ${credential.user?.email}');
      return credential;
    } on FirebaseAuthException catch (e) {
      // print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      // print('❌ General Auth Error: $e');
      throw 'An unexpected error occurred during sign up.';
    }
  }

  Future<void> signOut() async {
    try {
      // print('🚪 Signing out user: ${currentUser?.email}');
      await _firebaseAuth.signOut();
      // print('✅ Sign out successful');
    } catch (e) {
      // print('❌ Sign out error: $e');
      throw 'Failed to sign out. Please try again.';
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for this email address.';
      case 'wrong-password':
        return 'Wrong password provided for this email.';
      case 'email-already-in-use':
        return 'An account already exists for this email address.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'invalid-credential':
        return 'The provided credentials are invalid.';
      default:
        return 'Authentication failed: ${e.message ?? 'Unknown error'}';
    }
  }
}