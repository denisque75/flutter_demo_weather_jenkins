import 'api_request.dart';

class PostRequest extends ApiRequest {
  PostRequest({
    required String urlSuffix,
    Map<String, dynamic>? payload,
  }) : super(urlSuffix, payload);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'RequestType': 'POST'};
  }

  @override
  String getRequestType() {
    return 'POST';
  }
}
