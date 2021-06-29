import 'api_request.dart';

class DeleteRequest extends ApiRequest {
  DeleteRequest({
    required String urlSuffix,
    Map<String, dynamic> payload = const <String, dynamic>{},
  }) : super(urlSuffix, payload);

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'RequestType': 'DELETE'};
  }

  @override
  String getRequestType() {
    return 'DELETE';
  }
}
