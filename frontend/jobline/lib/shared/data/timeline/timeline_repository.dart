import 'package:dio/dio.dart';
import 'package:jobline/shared/data/network_client/dio_exception.dart';
import 'package:jobline/shared/data/timeline/models/current_timeline.dart';
import 'package:jobline/shared/data/timeline/models/job.dart';
import 'package:jobline/shared/data/timeline/models/steps.dart';
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

  Future<CurrentTimeline> getTimelineRepo(String timelineId) async {
    try {
      final Response response = await _timelineApi.getTimeline(timelineId);

      return CurrentTimeline.fromJson(response.data);
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

  Future<CurrentTimeline> updateTimelineRepo(
      List<Steps> steps, String jobId) async {
    try {
      final Response response = await _timelineApi.updateTimeline(steps, jobId);

      return CurrentTimeline.fromJson(response.data);
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }

  Future<void> deletePhaseRepo(String stepId) async {
    try {
      await _timelineApi.deletePhaseApi(stepId);
    } on DioError catch (e) {
      throw DioExceptions.fromDioError(e);
    }
  }
}
