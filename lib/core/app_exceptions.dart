import 'dart:convert';

import 'package:flutter_weather/utils/json_reader.dart';

class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return '$_prefix$_message';
  }
}

class NoInternetException extends AppException {
  NoInternetException([String? message])
      : super(message, 'Please check your internet: ');
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, 'Error During Communication: ');
}

class BadRequestException extends AppException {
  final String errorCode;
  final String errorMessage;

  BadRequestException(this.errorCode, this.errorMessage, [String? message])
      : super(message, 'Invalid Request: ' + errorMessage);

  String? findFieldErrorOrNull(String fieldName) {
    if (_message == null) {
      return null;
    }
    final JsonReader jsonReader = JsonReader(json.decode(_message!));
    if (jsonReader.containsKey('fields') &&
        jsonReader['fields'].asMap().containsKey(fieldName)) {
      return jsonReader['fields'][fieldName].asListOf<String>().join('\n');
    }
    return null;
  }
}

class ChangeEmailException extends AppException {
  final String errorCode;
  final String errorMessage;

  ChangeEmailException(this.errorCode, this.errorMessage, [String? message])
      : super(message, 'Invalid Request: ');
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String? message]) : super(message, 'Unauthorised: ');
}

class PaymentRequestException extends AppException {
  final String errorCode;
  final String errorMessage;
  final String timestamp;
  final String redirectUrl;

  PaymentRequestException(
    this.errorCode,
    this.errorMessage,
    this.timestamp,
    this.redirectUrl, [
    String? message,
  ]) : super(message, 'PaymentRequestException: ');
}
