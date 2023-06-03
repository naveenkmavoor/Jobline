part of 'timeline_cubit.dart';

class TimelineState extends Equatable {
  final Timelines? timelines;
  final bool stateUpdate;
  final bool isButtonLoading;
  final bool isTimelineCreationSuccess;
  final String? error;

  const TimelineState(
      {this.timelines,
      this.error,
      this.isTimelineCreationSuccess = false,
      this.isButtonLoading = false,
      this.stateUpdate = false});

  TimelineState copyWith(
      {Timelines? timelines,
      String? error,
      bool? isTimelineCreationSuccess,
      bool? isButtonLoading,
      bool? stateUpdate}) {
    return TimelineState(
        timelines: timelines ?? this.timelines,
        error: error,
        isTimelineCreationSuccess:
            isTimelineCreationSuccess ?? this.isTimelineCreationSuccess,
        isButtonLoading: isButtonLoading ?? this.isButtonLoading,
        stateUpdate: stateUpdate ?? this.stateUpdate);
  }

  @override
  List<Object?> get props =>
      [timelines, stateUpdate, isTimelineCreationSuccess, isButtonLoading];
}
