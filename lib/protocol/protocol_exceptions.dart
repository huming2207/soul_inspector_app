class InvalidPacketLengthException implements Exception {
  String cause;
  InvalidPacketLengthException(this.cause);
}