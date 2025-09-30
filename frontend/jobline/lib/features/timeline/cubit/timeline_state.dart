part of 'timeline_cubit.dart';

enum TimelineMode { edit, create, general }

class TimelineState extends Equatable {
  final Timelines? timelines;
  final CurrentTimeline? currentTimeline;
  final bool isWithdrawn;
  final bool isButtonLoading;
  final bool focusLastTextField;
  final bool isPageLoading;
  final bool isTimelineSuccess;
  final bool isDeleteButtonLoading;
  final TimelineMode timelineMode;
  final String? error;
  final String? successMssg;

  const TimelineState(
      {this.timelines,
      this.error,
      this.focusLastTextField = false,
      this.successMssg,
      this.isDeleteButtonLoading = false,
      this.timelineMode = TimelineMode.create,
      this.currentTimeline,
      this.isPageLoading = false,
      this.isTimelineSuccess = false,
      this.isButtonLoading = false,
      this.isWithdrawn = false});

  TimelineState copyWith(
      {Timelines? timelines,
      String? successMssg,
      bool? focusLastTextField,
      String? error,
      CurrentTimeline? currentTimeline,
      bool? isPageLoading,
      bool? isDeleteButtonLoading,
      TimelineMode? timelineMode,
      bool? isTimelineSuccess,
      bool? isButtonLoading,
      bool? isWithdrawn}) {
    return TimelineState(
        timelines: timelines ?? this.timelines,
        error: error,
        focusLastTextField: focusLastTextField ?? false,
        isDeleteButtonLoading: isDeleteButtonLoading ?? false,
        successMssg: successMssg,
        timelineMode: timelineMode ?? this.timelineMode,
        currentTimeline: currentTimeline ?? this.currentTimeline,
        isPageLoading: isPageLoading ?? false,
        isTimelineSuccess: isTimelineSuccess ?? false,
        isButtonLoading: isButtonLoading ?? false,
        isWithdrawn: isWithdrawn ?? false);
  }

  @override
  List<Object?> get props => [
        timelines,
        isWithdrawn,
        currentTimeline,
        isDeleteButtonLoading,
        isPageLoading,
        error,
        timelineMode,
        successMssg,
        isButtonLoading
      ];
}
