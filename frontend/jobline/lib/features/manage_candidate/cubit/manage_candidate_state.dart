part of 'manage_candidate_cubit.dart';

class ManageCandidateState extends Equatable {
  final CurrentTimeline? currentTimelineDetails;
  final CurrentTimeline? copyTimelineDetails;
  final CurrentTimeline? searchQueryTimeline;
  final bool sendLoading;
  final List<Status> accountsMoved;
  final List<Status> accountsNotMoved;
  final String? error;
  final String? successMssg;

  const ManageCandidateState(
      {this.currentTimelineDetails,
      this.copyTimelineDetails,
      this.sendLoading = false,
      this.searchQueryTimeline,
      this.accountsMoved = const [],
      this.error,
      this.successMssg,
      this.accountsNotMoved = const []});

  ManageCandidateState copyWith(
      {CurrentTimeline? currentTimelineDetails,
      CurrentTimeline? copyTimelineDetails,
      CurrentTimeline? searchQueryTimeline,
      String? error,
      String? successMssg,
      bool? sendLoading,
      List<Status>? accountsMoved,
      List<Status>? accountsNotMoved}) {
    return ManageCandidateState(
      currentTimelineDetails:
          currentTimelineDetails ?? this.currentTimelineDetails,
      copyTimelineDetails: copyTimelineDetails ?? this.copyTimelineDetails,
      searchQueryTimeline: searchQueryTimeline ?? this.searchQueryTimeline,
      sendLoading: sendLoading ?? false,
      error: error,
      successMssg: successMssg,
      accountsMoved: accountsMoved ?? this.accountsMoved,
      accountsNotMoved: accountsNotMoved ?? this.accountsNotMoved,
    );
  }

  @override
  List<Object?> get props => [
        successMssg,
        currentTimelineDetails,
        copyTimelineDetails,
        searchQueryTimeline,
        sendLoading,
        accountsMoved,
        accountsNotMoved
      ];
}
