import 'package:dio/dio.dart';

class ApiRequest<T> {
  Uri uri;
  Map<String, dynamic>? formParams;
  Map<String, String>? headers;
  Map<String, String>? fields;
  String? fileField;
  String? httpRequestMethod;
  FormData? formData;
  bool handle500;
  String tag;

  ApiRequest({
    required this.uri,
    this.formParams = const {},
    this.headers,
    this.fields,
    this.fileField,
    this.httpRequestMethod,
    this.formData,
    this.handle500 = false,
    this.tag = "",
  });
}