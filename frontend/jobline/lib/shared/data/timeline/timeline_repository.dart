import 'package:dio/dio.dart';
import 'package:jobline/shared/data/network_client/dio_exception.dart';
import 'package:jobline/shared/data/timeline/models/job.dart';
import 'package:jobline/shared/data/timeline/models/timeline.dart';
import 'package:jobline/shared/data/timeline/timeline_api.dart';

class TimelineRepository {
  final TimelineApi _timelineApi = TimelineApi();

  TimelineRepository();

  Future<Timelines> getAllTimelineRepo() async {
    try {
      final Response response = await _timelineApi.getAllTimeline();

      return Timelines.fromJson(response.data);
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<Response> getTimelineRepo(String timelineId) async {
    try {
      final Response response = await _timelineApi.getTimeline(timelineId);

      return response;
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<Timeline> createJobTimelineRepo(Job job) async {
    try {
      final Response response = await _timelineApi.createJobTimelineApi(job);
      return Timeline.fromJson(response.data);
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<Response> updateTimelineRepo(String timelineId) async {
    try {
      final Response response = await _timelineApi.updateTimeline(timelineId);

      return response;
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }
}
