import 'api_request.dart';

class PutRequest extends ApiRequest {
  PutRequest({
    required String urlSuffix,
    Map<String, dynamic>? payload,
  }) : super(urlSuffix, payload);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'RequestType': 'PUT'};
  }

  @override
  String getRequestType() {
    return 'PUT';
  }
}
