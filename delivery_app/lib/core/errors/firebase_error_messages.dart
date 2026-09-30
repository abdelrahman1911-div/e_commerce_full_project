import 'package:firebase_auth/firebase_auth.dart';

class FirebaseErrorMessages {
  FirebaseErrorMessages._();
  static String getMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'email_already_in_use';
      case 'invalid-email':
        return 'invalid_email';
      case 'weak-password':
        return 'weak_password';
      case 'wrong-password':
        return 'wrong_password';
      case 'invalid-credential':
        return 'invalid_credential';
      case 'user-not-found':
        return 'user_not_found';
      case 'user-disabled':
        return 'user_disabled';
      case 'too-many-requests':
        return 'too_many_requests';
      case 'operation-not-allowed':
        return 'operation_not_allowed';
      case 'account-exists-with-different-credential':
        return 'account_exists_with_different_credential';
      case 'network-request-failed':
        return 'no_internet';
      case 'requires-recent-login':
        return 'requires_recent_login';
      case 'user-token-expired':
        return 'session_expired';
      default:
        return 'something_went_wrong';
    }
  }
}