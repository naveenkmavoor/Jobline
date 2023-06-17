import 'package:dio/dio.dart';
import 'package:jobline/shared/data/manage_canididate/manage_candidate_api.dart';
import 'package:jobline/shared/data/network_client/dio_exception.dart';
import 'package:jobline/shared/data/timeline/models/current_timeline.dart';

class ManageCandidateRepository {
  final _manageCandidateApi = ManageCandidateApi();

  ManageCandidateRepository();

  Future<List<Status>> addCandidateRepo(
      {required String timelineId,
      required String stepId,
      required List<String> emails}) async {
    try {
      final Response response = await _manageCandidateApi.addCandidateApi(
          timelineId: timelineId, stepId: stepId, emails: emails);

      return response.data.map<Status>((e) => Status.fromJson(e)).toList();
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<void> moveCandidatesRepo({
    required String timelineId,
    required List<Status> accountsMoved,
  }) async {
    try {
      await _manageCandidateApi.moveCandidatesApi(
          timelineId: timelineId, accountsMoved: accountsMoved);
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }
}
