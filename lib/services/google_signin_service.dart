import 'dart:developer' as developer;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'api_service.dart';
import '../models/api_models.dart';
import '../utils/token_logger.dart';

/// Google Sign-In service with Firebase Authentication
class GoogleSignInService {
  static const String _logTag = 'GoogleSignInService';

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '649888243667-stkada03qhha177idramse0aoic0rc9g.apps.googleusercontent.com',
  );

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Sign in with Google
  static Future<AuthResponse?> signInWithGoogle() async {
    developer.log('🔐 STEP 1: Starting Google Sign-In process', name: _logTag);
    print('� STEP 1: Starting Google Sign-In process');

    try {
      // Check if already signed in
      final bool isSignedIn = await _googleSignIn.isSignedIn();
      developer.log(
        '🔐 STEP 2: Is already signed in: $isSignedIn',
        name: _logTag,
      );
      print('🔐 STEP 2: Is already signed in: $isSignedIn');

      // Clear any existing session
      await _googleSignIn.signOut();
      developer.log('🔐 STEP 3: Cleared any existing session', name: _logTag);
      print('🔐 STEP 3: Cleared any existing session');

      // Trigger the authentication flow
      developer.log(
        '🔐 STEP 4: Triggering Google Sign-In UI...',
        name: _logTag,
      );
      print('� STEP 4: Triggering Google Sign-In UI...');

      final GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();

      if (googleAccount == null) {
        developer.log(
          '🔐 STEP 4 RESULT: ❌ User canceled or sign-in failed',
          name: _logTag,
        );
        print('🔐 STEP 4 RESULT: ❌ User canceled or sign-in failed');
        return null;
      }

      developer.log(
        '🔐 STEP 4 RESULT: ✅ Google account obtained successfully!',
        name: _logTag,
      );
      developer.log('🔐 📧 Email: ${googleAccount.email}', name: _logTag);
      developer.log(
        '🔐 👤 Display Name: ${googleAccount.displayName ?? "Not provided"}',
        name: _logTag,
      );
      developer.log('🔐 🆔 Account ID: ${googleAccount.id}', name: _logTag);
      developer.log(
        '🔐 📸 Photo URL: ${googleAccount.photoUrl ?? "Not provided"}',
        name: _logTag,
      );

      print('🔐 STEP 4 RESULT: ✅ Google account obtained successfully!');
      print('🔐 📧 Email: ${googleAccount.email}');
      print(
        '🔐 👤 Display Name: ${googleAccount.displayName ?? "Not provided"}',
      );
      print('🔐 🆔 Account ID: ${googleAccount.id}');

      // Obtain the auth details from the request
      developer.log(
        '🔐 STEP 5: Getting authentication tokens...',
        name: _logTag,
      );
      print('🔐 STEP 5: Getting authentication tokens...');

      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;

      developer.log(
        '🔐 STEP 5 RESULT: Authentication tokens obtained',
        name: _logTag,
      );
      print('🔐 STEP 5 RESULT: Authentication tokens obtained');

      // Check Access Token
      if (googleAuth.accessToken != null) {
        developer.log(
          '🔐 🎫 Access Token: ✅ Generated (${googleAuth.accessToken!.length} chars)',
          name: _logTag,
        );
        developer.log(
          '🔐 🎫 Access Token Preview: ${googleAuth.accessToken!.substring(0, googleAuth.accessToken!.length > 50 ? 50 : googleAuth.accessToken!.length)}...',
          name: _logTag,
        );
        print(
          '🔐 🎫 Access Token: ✅ Generated (${googleAuth.accessToken!.length} chars)',
        );
      } else {
        developer.log('🔐 🎫 Access Token: ❌ NULL', name: _logTag);
        print('🔐 🎫 Access Token: ❌ NULL');
      }

      // Check ID Token
      if (googleAuth.idToken != null) {
        developer.log(
          '🔐 🆔 Google ID Token: ✅ Generated (${googleAuth.idToken!.length} chars)',
          name: _logTag,
        );
        TokenLogger.logGoogleIdToken(googleAuth.idToken!);
        print(
          '🔐 🆔 Google ID Token: ✅ Generated (${googleAuth.idToken!.length} chars)',
        );
      } else {
        developer.log(
          '🔐 🆔 Google ID Token: ❌ NULL - CRITICAL ERROR!',
          name: _logTag,
        );
        print('🔐 🆔 Google ID Token: ❌ NULL - CRITICAL ERROR!');
      }

      if (googleAuth.idToken == null) {
        developer.log(
          '🔐 ❌ FATAL ERROR: Google ID Token is required but not available',
          name: _logTag,
        );
        print(
          '🔐 ❌ FATAL ERROR: Google ID Token is required but not available',
        );
        throw Exception('Failed to get ID token from Google');
      }

      // CRITICAL: Convert Google credentials to Firebase credentials
      developer.log(
        '🔐 STEP 6: Converting Google credentials to Firebase credentials...',
        name: _logTag,
      );
      print(
        '🔐 STEP 6: Converting Google credentials to Firebase credentials...',
      );

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      developer.log(
        '🔐 STEP 7: Signing in to Firebase with Google credentials...',
        name: _logTag,
      );
      print('🔐 STEP 7: Signing in to Firebase with Google credentials...');

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      developer.log(
        '🔐 STEP 7 RESULT: ✅ Firebase sign-in successful',
        name: _logTag,
      );
      developer.log(
        '🔐 Firebase User ID: ${userCredential.user?.uid}',
        name: _logTag,
      );
      developer.log(
        '🔐 Firebase User Email: ${userCredential.user?.email}',
        name: _logTag,
      );
      print('🔐 STEP 7 RESULT: ✅ Firebase sign-in successful');

      // Get Firebase ID token (this is what backend expects)
      developer.log('🔐 STEP 8: Getting Firebase ID token...', name: _logTag);
      print('🔐 STEP 8: Getting Firebase ID token...');

      final String? firebaseIdToken = await userCredential.user?.getIdToken();

      if (firebaseIdToken == null) {
        throw Exception('Failed to get Firebase ID token');
      }

      developer.log(
        '🔐 STEP 8 RESULT: ✅ Firebase ID token obtained (${firebaseIdToken.length} chars)',
        name: _logTag,
      );
      TokenLogger.logFirebaseIdToken(firebaseIdToken);
      print(
        '🔐 STEP 8 RESULT: ✅ Firebase ID token obtained (${firebaseIdToken.length} chars)',
      );

      // Send the Firebase ID token to backend
      developer.log(
        '🔐 STEP 9: Sending Firebase ID token to backend API...',
        name: _logTag,
      );
      print('🔐 STEP 9: Sending Firebase ID token to backend API...');

      final apiService = ApiService();
      final result = await apiService.googleAuth(firebaseIdToken);

      developer.log('🔐 STEP 9 RESULT: API call completed', name: _logTag);
      print('🔐 STEP 9 RESULT: API call completed');

      return result;
    } catch (e, stackTrace) {
      developer.log(
        '🔐 ❌ EXCEPTION in Google Sign-In: ${e.toString()}',
        name: _logTag,
      );
      developer.log('🔐 📚 Error type: ${e.runtimeType}', name: _logTag);
      developer.log('🔐 📚 Stack trace: $stackTrace', name: _logTag);
      print('🔐 ❌ EXCEPTION in Google Sign-In: ${e.toString()}');
      print('🔐 📚 Error type: ${e.runtimeType}');
      throw Exception('Google Sign-In failed: ${e.toString()}');
    }
  }

  /// Sign out from Google
  static Future<void> signOut() async {
    try {
      developer.log('Signing out from Google', name: _logTag);
      await _googleSignIn.signOut();
      developer.log('Successfully signed out from Google', name: _logTag);
    } catch (e) {
      developer.log('ERROR signing out from Google: $e', name: _logTag);
    }
  }

  /// Check if user is signed in
  static Future<bool> isSignedIn() async {
    try {
      final bool isSignedIn = await _googleSignIn.isSignedIn();
      developer.log('Check if signed in: $isSignedIn', name: _logTag);
      return isSignedIn;
    } catch (e) {
      developer.log('ERROR checking sign-in status: $e', name: _logTag);
      return false;
    }
  }

  /// Get current user
  static GoogleSignInAccount? get currentUser {
    final user = _googleSignIn.currentUser;
    developer.log('Current user: ${user?.email ?? 'null'}', name: _logTag);
    return user;
  }
}
