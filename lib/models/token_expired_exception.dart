class TokenExpiredException implements Exception {
  final String message;

  TokenExpiredException(this.message); // Pass your message in constructor.

  @override
  String toString() {
    return message;
  }
}
