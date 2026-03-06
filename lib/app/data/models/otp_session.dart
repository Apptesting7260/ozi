class OtpSession {
  final String verificationId;
  final DateTime sentAt;
  final Duration validFor;

  OtpSession({
    required this.verificationId,
    required this.sentAt,
    this.validFor = const Duration(seconds: 60),
  });

  bool get isExpired => DateTime.now().difference(sentAt) > validFor;

  int get secondsRemaining {
    final remaining =
        validFor.inSeconds - DateTime.now().difference(sentAt).inSeconds;
    return remaining > 0 ? remaining : 0;
  }
}
