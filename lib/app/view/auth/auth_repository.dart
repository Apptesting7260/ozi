import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/otp_session.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<OtpSession> sendOtp(String phone) async {
    late String verificationIdCompleter;

    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (_) {},
      verificationFailed: (e) {
        throw e;
      },
      codeSent: (verificationId, _) {
        verificationIdCompleter = verificationId;
      },
      codeAutoRetrievalTimeout: (_) {},
    );

    return OtpSession(
      verificationId: verificationIdCompleter,
      sentAt: DateTime.now(),
    );
  }

  Future<void> verifyOtp(
      String verificationId,
      String otp,
      ) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    await _auth.signInWithCredential(credential);
  }
}