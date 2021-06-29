import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/core/app_exceptions.dart';
import 'package:flutter_weather/core/request_model/api_request.dart';
import 'package:flutter_weather/core/request_model/delete_request.dart';
import 'package:flutter_weather/core/request_model/get_request.dart';
import 'package:flutter_weather/core/request_model/patch_request.dart';
import 'package:flutter_weather/core/request_model/post_request.dart';
import 'package:flutter_weather/core/request_model/put_request.dart';
import 'package:flutter_weather/core/utils_repository/shared_preference_manager_impl.dart';
import 'package:flutter_weather/utils/json_reader.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

const Duration _requestTimeout = Duration(seconds: 60);
const int _maxNetworkErrorRetries = 3;

abstract class ApiManager {
  factory ApiManager() => ApiManagerImpl._singleton;

  Future<dynamic> callApiRequest(
    ApiRequest request, {
    bool jsonContentType = false,
    bool withDebugPrint,
  });

  Future<void> logOut();

  Future<dynamic> retry(ApiRequest request);

  static ApiManager of(BuildContext context) => RepositoryProvider.of(context);
}

Map<String, String> _globalHeaders = <String, String>{
  'Content-Type': 'application/x-www-form-urlencoded',
  'Accept': '*/*',
  'Accept-Encoding': 'gzip, deflate, br',
};

Map<String, String> _globalHeadersJsonContentType = <String, String>{
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Accept-Encoding': 'gzip, deflate, br',
  'User-Agent': 'PostmanRuntime/7.26.10'
};

class ApiManagerImpl implements ApiManager {
  String baseUrl = 'https://api.openweathermap.org/data/2.5/';

  static final ApiManagerImpl _singleton = ApiManagerImpl._internal();
  static bool _isInitialized = false;
  late SharedPreferenceManager prefs;

  final Map<ApiRequest, int> _networkFailedRequestAttempts =
      <ApiRequest, int>{};

  factory ApiManagerImpl() {
    return _singleton;
  }

  ApiManagerImpl._internal();

  void init({
    required SharedPreferenceManager prefs,
  }) {
    assert(!_isInitialized);
    this.prefs = prefs;
    _isInitialized = true;
  }

  @override
  Future<dynamic> callApiRequest(
    ApiRequest request, {
    bool jsonContentType = false,
    bool withDebugPrint = false,
  }) async {
    assert(_isInitialized);

    if (withDebugPrint) {
      debugPrint('APIDebugPrint: Request: ${request.urlSuffix}');
      debugPrint('APIDebugPrint: with body: ${request.payload}');
      debugPrint(
          'APIDebugPrint: with headers ${jsonContentType ? _globalHeadersJsonContentType : _globalHeaders}');
    }

    try {
      final dynamic result = await _performRequest(request, jsonContentType);
      return result;
    } on SocketException catch (e) {
      // Crashlytics.instance.recordError(e, stack); // TODO record error
      final Map<String, dynamic> result = await _handleNetworkError(request, e);
      return result;
    } on TimeoutException catch (e) {
      // Crashlytics.instance.recordError(e, stack);  // TODO record error
      final Map<String, dynamic> result = await _handleNetworkError(request, e);
      return result;
    }
  }

  Future<dynamic> _performRequest(
      ApiRequest request, bool jsonContentType) async {
    final Uri url = Uri.parse(baseUrl + request.urlSuffix);

    final Map<String, String> headers = Map<String, String>.of(
        jsonContentType ? _globalHeadersJsonContentType : _globalHeaders);

    Future<Response> responseFuture;
    switch (request.runtimeType) {
      case GetRequest:
        responseFuture = http.get(url, headers: headers);
        break;

      case PostRequest:
        final String encodedBody =
            _encodedBody(jsonContentType, request.payload);

        responseFuture = http.post(url,
            body: encodedBody,
            encoding: Encoding.getByName('utf-8'),
            headers: headers);
        break;

      case PutRequest:
        responseFuture = http.put(url,
            body: request.payload != null ? json.encode(request.payload) : null,
            headers: headers);
        break;

      case PatchRequest:
        responseFuture = http.patch(url,
            body: json.encode(request.payload), headers: headers);
        break;

      case DeleteRequest:
        responseFuture =
            _deleteWithBody(headers, url, request, jsonContentType);
        break;
      default:
        throw ArgumentError("Unknown method ${request.runtimeType}");
    }

    final Response response = await responseFuture.timeout(_requestTimeout);

    if (response.body.contains('403 Forbidden')) {
      throw const SocketException('403 Forbidden');
    }

    _networkFailedRequestAttempts.remove(request);

    return checkResponse(response, request);
  }

  Future<http.Response> _deleteWithBody(
    Map<String, String> headers,
    Uri url,
    ApiRequest deleteRequest,
    bool jsonRequest,
  ) async {
    final http.Request request =
        http.Request(deleteRequest.getRequestType(), url);
    request.headers.addAll(headers);
    request.body = _encodedBody(jsonRequest, deleteRequest.payload);
    final streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }

  String _encodedBody(bool jsonFormat, Map<String, dynamic>? body) {
    if (jsonFormat) {
      return json.encode(body);
    }
    return body != null
        ? body.keys.map((key) => '$key=${body[key]}').join('&')
        : '';
  }

  Future<Map<String, dynamic>> _handleNetworkError(
      ApiRequest request, Exception e) async {
    final int retry = _networkFailedRequestAttempts[request] ?? 0;
    if (retry >= _maxNetworkErrorRetries) {
      _networkFailedRequestAttempts.remove(request);
      throw NoInternetException();
    }

    return <String, dynamic>{};
  }

  dynamic checkResponse(Response response, ApiRequest request) {
    debugPrint('APIDebugPrint: ${response.body}');
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 400:
      case 401:
      case 404:
        final JsonReader jsonReader = JsonReader(json.decode(response.body));
        debugPrint(
            'Error request: ${response.request?.url} with headers: ${response.request?.headers}');
        throw BadRequestException(response.statusCode.toString(),
            jsonReader['details'].asListOf<String>().join('\n'), response.body);

        break;
      case 403:
        throw UnauthorisedException(response.body);
      case 417:
        final JsonReader jsonReader = JsonReader(json.decode(response.body));
        debugPrint(
            'Error request: ${response.request?.url} with headers: ${response.request?.headers}');
        throw PaymentRequestException(
          response.statusCode.toString(),
          jsonReader['message'].asString(),
          jsonReader['timestamp'].asString(),
          jsonReader['redirect'].asString(),
        );
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  @override
  Future<dynamic> retry(ApiRequest request) async {
    return Future<dynamic>.delayed(
        const Duration(seconds: 2), () => callApiRequest(request));
  }

  @override
  Future<void> logOut() async {
    _globalHeaders.remove('Authorization');
    _globalHeadersJsonContentType.remove('Authorization');
    _globalHeaders.remove('OneSignalPlayerID');
    _globalHeadersJsonContentType.remove('OneSignalPlayerID');
  }
}
