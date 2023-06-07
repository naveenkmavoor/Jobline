import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/features/timeline/cubit/timeline_cubit.dart';
import 'package:jobline/shared/data/timeline/models/steps.dart';
import 'package:jobline/widgets/create_job_alertbox.dart';
import 'package:jobline/widgets/custom_alert_dialog.dart';
import 'package:jobline/widgets/custom_button.dart';
import 'package:jobline/widgets/custom_snackbar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineMainBody extends StatelessWidget {
  const TimelineMainBody({super.key});

  void _buildDeletecustomAlertDialog(
      BuildContext context, TimelineCubit timelineCubit, Steps step) {
    customAlertDialog(
        context: context,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text('CANCEL'))),
              CustomButton(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  onPressFunction: () {
                    timelineCubit.deletePhase(step.id!, step.order!);
                    Future.delayed(Duration(seconds: 2))
                        .then((value) => context.pop());
                  },
                  child: const Text('DELETE'))
            ],
          )
        ],
        body: Column(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: JoblineColors.accentColor,
              size: 50,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Delete this phase?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text('Are you sure you want to delete this?')
          ],
        ));
  }

  Widget _buildEditTimeline() {
    return BlocBuilder<TimelineCubit, TimelineState>(
      buildWhen: (previous, current) =>
          previous.isPageLoading != current.isPageLoading ||
          previous.currentTimeline != current.currentTimeline,
      builder: (context, state) {
        if (state.isPageLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.error != null) {
          return const Center(
            child: Text('Something went wrong!'),
          );
        } else if (state.timelines?.timelines == null ||
            state.timelines!.timelines!.isEmpty) {
          return Column(
            children: [
              const Text('You currently do not have any job timelines.'),
              const SizedBox(
                height: 15,
              ),
              CustomButton(
                  radius: 30,
                  onPressFunction: () {
                    buildAlertDialogBox(context, context.read<TimelineCubit>());
                  },
                  child: const Text(
                    'CREATE TIMELINE',
                    style: TextStyle(color: JoblineColors.white),
                  )),
              const SizedBox(
                height: 24,
              ),
            ],
          );
        }
        List<Widget> listTimelineTile = const [];
        final currentTimeline = state.currentTimeline;
        listTimelineTile = currentTimeline!.steps!.map(
          (e) {
            final isFirst = e.order == 0 ? true : false;
            final isLast = e.order == currentTimeline.steps!.length - 1;
            final isStart = e.order! % 2 == 0 ? true : false;

            TextEditingController _titleController = TextEditingController(
              text: e.name,
            );

            TextEditingController _descriptionController =
                TextEditingController(text: e.description);

            TextEditingController _etaController =
                TextEditingController(text: '${e.eta}');
            return Column(
              children: [
                TimelineTile(
                  lineXY: 0.3,
                  alignment: TimelineAlign.center,
                  isFirst: isFirst,
                  isLast: isLast,
                  indicatorStyle: const IndicatorStyle(
                    width: 20,
                    color: JoblineColors.neutralLight,
                  ),
                  beforeLineStyle: const LineStyle(
                    color: JoblineColors.neutralLight,
                    thickness: 6,
                  ),
                  endChild: isStart
                      ? null
                      : Container(
                          decoration: BoxDecoration(
                              color:
                                  JoblineColors.lightOrange.withOpacity(0.21),
                              borderRadius: BorderRadius.circular(15)),
                          constraints:
                              const BoxConstraints(minHeight: 80, minWidth: 80),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextField(
                                    maxLines: 1,
                                    controller: _titleController,
                                    maxLength: 50,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    onChanged: (val) {
                                      context
                                          .read<TimelineCubit>()
                                          .updatePhaseDescription(
                                              order: e.order!,
                                              description: val);
                                    },
                                  ),
                                  TextField(
                                    maxLines: 5,
                                    controller: _descriptionController,
                                    maxLength: 200,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    onChanged: (val) {
                                      context
                                          .read<TimelineCubit>()
                                          .updatePhaseTitle(
                                              order: e.order!, title: val);
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                        onPressed: () {
                                          _buildDeletecustomAlertDialog(context,
                                              context.read<TimelineCubit>(), e);
                                        },
                                        icon: const Icon(
                                            Icons.delete_outline_rounded)),
                                  )
                                ]),
                          ),
                        ),
                  startChild: isStart
                      ? Container(
                          decoration: BoxDecoration(
                              color:
                                  JoblineColors.lightOrange.withOpacity(0.21),
                              borderRadius: BorderRadius.circular(15)),
                          constraints:
                              const BoxConstraints(minHeight: 80, minWidth: 80),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextField(
                                    maxLines: 1,
                                    controller: _titleController,
                                    maxLength: 50,
                                    onChanged: (val) {
                                      context
                                          .read<TimelineCubit>()
                                          .updatePhaseTitle(
                                              order: e.order!, title: val);
                                    },
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                  TextField(
                                    maxLines: 5,
                                    controller: _descriptionController,
                                    maxLength: 200,
                                    onChanged: (val) {
                                      context
                                          .read<TimelineCubit>()
                                          .updatePhaseDescription(
                                              order: e.order!,
                                              description: val);
                                    },
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                        onPressed: () {
                                          _buildDeletecustomAlertDialog(context,
                                              context.read<TimelineCubit>(), e);
                                        },
                                        icon: const Icon(
                                            Icons.delete_outline_rounded)),
                                  )
                                ]),
                          ),
                        )
                      : null,
                ),
                //todo: take advantage of the e and check in the currenttimeline steps array and
                //modify the input in onchanged func inside textfield
                if (e.eta != null && !isLast)
                  TimelineTile(
                    alignment: TimelineAlign.center,
                    beforeLineStyle: const LineStyle(
                      color: JoblineColors.neutralLight,
                      thickness: 6,
                    ),
                    afterLineStyle: const LineStyle(
                      color: JoblineColors.neutralLight,
                      thickness: 6,
                    ),
                    indicatorStyle: IndicatorStyle(
                        width: 200,
                        height: 50,
                        color: Colors.transparent,
                        indicator: Align(
                          alignment: Alignment.center,
                          child: Card(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 28),
                                child: TextField(
                                  controller: _etaController,
                                  textAlign: TextAlign.center,
                                  onChanged: (val) {
                                    val.isNotEmpty
                                        ? context
                                            .read<TimelineCubit>()
                                            .updatePhaseEta(
                                                order: e.order!,
                                                eta: int.parse(val))
                                        : null;
                                  },
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                )),
                          ),
                        )),
                  ),
              ],
            );
          },
        ).toList();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0),
          child: Column(children: listTimelineTile),
        );
      },
    );
  }

  Widget _buildTimeline() {
    return BlocBuilder<TimelineCubit, TimelineState>(
      buildWhen: (previous, current) =>
          previous.isPageLoading != current.isPageLoading ||
          previous.currentTimeline != current.currentTimeline,
      builder: (context, state) {
        if (state.isPageLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.error != null) {
          return const Center(
            child: Text('Something went wrong!'),
          );
        } else if (state.currentTimeline != null) {
          List<Widget> listTimelineTile = const [];
          final currentTimeline = state.currentTimeline;
          listTimelineTile = currentTimeline!.steps!.map(
            (e) {
              final isFirst = e.order == 0 ? true : false;
              final isLast = e.order == currentTimeline.steps!.length - 1;
              final isStart = e.order! % 2 == 0 ? true : false;
              return Column(
                children: [
                  TimelineTile(
                    lineXY: 0.3,
                    alignment: TimelineAlign.center,
                    isFirst: isFirst,
                    isLast: isLast,
                    indicatorStyle: IndicatorStyle(
                      width: 20,
                      color:
                          state.timelineMode == TimelineMode.general && isFirst
                              ? JoblineColors.lightOrange
                              : JoblineColors.neutralLight,
                    ),
                    beforeLineStyle: const LineStyle(
                      color: JoblineColors.neutralLight,
                      thickness: 6,
                    ),
                    endChild: isStart
                        ? null
                        : Container(
                            decoration: BoxDecoration(
                                color:
                                    JoblineColors.lightOrange.withOpacity(0.21),
                                borderRadius: BorderRadius.circular(15)),
                            constraints: const BoxConstraints(
                                minHeight: 80, minWidth: 80),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(e.name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!),
                                    Text(e.description!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color:
                                                    JoblineColors.lightGrey)),
                                  ]),
                            ),
                          ),
                    startChild: isStart
                        ? Container(
                            decoration: BoxDecoration(
                                color:
                                    JoblineColors.lightOrange.withOpacity(0.21),
                                borderRadius: BorderRadius.circular(15)),
                            constraints: const BoxConstraints(
                                minHeight: 80, minWidth: 80),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(e.name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!),
                                    Text(e.description!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color:
                                                    JoblineColors.lightGrey)),
                                  ]),
                            ),
                          )
                        : null,
                  ),
                  if (e.eta != null && !isLast)
                    TimelineTile(
                      alignment: TimelineAlign.center,
                      beforeLineStyle: const LineStyle(
                        color: JoblineColors.neutralLight,
                        thickness: 6,
                      ),
                      afterLineStyle: const LineStyle(
                        color: JoblineColors.neutralLight,
                        thickness: 6,
                      ),
                      indicatorStyle: IndicatorStyle(
                          width: 200,
                          height: 50,
                          color: Colors.cyan,
                          indicator: Align(
                            alignment: Alignment.center,
                            child: Card(
                              color: JoblineColors.neutralLight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${e.eta} days'),
                              ),
                            ),
                          )),
                    ),
                ],
              );
            },
          ).toList();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0),
            child: Column(children: listTimelineTile),
          );
        } else {
          return Column(
            children: [
              const Text('You currently do not have any job timelines.'),
              const SizedBox(
                height: 15,
              ),
              CustomButton(
                  radius: 30,
                  onPressFunction: () {
                    buildAlertDialogBox(context, context.read<TimelineCubit>());
                  },
                  child: const Text(
                    'CREATE TIMELINE',
                    style: TextStyle(color: JoblineColors.white),
                  )),
              const SizedBox(
                height: 24,
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return // This is the main content.
        Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocConsumer<TimelineCubit, TimelineState>(
        listenWhen: (previous, current) =>
            current.error != null ||
            current.successMssg != previous.successMssg,
        listener: (context, state) {
          if (state.successMssg != null) {
            customSnackBar(
                context: context,
                snackBarType: SnackBarType.success,
                title: state.successMssg!);
          } else if (state.error != null) {
            customSnackBar(
                context: context,
                snackBarType: SnackBarType.error,
                title: "Something went wrong.");
          }
        },
        buildWhen: (previous, current) =>
            previous.isPageLoading != current.isPageLoading ||
            previous.timelineMode != current.timelineMode,
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(children: <Widget>[
              state.currentTimeline == null || state.isPageLoading
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.all(15),
                              height: 100,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: JoblineColors.neutralLight)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          state.currentTimeline?.timeline
                                                  ?.company ??
                                              '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                      Text(
                                        state.currentTimeline?.timeline
                                                ?.jobTitle ??
                                            "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 50.0, right: 19),
                                    child: VerticalDivider(
                                      indent: 11,
                                      endIndent: 11,
                                      color: JoblineColors.neutralLight,
                                      thickness: 2,
                                    ),
                                  ),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${state.currentTimeline?.steps?.length ?? '0'} Phases'),
                                      Text(
                                        state.currentTimeline?.timeline
                                                ?.jobPostLink ??
                                            '',
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      Text(
                                          '${Hive.box('appBox').get('email') ?? ''}')
                                    ],
                                  ),
                                  //check whether edit mode or not; needs refactor
                                  const Spacer(),
                                  state.timelineMode == TimelineMode.edit
                                      ? CustomButton(
                                          radius: 30,
                                          onPressFunction: () {
                                            context
                                                .read<TimelineCubit>()
                                                .updateTimeline(
                                                    state.currentTimeline!
                                                        .steps!,
                                                    state.currentTimeline!
                                                        .timeline!.id!);
                                          },
                                          child: BlocBuilder<TimelineCubit,
                                              TimelineState>(
                                            buildWhen: (previous, current) =>
                                                previous.isButtonLoading !=
                                                current.isButtonLoading,
                                            builder: (context, state) {
                                              return state.isButtonLoading
                                                  ? const CircularProgressIndicator()
                                                  : Text(
                                                      'Save Timeline',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge!
                                                          .copyWith(
                                                              color:
                                                                  JoblineColors
                                                                      .white),
                                                    );
                                            },
                                          ))
                                      : state.timelineMode ==
                                              TimelineMode.general
                                          ? const SizedBox.shrink()
                                          : Row(
                                              children: [
                                                CustomButton(
                                                    radius: 30,
                                                    onPressFunction: () {},
                                                    child: Text(
                                                      'MANAGE CANDIDATES',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge!
                                                          .copyWith(
                                                              color:
                                                                  JoblineColors
                                                                      .white),
                                                    )),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: CustomButton(
                                                    radius: 30,
                                                    onPressFunction: () {
                                                      context
                                                          .read<TimelineCubit>()
                                                          .timelineModeChange(
                                                              TimelineMode
                                                                  .edit);
                                                    },
                                                    child: const Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .mode_edit_outline_outlined,
                                                          color: JoblineColors
                                                              .white,
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Text(
                                                          'EDIT TIMELINE',
                                                          style: TextStyle(
                                                              color:
                                                                  JoblineColors
                                                                      .white),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    Share.share(
                                                        'Jobline link : ${window.location.hostname}/timeline/${state.currentTimeline?.timeline?.id}',
                                                        subject:
                                                            'You have been invited to ${state.currentTimeline?.timeline?.company} as ${state.currentTimeline?.timeline?.jobTitle} tap the link : ${window.location.hostname}/timeline/${state.currentTimeline?.timeline?.id}');
                                                  },
                                                  icon: const Icon(Icons.share),
                                                ),
                                              ],
                                            ),

                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 150,
              ),
              state.timelineMode == TimelineMode.edit
                  ? _buildEditTimeline()
                  : _buildTimeline()
            ]),
          );
        },
      ),
    );
  }
}
