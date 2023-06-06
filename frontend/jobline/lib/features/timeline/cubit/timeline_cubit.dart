import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobline/shared/data/timeline/models/current_timeline.dart';
import 'package:jobline/shared/data/timeline/models/job.dart';
import 'package:jobline/shared/data/timeline/models/steps.dart';
import 'package:jobline/shared/data/timeline/models/timeline.dart';
import 'package:jobline/shared/data/timeline/timeline_repository.dart';

part 'timeline_state.dart';

class TimelineCubit extends Cubit<TimelineState> {
  TimelineCubit(this.timelineRepository) : super(const TimelineState());

  final TimelineRepository timelineRepository;

  Future<void> getAllTimeline() async {
    try {
      emit(state.copyWith(isPageLoading: true));
      final timelines = await timelineRepository.getAllTimelineRepo();
      CurrentTimeline? currentTimeline;
      if (timelines.timelines != null && timelines.timelines!.isNotEmpty) {
        final jobId = timelines.timelines?[0].id;
        currentTimeline = await timelineRepository.getTimelineRepo(jobId!);
      }

      emit(state.copyWith(
        timelines: timelines,
        isTimelineSuccess: false,
        currentTimeline: currentTimeline,
      ));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> getTimeline(int index) async {
    emit(state.copyWith(
      isPageLoading: true,
    ));
    try {
      final jobId = state.timelines!.timelines![index].id;
      final currentTimeline = await timelineRepository.getTimelineRepo(jobId!);
      emit(state.copyWith(
        currentTimeline: currentTimeline,
      ));
    } catch (err) {
      emit(state.copyWith(
        error: err.toString(),
      ));
    }
  }

  Future<void> getTimelineWithId(String id) async {
    emit(state.copyWith(
      isPageLoading: true,
    ));
    try {
      final currentTimeline = await timelineRepository.getTimelineRepo(id);
      emit(state.copyWith(
        currentTimeline: currentTimeline,
      ));
    } catch (err) {
      emit(state.copyWith(
        error: err.toString(),
      ));
    }
  }

  Future<void> createJobTimeline(Job job) async {
    emit(state.copyWith(isButtonLoading: true));
    try {
      final response = await timelineRepository.createJobTimelineRepo(job);
      //todo: update the timelines model
      List<Timeline> newTimelines = [];
      if (state.timelines != null) {
        newTimelines = List.from(state.timelines!.timelines!);
      }
      newTimelines.insert(0, response);
      //set isTimelineCreationSuccess to false only after saving the timeline
      //otherwise set to true for checking if there is a pending timeline to save

      //step creation according to number of phases
      List<Steps> steps = [];

      for (int i = 0; i < job.totalPhases!; i++) {
        steps.add(Steps(
            name: "Phase ${i + 1}",
            description: "Description ${i + 1}",
            eta: i + 1,
            id: "",
            order: i,
            timelineId: "",
            v: i));
      }

      emit(state.copyWith(
          isTimelineSuccess: true,
          timelineMode: TimelineMode.edit,
          successMssg: "Successfully created Timeline.",
          currentTimeline: CurrentTimeline(
              timeline: response, numberOfSteps: job.totalPhases, steps: steps),
          timelines: Timelines(timelines: newTimelines)));
    } catch (err) {
      emit(state.copyWith(error: err.toString(), isButtonLoading: false));
    }
  }

  Future<void> updateTimeline(List<Steps> steps, String jobId) async {
    emit(state.copyWith(isButtonLoading: true));
    try {
      final timelines =
          await timelineRepository.updateTimelineRepo(steps, jobId);

      emit(state.copyWith(
          // currentTimeline: timelines,
          timelineMode: TimelineMode.create));
      // getAllTimeline();
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }
}
