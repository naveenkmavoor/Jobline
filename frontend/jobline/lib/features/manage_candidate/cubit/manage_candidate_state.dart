part of 'manage_candidate_cubit.dart';

class ManageCandidateState extends Equatable {
  final CurrentTimeline? currentTimelineDetails;
  final CurrentTimeline? copyTimelineDetails;
  final CurrentTimeline? searchQueryTimeline;
  const ManageCandidateState(
      {this.currentTimelineDetails,
      this.copyTimelineDetails,
      this.searchQueryTimeline});

  ManageCandidateState copyWith({
    CurrentTimeline? currentTimelineDetails,
    CurrentTimeline? copyTimelineDetails,
    CurrentTimeline? searchQueryTimeline,
  }) {
    return ManageCandidateState(
      currentTimelineDetails:
          currentTimelineDetails ?? this.currentTimelineDetails,
      copyTimelineDetails: copyTimelineDetails ?? this.copyTimelineDetails,
      searchQueryTimeline: searchQueryTimeline ?? this.searchQueryTimeline,
    );
  }

  @override
  List<Object?> get props =>
      [currentTimelineDetails, copyTimelineDetails, searchQueryTimeline];
}
