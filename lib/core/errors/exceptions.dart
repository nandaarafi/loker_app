class BluetoothConnectionException implements Exception {
  final String message;

  BluetoothConnectionException(this.message);

  @override
  String toString() => 'BluetoothConnectionException: $message';
}
