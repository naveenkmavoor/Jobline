import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobline/shared/data/timeline/models/current_timeline.dart';
import 'package:jobline/shared/data/timeline/models/job.dart';
import 'package:jobline/shared/data/timeline/models/steps.dart';
import 'package:jobline/shared/data/timeline/models/timeline.dart';
import 'package:jobline/shared/data/timeline/timeline_repository.dart';
import 'package:jobline/shared/utility.dart';

part 'timeline_state.dart';

class TimelineCubit extends Cubit<TimelineState> {
  TimelineCubit(this.timelineRepository) : super(const TimelineState());

  final TimelineRepository timelineRepository;

  Future<void> getAllTimeline() async {
    try {
      emit(state.copyWith(isPageLoading: true));

      Timelines? timelines;
      Timelines? reverseTimelines;
      CurrentTimeline? currentTimeline;
      if (getUserRole() == 'candidate' && getTimelineId() != null) {
        currentTimeline =
            await timelineRepository.getTimelineRepo(getTimelineId()!);
        timelines = Timelines(timelines: [currentTimeline.timeline!]);
      } else {
        timelines = await timelineRepository.getAllTimelineRepo();

        if (timelines.timelines != null && timelines.timelines!.isNotEmpty) {
          //reversing the job timeline to show the most recently added to the first
          reverseTimelines =
              Timelines(timelines: timelines.timelines!.reversed.toList());
          final jobId = reverseTimelines.timelines?[0].id;

          currentTimeline = await timelineRepository.getTimelineRepo(jobId!);
        }
      }

      emit(state.copyWith(
        timelines: reverseTimelines ?? timelines,
        isTimelineSuccess: false,
        currentTimeline: currentTimeline,
      ));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> getTimeline(int index) async {
    emit(state.copyWith(
      isPageLoading: true,
    ));
    try {
      final jobId = state.timelines!.timelines![index].id;
      final currentTimeline = await timelineRepository.getTimelineRepo(jobId!);
      emit(state.copyWith(
        currentTimeline: currentTimeline,
      ));
    } catch (err) {
      emit(state.copyWith(
        error: err.toString(),
      ));
    }
  }

  Future<void> getTimelineWithId(
      {required String id,
      TimelineMode timelineMode = TimelineMode.general}) async {
    emit(state.copyWith(
      isPageLoading: true,
    ));
    try {
      final currentTimeline = await timelineRepository.getTimelineRepo(id);
      emit(state.copyWith(
          currentTimeline: currentTimeline, timelineMode: timelineMode));
    } catch (err) {
      emit(state.copyWith(
        error: err.toString(),
      ));
    }
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
      //currently job post link is not getting from the server so adding from the state
      newTimelines.insert(0, response.copyWith(jobPostLink: job.jobLinktoPost));
      //set isTimelineCreationSuccess to false only after saving the timeline
      //otherwise set to true for checking if there is a pending timeline to save

      //step creation according to number of phases
      List<Steps> steps = [];

      for (int i = 0; i < job.totalPhases!; i++) {
        steps.add(Steps(
            name: "Phase ${i + 1}",
            description: "Description ${i + 1}",
            eta: i + 1,
            id: "",
            order: i,
            timelineId: "",
            v: i));
      }

      emit(state.copyWith(
          isTimelineSuccess: true,
          timelineMode: TimelineMode.edit,
          successMssg: "Successfully created Timeline.",
          currentTimeline: CurrentTimeline(
            timeline: response.copyWith(jobPostLink: job.jobLinktoPost),
            numberOfSteps: job.totalPhases,
            steps: steps,
          ),
          timelines: Timelines(timelines: newTimelines)));
    } catch (err) {
      emit(state.copyWith(error: err.toString(), isButtonLoading: false));
    }
  }

  void timelineModeChange(TimelineMode timelineMode) {
    emit(state.copyWith(timelineMode: timelineMode));
  }

  void updatePhaseTitle({String? title, required int order}) {
    state.currentTimeline?.steps?.forEach((element) {
      if (order == element.order) {
        element.name = title ?? 'Phase ${order + 1}';
      }
    });
  }

  void updatePhaseDescription({String? description, required int order}) {
    state.currentTimeline?.steps?.forEach((element) {
      if (order == element.order) {
        element.description = description ?? 'Description ${order + 1}';
      }
    });
  }

  void updatePhaseEta({int? eta, required int order}) {
    state.currentTimeline?.steps?.forEach((element) {
      if (order == element.order) {
        element.eta = eta ?? order + 1;
      }
    });
  }

  void addStep() {
    final newlist = List<Steps>.from(state.currentTimeline!.steps!);
    newlist.add(Steps(
        name: "Phase ${newlist.length + 1}",
        description: "Description ${newlist.length + 1}",
        eta: newlist.length + 1,
        id: "",
        order: newlist.length,
        timelineId: "",
        v: newlist.length));
    emit(state.copyWith(
        focusLastTextField: true,
        currentTimeline: state.currentTimeline?.copyWith(steps: newlist)));
  }

  Future<void> deletePhase(String stepId, int order) async {
    emit(state.copyWith(isDeleteButtonLoading: true));
    final newlist = List<Steps>.from(state.currentTimeline!.steps!);

    try {
      if (stepId.isNotEmpty) {
        final timelines = await timelineRepository.deletePhaseRepo(stepId);
      }

      newlist.removeWhere((element) => element.order == order);

      for (int index = 0; index < newlist.length; index++) {
        newlist[index].order = index;
      }

      emit(state.copyWith(
        currentTimeline: state.currentTimeline?.copyWith(steps: newlist),
        successMssg: "Successfully deleted phase!",
      ));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> updateTimeline(List<Steps> steps, String jobId) async {
    emit(state.copyWith(isButtonLoading: true));
    try {
      final timelines =
          await timelineRepository.updateTimelineRepo(steps, jobId);
      //! comment the below line when the changes is done in the backend
      final currentTimeline = await timelineRepository.getTimelineRepo(jobId);
      emit(state.copyWith(
          currentTimeline:
              state.currentTimeline?.copyWith(steps: currentTimeline.steps),
          successMssg: "Successfully saved the timeline!",
          timelineMode: TimelineMode.create));
      // getAllTimeline();
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> withdrawTimeline() async {
    emit(state.copyWith(isButtonLoading: true));
    try {
      await timelineRepository
          .withdrawTimelineRepo(state.currentTimeline!.timeline!.id!);
      state.timelines?.timelines?.removeWhere(
          (element) => element.id == state.currentTimeline!.timeline!.id);
      emit(state.copyWith(
          timelines: Timelines(),
          isWithdrawn: true,
          currentTimeline: CurrentTimeline(),
          successMssg: "Successfully withdrawn from the timeline!",
          timelineMode: TimelineMode.create));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> verifyCandidate() async {
    try {
      await timelineRepository
          .verifyCandidateRepo(state.currentTimeline!.timeline!.id!);
      putVerified(true);
      deleteTimelineId();
      emit(state.copyWith(
          currentTimeline: state.currentTimeline?.copyWith(
              steps: state.currentTimeline?.steps
                  ?.map((e) => e.copyWith())
                  .toList()),
          successMssg: "Invitation confirmed!",
          timelineMode: TimelineMode.create));
    } catch (err) {
      emit(state.copyWith(error: err.toString()));
    }
  }
}
