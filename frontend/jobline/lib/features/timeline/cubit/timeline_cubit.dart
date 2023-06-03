import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobline/shared/data/timeline/models/job.dart';
import 'package:jobline/shared/data/timeline/models/timeline.dart';
import 'package:jobline/shared/data/timeline/timeline_repository.dart';

part 'timeline_state.dart';

class TimelineCubit extends Cubit<TimelineState> {
  TimelineCubit(this.timelineRepository) : super(const TimelineState());

  final TimelineRepository timelineRepository;

  Future<void> getAllTimeline() async {
    try {
      final timelines = await timelineRepository.getAllTimelineRepo();
      emit(state.copyWith(timelines: timelines));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> getTimeline() async {
    try {
      final timelines = await timelineRepository.getAllTimelineRepo();
    } catch (err) {}
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
      newTimelines.add(response);
      //set isTimelineCreationSuccess to false only after saving the timeline
      //otherwise set to true for checking if there is a pending timeline to save
      emit(state.copyWith(
          isTimelineCreationSuccess: true,
          isButtonLoading: false,
          timelines: Timelines(timelines: newTimelines)));
    } catch (err) {
      emit(state.copyWith(error: err.toString(), isButtonLoading: false));
    }
  }

  Future<void> updateTimeline() async {
    try {
      final timelines = await timelineRepository.getAllTimelineRepo();
    } catch (err) {}
  }
}
