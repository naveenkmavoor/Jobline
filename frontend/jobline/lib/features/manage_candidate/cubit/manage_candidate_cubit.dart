import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobline/shared/data/manage_canididate/manage_candidate_repository.dart';
import 'package:jobline/shared/data/timeline/models/current_timeline.dart';

part 'manage_candidate_state.dart';

enum MoveToNextStep { moveToBackStep, moveToFrontStep }

class ManageCandidateCubit extends Cubit<ManageCandidateState> {
  final ManageCandidateRepository repository;
  ManageCandidateCubit(this.repository) : super(const ManageCandidateState());

  void getCurrentTimeline(CurrentTimeline currentTimeline) {
    emit(state.copyWith(
        accountsMoved: [],
        accountsNotMoved: [],
        copyTimelineDetails: currentTimeline.copyWith(
            steps: currentTimeline.steps!
                .map((e) => e.copyWith(
                    status: e.status!.map((e) => e.copyWith()).toList()))
                .toList()),
        searchQueryTimeline: currentTimeline.copyWith(
          steps: currentTimeline.steps!
              .map((e) => e.copyWith(
                  status: e.status!.map((e) => e.copyWith()).toList()))
              .toList(),
        ),
        currentTimelineDetails: currentTimeline));
  }

  //select a candidate from the list of steps and status and set isSelected to true and the remaining phases isSelected to false

  void selectCandidate(String email, String stepId) {
    // final List<Status> statusList = state.copyTimelineDetails!.steps!
    //     .firstWhere((step) => step.id == stepId)
    //     .status!;

    // for (var element in statusList) {
    //   if (element.email == email) {
    //     element.isSelected = !element.isSelected!;
    //   }
    // }

    //change the remaining steps status except the step with id isSelected to false
    for (var step in state.searchQueryTimeline!.steps!) {
      if (step.id != stepId) {
        for (var status in step.status!) {
          status.isSelected = false;
        }
      } else {
        for (var status in step.status!) {
          if (status.email == email) {
            status.isSelected = !status.isSelected;
            break;
          }
        }
      }
    }

// state is being directly modified here
    for (var step in state.copyTimelineDetails!.steps!) {
      if (step.id != stepId) {
        for (var status in step.status!) {
          status.isSelected = false;
        }
      } else {
        for (var status in step.status!) {
          if (status.email == email) {
            status.isSelected = !status.isSelected;
          }
        }
      }
    }

    emit(state.copyWith(
      copyTimelineDetails: state.copyTimelineDetails!.copyWith(
          steps: state.copyTimelineDetails!.steps!
              .map((e) => e.id == stepId ? e.copyWith() : e)
              .toList()),
    ));
  }

  // void _modifyCurrentTimeline(CurrentTimeline timeline,String stepId)

  //move the selected candidate to next steps and set isSelected to false
  void moveToNextStep(
      {required int currentStepIndex, required MoveToNextStep moveToNextStep}) {
    final statusList = List<Status>.from(state
        .copyTimelineDetails!.steps![currentStepIndex].status!
        .map((e) => e.copyWith()));
    final List<Status> selectedCandidates = statusList
        .where((element) => element.isSelected)
        .map((e) => e.copyWith())
        .toList();
    if (selectedCandidates.isEmpty) {
      return;
    }
    int nextStepIndex;
    if (moveToNextStep == MoveToNextStep.moveToFrontStep) {
      nextStepIndex = currentStepIndex + 1;
    } else {
      nextStepIndex = currentStepIndex - 1;
    }
    final nextStatusList = List<Status>.from(state
        .copyTimelineDetails!.steps![nextStepIndex].status!
        .map((e) => e.copyWith()));

    selectedCandidates.forEach((element) {
      element.isSelected = false;
      nextStatusList.add(element);
    });
    statusList.removeWhere((element) => element.isSelected);
    final resultCopyTimelineDetails = state.copyTimelineDetails!.copyWith(
        steps: state.copyTimelineDetails!.steps!.map((e) {
      if (e.id == state.copyTimelineDetails!.steps![currentStepIndex].id) {
        return e.copyWith(status: statusList);
      } else if (e.id == state.copyTimelineDetails!.steps![nextStepIndex].id) {
        return e.copyWith(status: nextStatusList.reversed.toList());
      } else {
        return e.copyWith();
      }
    }).toList());
    final resultSearchTimeline = resultCopyTimelineDetails.copyWith(
        steps: resultCopyTimelineDetails.steps!
            .map((e) =>
                e.copyWith(status: e.status!.map((e) => e.copyWith()).toList()))
            .toList());
    emit(state.copyWith(
        searchQueryTimeline: resultSearchTimeline,
        copyTimelineDetails: resultCopyTimelineDetails));
  }

  //search a candidate in a particular step using fuzzy search

