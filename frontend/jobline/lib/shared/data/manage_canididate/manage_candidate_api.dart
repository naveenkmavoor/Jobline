import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jobline/shared/data/network_client/dio_client.dart';
import 'package:jobline/shared/data/timeline/models/current_timeline.dart';

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

  Future<void> moveCandidatesApi(
      {required String timelineId, required List<Status> accountsMoved}) async {
    try {
      await dioClient.post('/api/user/moveUser/$timelineId',
          data: json.encode(accountsMoved
              .map((e) => {
                    "stepId": e.stepId,
                    "email": e.email,
                  })
              .toList()));
    } catch (err) {
      rethrow;
    }
  }
}
