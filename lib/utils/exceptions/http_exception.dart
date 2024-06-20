class EffortHttpException implements Exception {
  final int statusCode;
  final String responseBody;

  EffortHttpException(this.statusCode, this.responseBody);

  @override
  String toString() {
    return 'Failed to load data: $statusCode \n$responseBody';
  }
}