  void searchCandidate(String search, String stepId) {
    if (search.isEmpty) {
      emit(state.copyWith(
          searchQueryTimeline: state.copyTimelineDetails?.copyWith(
              steps: state.copyTimelineDetails?.steps
                  ?.map((e) => e.copyWith(
                      status: e.status!.map((e) => e.copyWith()).toList()))
                  .toList())));
      return;
    }
    final statusList = List<Status>.from(state.copyTimelineDetails!.steps!
        .firstWhere((step) => step.id == stepId)
        .status!
        .map((e) => e.copyWith()));
    final List<Status> filteredStatusList = statusList
        .where((element) =>
            element.email!.toLowerCase().contains(search.toLowerCase()))
        .toList();
    emit(state.copyWith(
      searchQueryTimeline: state.copyTimelineDetails!.copyWith(
          steps: state.copyTimelineDetails!.steps!
              .map((e) => e.id == stepId
                  ? e.copyWith(status: filteredStatusList)
                  : e.copyWith())
              .toList()),
    ));
  }

  Future<void> addCandidate(
      String stepId, List<String> emails, String link) async {
    emit(state.copyWith(sendLoading: true));
    try {
      if (emails.isEmpty) {
        emit(state.copyWith(
            error:
                "Please enter an email then press enter/space before pressing invite button"));
      } else {
        final List<Status> statusList = state.copyTimelineDetails!.steps!
            .firstWhere((step) => step.id == stepId)
            .status!;

        final resultEmailLists = await repository.addCandidateRepo(
            timelineId: state.currentTimelineDetails!.timeline!.id!,
            stepId: stepId,
            emails: emails,
            link: link);
        statusList.addAll(resultEmailLists);
        emit(state.copyWith(
            searchQueryTimeline: state.searchQueryTimeline!.copyWith(
                steps: state.searchQueryTimeline!.steps!
                    .map((e) => e.id == stepId
                        ? e.copyWith(
                            status:
                                statusList.map((e) => e.copyWith()).toList())
                        : e.copyWith())
                    .toList()),
            currentTimelineDetails: state.currentTimelineDetails!.copyWith(
                steps: state.currentTimelineDetails!.steps!
                    .map((e) => e.id == stepId
                        ? e.copyWith(
                            status:
                                statusList.map((e) => e.copyWith()).toList())
                        : e.copyWith())
                    .toList()),
            copyTimelineDetails: state.copyTimelineDetails!.copyWith(
                steps: state.copyTimelineDetails!.steps!
                    .map((e) => e.id == stepId
                        ? e.copyWith(
                            status:
                                statusList.map((e) => e.copyWith()).toList())
                        : e.copyWith())
                    .toList())));
      }
    } catch (err) {
      emit(state.copyWith(error: "Failed to add candidate. Please try again."));
    }
    //repository
  }

  void reviewChanges() {
    //compare candidate email is and step id is equal or not
//if not equal then then this candidate is moved to another step

//compare the currentTimelineDetails and copyTimelineDetails and find the difference between the step id
//if the step id is not matching then this candidate is moved to another step
    final accountsMoved = <Status>[];
    final accountsNotMoved = <Status>[];
    final currentStepList = state.currentTimelineDetails!.steps!;
    final copyStepList = state.copyTimelineDetails!.steps!;

    for (int i = 0; i < currentStepList.length; i++) {
      for (var status in currentStepList[i].status!) {
        final val = copyStepList[i].status?.firstWhere(
              (element) => element.email == status.email,
              orElse: () => Status(),
            );
        if (val?.email != null) {
          accountsNotMoved.add(status.copyWith());
        } else {
          accountsMoved.add(status.copyWith());
        }
      }
    }

    //find the phase name of moved accounts in copyTimelineDetails

    for (var status in accountsMoved) {
      for (var copyStep in copyStepList) {
        final statusval = copyStep.status?.firstWhere(
          (element) => element.email == status.email,
          orElse: () => Status(),
        );
        if (statusval?.email != null) {
          status.stepTitle = copyStep.name;
          status.stepId = copyStep.id;
          break;
        }
      }
    }

    emit(state.copyWith(
        accountsMoved: accountsMoved, accountsNotMoved: accountsNotMoved));
  }

  Future<void> moveCandidates() async {
    emit(state.copyWith(sendLoading: true));
    try {
      await repository.moveCandidatesRepo(
        timelineId: state.currentTimelineDetails!.timeline!.id!,
        accountsMoved: state.accountsMoved,
      );
      emit(state.copyWith(
          successMssg: "Candidates moved successfully",
          sendLoading: false,
          accountsMoved: [],
          accountsNotMoved: []));
    } catch (err) {
      emit(state.copyWith(
          error: "Failed to move candidates. Please try again."));
    }
  }
}
