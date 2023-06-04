import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jobline/shared/data/network_client/dio_client.dart';
import 'package:jobline/shared/data/timeline/models/job.dart';
import 'package:jobline/shared/data/timeline/models/steps.dart';

class TimelineApi {
  final dioClient = DioClient();
  TimelineApi();

  Future<Response> getAllTimeline() async {
    try {
      final Response response = await dioClient.get('/api');

      return response;
    } catch (err) {
      rethrow;
    }
  }

  Future<Response> getTimeline(String timelineId) async {
    try {
      final Response response = await dioClient.get('/api/$timelineId');

      return response;
    } catch (err) {
      rethrow;
    }
  }

  Future<Response> createJobTimeline(Job job) async {
    try {
      final Response response =
          await dioClient.post('/api', data: json.encode({job.toJson()}));

      return response;
    } catch (err) {
      rethrow;
    }
  }

  Future<Response> updateTimeline(List<Steps> steps, String jobId) async {
    try {
      final Response response = await dioClient.post('/api/$jobId',
          data: json.encode(steps.map((e) => e.toJson()).toList()));

      return response;
    } catch (err) {
      rethrow;
    }
  }

  Future<Response> createJobTimelineApi(Job job) async {
    try {
      final Response response =
          await dioClient.post('/api/', data: json.encode(job.toJson()));

      return response;
    } catch (err) {
      rethrow;
    }
  }
}
