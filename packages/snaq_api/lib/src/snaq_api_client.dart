import 'package:dio/dio.dart';
import 'package:snaq_api/snaq_api.dart';

/// Thrown if an exception occurs while making an `http` request.
class HttpException implements Exception {}

/// {@template http_request_failure}
/// Thrown if an `http` request returns a non-200 status code.
/// {@endtemplate}
class HttpRequestFailure implements Exception {
  /// {@macro http_request_failure}
  const HttpRequestFailure(this.statusCode);

  /// The status code of the response.
  final int? statusCode;
}

/// Thrown when an error occurs while decoding the response body.
class JsonDecodeException implements Exception {}

/// Thrown when an error occurs while deserializing the response body.
class JsonDeserializationException implements Exception {}

/// {@template snaq_api_client}
/// A Dart API Client for the SNAQ API.
/// {@endtemplate}
class SnaqApiClient {
  /// {@macro snaq_api_client}
  SnaqApiClient({Dio? dio}) : _dio = dio ?? Dio();

  /// The host URL used for all API requests.
  static const authority = 'snaq.io';

  final Dio _dio;

  /// Fetches all SNAQ meals (hometask).
  ///
  /// REST call: `GET /hometask/meals`
  Future<List<Meal>> fetchAllMeals() async {
    final uri = Uri.https(authority, '/hometask/meals');
    Response<JsonMap> response;

    try {
      response = await _dio.getUri(uri);
    } catch (_) {
      throw HttpException();
    }

    if (response.statusCode != 200) {
      throw HttpRequestFailure(response.statusCode);
    }

    List<dynamic> responseMeals;
    try {
      responseMeals = response.data!['meals'] as List;
    } catch (_) {
      throw JsonDecodeException();
    }

    try {
      return responseMeals
          .map((dynamic item) => Meal.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw JsonDeserializationException();
    }
  }
}
