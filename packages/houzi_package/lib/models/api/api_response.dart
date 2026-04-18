class ApiResponse<T> {
  final T result;
  final bool success;
  final bool internet;
  final String message;
  final int? count;

  const ApiResponse({
    required this.success,
    required this.message,
    required this.internet,
    required this.result,
    this.count,
  });
}
