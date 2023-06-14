import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobline/shared/data/timeline/models/current_timeline.dart';

part 'manage_candidate_state.dart';

class ManageCandidateCubit extends Cubit<ManageCandidateState> {
  ManageCandidateCubit() : super(const ManageCandidateState());

  void getCurrentTimeline(CurrentTimeline currentTimeline) {
    emit(state.copyWith(
        copyTimelineDetails: currentTimeline.copyWith(),
        searchQueryTimeline: currentTimeline.copyWith(),
        currentTimelineDetails: currentTimeline));
  }

  //select a candidate from the list of steps and status and set isSelected to true and the remaining phases isSelected to false

  void selectCandidate(String email, String stepId) {
    final List<Status> statusList = state.copyTimelineDetails!.steps!
        .firstWhere((step) => step.id == stepId)
        .status!;
    for (var element in statusList) {
      if (element.email == email) {
        element.isSelected = !element.isSelected!;
      }
    }
    emit(state.copyWith(
        copyTimelineDetails: state.copyTimelineDetails!.copyWith(
            steps: state.copyTimelineDetails!.steps!
                .map((e) => e.id == stepId
                    ? e.copyWith(status: statusList)
                    : e.copyWith())
                .toList())));
  }

  //move the selected candidate to next steps and set isSelected to false
  void moveToNextStep(
    int currentStepIndex,
  ) {
    final List<Status> statusList =
        state.copyTimelineDetails!.steps![currentStepIndex].status!;
    final List<Status> nextStatusList =
        state.copyTimelineDetails!.steps![currentStepIndex + 1].status!;
    final List<Status> selectedCandidates =
        statusList.where((element) => element.isSelected!).toList();
    selectedCandidates.forEach((element) {
      element.isSelected = false;
      nextStatusList.add(element);
    });
    statusList.removeWhere((element) => element.isSelected!);
    emit(state.copyWith(
        copyTimelineDetails: state.copyTimelineDetails!.copyWith(
            steps: state.copyTimelineDetails!.steps!
                .map((e) => e.id ==
                        state.copyTimelineDetails!.steps![currentStepIndex].id
                    ? e.copyWith(status: statusList)
                    : e.copyWith())
                .toList())));
    emit(state.copyWith(
        copyTimelineDetails: state.copyTimelineDetails!.copyWith(
            steps: state.copyTimelineDetails!.steps!.map((e) {
      if (e.id == state.copyTimelineDetails!.steps![currentStepIndex].id) {
        return e.copyWith(status: statusList);
      } else if (e.id ==
          state.copyTimelineDetails!.steps![currentStepIndex + 1].id) {
        return e.copyWith(status: nextStatusList.reversed.toList());
      } else {
        return e.copyWith();
      }
    }).toList())));
  }

  //search a candidate in a particular step using fuzzy search

  void searchCandidate(String search, String stepId) {
    if (search.isEmpty) {
      emit(state.copyWith(
          searchQueryTimeline: state.copyTimelineDetails?.copyWith()));
      return;
    }
    final List<Status> statusList = state.copyTimelineDetails!.steps!
        .firstWhere((step) => step.id == stepId)
        .status!;
    final List<Status> filteredStatusList = statusList
        .where((element) =>
            element.email!.toLowerCase().contains(search.toLowerCase()))
        .toList();
    emit(state.copyWith(
      searchQueryTimeline: state.copyTimelineDetails!.copyWith(
          steps: state.copyTimelineDetails!.steps!
              .map((e) =>
                  e.id == stepId ? e.copyWith(status: filteredStatusList) : e)
              .toList()),
    ));
  }

  void addCandidate(String stepId, String candidateMail) {
    final List<Status> statusList = state.copyTimelineDetails!.steps!
        .firstWhere((step) => step.id == stepId)
        .status!;
    final List<Status> newStatusList = statusList;
    newStatusList.add(Status(email: candidateMail));
    emit(state.copyWith(
        copyTimelineDetails: state.copyTimelineDetails!.copyWith(
            steps: state.copyTimelineDetails!.steps!
                .map((e) => e.id == stepId
                    ? e.copyWith(status: newStatusList)
                    : e.copyWith())
                .toList())));
  }
}
