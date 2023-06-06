part of 'timeline_cubit.dart';

enum TimelineMode { edit, create, general }

class TimelineState extends Equatable {
  final Timelines? timelines;
  final CurrentTimeline? currentTimeline;
  final bool stateUpdate;
  final bool isButtonLoading;
  final bool isPageLoading;
  final bool isTimelineSuccess;
  final TimelineMode timelineMode;
  final String? error;
  final String? successMssg;

  const TimelineState(
      {this.timelines,
      this.error,
      this.successMssg,
      this.timelineMode = TimelineMode.create,
      this.currentTimeline,
      this.isPageLoading = false,
      this.isTimelineSuccess = false,
      this.isButtonLoading = false,
      this.stateUpdate = false});

  TimelineState copyWith(
      {Timelines? timelines,
      String? successMssg,
      String? error,
      CurrentTimeline? currentTimeline,
      bool? isPageLoading,
      TimelineMode? timelineMode,
      bool? isTimelineSuccess,
      bool? isButtonLoading,
      bool? stateUpdate}) {
    return TimelineState(
        timelines: timelines ?? this.timelines,
        error: error,
        successMssg: successMssg ?? this.successMssg,
        timelineMode: timelineMode ?? this.timelineMode,
        currentTimeline: currentTimeline ?? this.currentTimeline,
        isPageLoading: isPageLoading ?? false,
        isTimelineSuccess: isTimelineSuccess ?? false,
        isButtonLoading: isButtonLoading ?? false,
        stateUpdate: stateUpdate ?? this.stateUpdate);
  }

  @override
  List<Object?> get props => [
        timelines,
        stateUpdate,
        currentTimeline,
        isPageLoading,
        timelineMode,
        successMssg,
        isButtonLoading
      ];
}
