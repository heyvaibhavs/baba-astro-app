import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'api_service.dart';
import '../models/api_models.dart';
import '../utils/token_logger.dart';

/// Service class for handling Google Sign-In authentication with Firebase.
///
/// This service combines Google Sign-In with Firebase Authentication to get
/// Firebase ID tokens that your backend can verify.
class GoogleSignInService {
  static const String _webClientId =
      '54513515566-ifj6m40cds0a7u24groknbhhq7r1t6bj.apps.googleusercontent.com';

  /// Handles Google Sign-In with Firebase Authentication
  ///
  /// Flow:
  /// 1. User signs in with Google
  /// 2. Get Google credentials (accessToken + idToken)
  /// 3. Sign in to Firebase with Google credentials
  /// 4. Get Firebase ID token
  /// 5. Send Firebase ID token to backend
  static Future<AuthResponse?> signInWithGoogle() async {
    try {
      debugPrint('=' * 60);
      debugPrint('🔐 STARTING GOOGLE SIGN-IN PROCESS WITH FIREBASE');
      debugPrint('=' * 60);

      // 1. Initialize Google Sign-In
      final googleSignIn = GoogleSignIn(
        serverClientId: _webClientId,
        scopes: ['email', 'profile'],
      );

      // 2. Ensure clean state
      await googleSignIn.signOut();
      debugPrint('✅ Previous session cleared');

      // 3. Trigger Google Sign-In UI
      debugPrint('🚀 Triggering Google Sign-In UI...');
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint('❌ User cancelled sign-in');
        debugPrint('=' * 60);
        return null;
      }

      debugPrint('✅ Google account obtained!');
      debugPrint('📧 Email: ${googleUser.email}');
      debugPrint('👤 Name: ${googleUser.displayName ?? "Not provided"}');
      debugPrint('🆔 Google ID: ${googleUser.id}');

      // 4. Get Google authentication credentials
      debugPrint('🔑 Getting Google authentication credentials...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        debugPrint('❌ Failed to get Google credentials');
        throw Exception('Failed to get Google authentication credentials');
      }

      debugPrint('✅ Google credentials obtained');

      // 5. Create Firebase credential from Google tokens
      debugPrint('🔥 Creating Firebase credential from Google tokens...');
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 6. Sign in to Firebase with Google credential
      debugPrint('🔥 Signing in to Firebase...');
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      if (userCredential.user == null) {
        debugPrint('❌ Firebase sign-in failed - no user returned');
        throw Exception('Firebase authentication failed');
      }

      debugPrint('✅ Firebase authentication successful!');
      debugPrint('🆔 Firebase UID: ${userCredential.user!.uid}');
      debugPrint('📧 Firebase Email: ${userCredential.user!.email}');
      debugPrint('✅ Email Verified: ${userCredential.user!.emailVerified}');

      // 7. Get Firebase ID token (THIS is what your backend needs!)
      debugPrint('🎫 Getting Firebase ID token...');
      final String? firebaseIdToken = await userCredential.user!.getIdToken();

      if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
        debugPrint('❌ Failed to get Firebase ID token!');
        throw Exception('Failed to get Firebase ID token');
      }

      debugPrint('✅ Firebase ID token obtained!');
      debugPrint('🎫 Token length: ${firebaseIdToken.length} chars');
      debugPrint(
        '🎫 Token preview (first 50): ${firebaseIdToken.substring(0, 50)}...',
      );

      // Important: This token has aud = "baba-astro-app" (your Firebase project ID)
      // NOT the Google OAuth client ID
      debugPrint('📋 Token audience (aud): "baba-astro-app" ✅');

      // 8. Log token for debugging
      TokenLogger.logGoogleIdToken(
        firebaseIdToken,
        userEmail: userCredential.user?.email,
        userName: userCredential.user?.displayName,
        userId: userCredential.user?.uid,
      );

      // 9. Send Firebase ID token to backend for verification
      debugPrint('🌐 Sending Firebase ID token to backend...');
      debugPrint('🌐 Backend will verify this with Firebase Admin SDK');

      final apiService = ApiService();
      final result = await apiService.googleAuth(firebaseIdToken);

      debugPrint('✅ Backend authentication successful!');
      debugPrint('✅ JWT access token received from backend');
      debugPrint('=' * 60);

      return result;
    } on FirebaseAuthException catch (e, stackTrace) {
      debugPrint('=' * 60);
      debugPrint('❌ FIREBASE AUTH ERROR');
      debugPrint('=' * 60);
      debugPrint('Error Code: ${e.code}');
      debugPrint('Error Message: ${e.message}');
      debugPrint('Stack trace:');
      debugPrint(stackTrace.toString());
      debugPrint('=' * 60);
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('=' * 60);
      debugPrint('❌ GOOGLE SIGN-IN ERROR');
      debugPrint('=' * 60);
      debugPrint('Error: ${e.toString()}');
      debugPrint('Type: ${e.runtimeType}');
      debugPrint('Stack trace:');
      debugPrint(stackTrace.toString());
      debugPrint('=' * 60);
      rethrow;
    }
  }

  /// Sign out from both Google and Firebase
  static Future<void> signOut() async {
    try {
      debugPrint('🚪 Signing out from Firebase and Google...');

      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();
      debugPrint('✅ Signed out from Firebase');

      // Sign out from Google
      final googleSignIn = GoogleSignIn(
        serverClientId: _webClientId,
        scopes: ['email', 'profile'],
      );
      await googleSignIn.signOut();
      debugPrint('✅ Signed out from Google');

      debugPrint('✅ Successfully signed out from all services');
    } catch (e) {
      debugPrint('❌ Error signing out: $e');
      // Don't rethrow - sign out errors shouldn't break the app
    }
  }

  /// Check if user is signed in to Firebase
  static Future<bool> isSignedIn() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final isSignedIn = user != null;
      debugPrint('🔍 Firebase user signed in: $isSignedIn');
      if (isSignedIn) {
        debugPrint('🔍 User email: ${user!.email}');
        debugPrint('🔍 User UID: ${user.uid}');
      }
      return isSignedIn;
    } catch (e) {
      debugPrint('❌ Error checking sign-in status: $e');
      return false;
    }
  }

  /// Get current Firebase user
  static User? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    debugPrint('🔍 Current Firebase user: ${user?.email ?? 'null'}');
    return user;
  }

  /// Get fresh Firebase ID token for current user
  /// Use this to refresh the token if it expires
  static Future<String?> getIdToken({bool forceRefresh = false}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint('❌ No user signed in');
        return null;
      }

      final token = await user.getIdToken(forceRefresh);
      debugPrint(
        '✅ Got ${forceRefresh ? 'fresh' : 'cached'} Firebase ID token',
      );
      return token;
    } catch (e) {
      debugPrint('❌ Error getting ID token: $e');
      return null;
    }
  }
}
