part of 'timeline_cubit.dart';

class TimelineState extends Equatable {
  final Timelines? timelines;
  final CurrentTimeline? currentTimeline;
  final bool stateUpdate;
  final bool isButtonLoading;
  final bool isPageLoading;
  final bool isTimelineCreationSuccess;
  final String? error;

  const TimelineState(
      {this.timelines,
      this.error,
      this.currentTimeline,
      this.isPageLoading = false,
      this.isTimelineCreationSuccess = false,
      this.isButtonLoading = false,
      this.stateUpdate = false});

  TimelineState copyWith(
      {Timelines? timelines,
      String? error,
      CurrentTimeline? currentTimeline,
      bool? isPageLoading,
      bool? isTimelineCreationSuccess,
      bool? isButtonLoading,
      bool? stateUpdate}) {
    return TimelineState(
        timelines: timelines ?? this.timelines,
        error: error,
        currentTimeline: currentTimeline ?? this.currentTimeline,
        isPageLoading: isPageLoading ?? false,
        isTimelineCreationSuccess:
            isTimelineCreationSuccess ?? this.isTimelineCreationSuccess,
        isButtonLoading: isButtonLoading ?? false,
        stateUpdate: stateUpdate ?? this.stateUpdate);
  }

  @override
  List<Object?> get props => [
        timelines,
        stateUpdate,
        isTimelineCreationSuccess,
        currentTimeline,
        isPageLoading,
        isButtonLoading
      ];
}
