part of 'manage_candidate_cubit.dart';

class ManageCandidateState extends Equatable {
  final CurrentTimeline? currentTimelineDetails;
  final CurrentTimeline? copyTimelineDetails;
  final CurrentTimeline? searchQueryTimeline;
  final bool sendInviteLoading;
  const ManageCandidateState(
      {this.currentTimelineDetails,
      this.copyTimelineDetails,
      this.sendInviteLoading = false,
      this.searchQueryTimeline});

  ManageCandidateState copyWith({
    CurrentTimeline? currentTimelineDetails,
    CurrentTimeline? copyTimelineDetails,
    CurrentTimeline? searchQueryTimeline,
    bool? sendInviteLoading,
  }) {
    return ManageCandidateState(
      currentTimelineDetails:
          currentTimelineDetails ?? this.currentTimelineDetails,
      copyTimelineDetails: copyTimelineDetails ?? this.copyTimelineDetails,
      searchQueryTimeline: searchQueryTimeline ?? this.searchQueryTimeline,
      sendInviteLoading: sendInviteLoading ?? false,
    );
  }

  @override
  List<Object?> get props => [
        currentTimelineDetails,
        copyTimelineDetails,
        searchQueryTimeline,
        sendInviteLoading
      ];
}
