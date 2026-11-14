class ApiException implements Exception {
  final String message;
  final int statusCode;
  ApiException(this.message, {this.statusCode = 500});
  @override
  String toString() => message;
}