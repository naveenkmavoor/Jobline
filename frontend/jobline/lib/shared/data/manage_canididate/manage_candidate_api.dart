import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jobline/shared/data/network_client/dio_client.dart';

class ManageCandidateApi {
  final dioClient = DioClient();
  ManageCandidateApi();

  Future<Response> addCandidateApi(
      {required String timelineId,
      required String stepId,
      required List<String> emails}) async {
    try {
      final Response response = await dioClient.post(
          '/api/user/timeline/$timelineId/step/$stepId',
          data: json.encode({"emails": emails}));

      return response;
    } catch (err) {
      rethrow;
    }
  }
}
