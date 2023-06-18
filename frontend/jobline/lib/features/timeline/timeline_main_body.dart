import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jobline/shared/data/timeline/models/current_timeline.dart';
import 'package:jobline/shared/data/timeline/models/job.dart';
import 'package:jobline/shared/data/timeline/models/timeline.dart';
import 'package:jobline/shared/utility.dart';
import 'package:jobline/widgets/stacked_avatars.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:jobline/colors.dart';
import 'package:jobline/features/timeline/cubit/timeline_cubit.dart';
import 'package:jobline/shared/data/timeline/models/steps.dart';
import 'package:jobline/widgets/create_job_alertbox.dart';
import 'package:jobline/widgets/custom_alert_dialog.dart';
import 'package:jobline/widgets/custom_button.dart';
import 'package:jobline/widgets/custom_snackbar.dart';

class TimelineMainBody extends StatelessWidget {
  final PageController? pageController;
  const TimelineMainBody({super.key, this.pageController});

  void _buildShareLinkAlertBox(BuildContext context, String? timelineId) {
    final link = '${window.location.hostname}/timeline/$timelineId';
    bool isCopied = false;
    final textTheme = Theme.of(context).textTheme;
    customAlertDialog(
        context: context,
        actions: [],
        title: 'Share link',
        body: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Row(
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    12,
                  ),
                  color: JoblineColors.primaryColor.withOpacity(0.1),
                ),
                child: Row(children: [
                  Text(
                    link,
                    style: textTheme.labelSmall,
                  ),
                  const Spacer(),
                  CustomButton(
                      backgroundColor: JoblineColors.white,
                      elevation: 3,
                      onPressFunction: () {
                        Clipboard.setData(ClipboardData(text: link));
                        setState(() {
                          isCopied = true;
                        });
                        // customSnackBar(
                        //     context: context,
                        //     snackBarType: SnackBarType.success,
                        //     title: "Link copied!");
                      },
                      child: Text(isCopied ? '✓ Copied!' : ' Copy link',
                          style: TextStyle(
                              color: isCopied
                                  ? JoblineColors.green
                                  : JoblineColors.primaryColor))),
                ]),
              )),
            ],
          );
        }));
  }

  void _buildDeletecustomAlertDialog(
      BuildContext context, TimelineCubit timelineCubit, Steps step) {
    customAlertDialog(
        context: context,
        title: "Delete phase?",
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text('CANCEL',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: JoblineColors.black)))),
              CustomButton(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  onPressFunction: () {
                    timelineCubit.deletePhase(step.id!, step.order!);
                  },
                  child: BlocConsumer<TimelineCubit, TimelineState>(
                    listener: (context, state) {
                      if (!state.isDeleteButtonLoading) {
                        context.pop();
                      }
                    },
                    listenWhen: (previous, current) =>
                        previous.isDeleteButtonLoading !=
                        current.isDeleteButtonLoading,
                    bloc: timelineCubit,
                    buildWhen: (previous, current) =>
                        previous.isDeleteButtonLoading !=
                        current.isDeleteButtonLoading,
                    builder: (context, state) {
                      return state.isDeleteButtonLoading
                          ? const CircularProgressIndicator(
                              color: JoblineColors.white,
                            )
                          : const Text(
                              'DELETE',
                            );
                    },
                  ))
            ],
          )
        ],
        body: const Column(
          children: [Text('Are you sure you want to delete this phase?')],
        ));
  }

  Widget _buildEditTimeline(ScrollController _scrollController) {
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
                  onPressFunction: () {
                    buildAlertDialogBox(context, context.read<TimelineCubit>());
                  },
                  child: const Text(
                    'CREATE TIMELINE',
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
            final autoFocusLastTextField = isLast && state.focusLastTextField;

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
                                    autofocus: autoFocusLastTextField,
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
                                    autofocus: autoFocusLastTextField,
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
//if state is adding a new timeline then scroll to the bottom of the page
        if (state.focusLastTextField) {
          //provide a delay to scroll to the bottom of the page after the listTimelineTile is loaded

          Future.delayed(const Duration(milliseconds: 100)).then(
            (value) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(
                    milliseconds:
                        500), // Optional: Set a duration for smooth scrolling
                curve: Curves
                    .easeOut, // Optional: Set a curve for the scrolling animation
              );
            },
          );
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 220.0),
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
        } else if (state.currentTimeline != null &&
            (state.currentTimeline?.email != null)) {
          if (getUserRole() == 'candidate' &&
              state.timelineMode != TimelineMode.general) {
            if (!isVerified())
              Future.delayed(Duration(seconds: 2)).then((value) =>
                  _buildInviteConfirmationAlertBox(
                      context, state.currentTimeline!));
          }

          List<Widget> listTimelineTile = const [];
          final currentTimeline = state.currentTimeline;
          listTimelineTile = currentTimeline!.steps!.map(
            (e) {
              final isFirst = e.order == 0 ? true : false;
              final isLast = e.order == currentTimeline.steps!.length - 1;
              final isStart = e.order! % 2 == 0 ? true : false;
              Color indicatorColor = JoblineColors.neutralLight;
              Color borderColor = JoblineColors.lightOrange.withOpacity(0.21);
              if (getUserRole() == 'candidate' && isVerified()) {
                final val = e.status?.firstWhere(
                    (element) => element.email == getUserInfo()['email'],
                    orElse: () => Status());
                if (val?.id != null) {
                  indicatorColor = JoblineColors.lightOrange;
                  borderColor = JoblineColors.lightOrange;
                }
              }
              return Column(
                children: [
                  TimelineTile(
                    lineXY: 0.3,
                    alignment: TimelineAlign.center,
                    isFirst: isFirst,
                    isLast: isLast,
                    indicatorStyle: IndicatorStyle(
                      width: 20,
                      color: indicatorColor,
                    ),
                    beforeLineStyle: const LineStyle(
                      color: JoblineColors.neutralLight,
                      thickness: 6,
                    ),
                    endChild: isStart
                        ? null
                        : Container(
                            padding: const EdgeInsets.all(18.0),
                            decoration: BoxDecoration(
                                color:
                                    JoblineColors.lightOrange.withOpacity(0.21),
                                border: Border.all(color: borderColor),
                                borderRadius: BorderRadius.circular(15)),
                            constraints: const BoxConstraints(
                                minHeight: 80, minWidth: 80),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.name!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(e.description!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: JoblineColors.lightGrey)),
                                  const SizedBox(
                                    height: 50.0,
                                  ),
                                  if ((isVerified() &&
                                          getUserRole() == 'candidate') ||
                                      (getUserRole() == 'recruiter' &&
                                          getTimelineId() == null))
                                    StackedAvatars(
                                      radius: 10,
                                      avatars: e.status!
                                          .map((e) => e.email!)
                                          .toList(),
                                    )
                                ]),
                          ),
                    startChild: isStart
                        ? Container(
                            padding: const EdgeInsets.all(18.0),
                            decoration: BoxDecoration(
                                color:
                                    JoblineColors.lightOrange.withOpacity(0.21),
                                border: Border.all(color: borderColor),
                                borderRadius: BorderRadius.circular(15)),
                            constraints: const BoxConstraints(
                                minHeight: 80, minWidth: 80),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.name!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(e.description!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: JoblineColors.lightGrey)),
                                  const SizedBox(
                                    height: 50.0,
                                  ),
                                  if ((isVerified() &&
                                          getUserRole() == 'candidate') ||
                                      (getUserRole() == 'recruiter' &&
                                          getTimelineId() == null))
                                    StackedAvatars(
                                      radius: 10,
                                      avatars: e.status!
                                          .map((e) => e.email!)
                                          .toList(),
                                    )
                                ]),
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

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 220.0),
            child: Column(children: listTimelineTile),
          );
        } else {
          if (getUserRole() == 'candidate') {
            return const Center(
              child: Text('You Are not invited to any timeline :('),
            );
          }
          return Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                const Text('You currently do not have any job timelines.'),
                const SizedBox(
                  height: 15,
                ),
                CustomButton(
                    onPressFunction: () {
                      buildAlertDialogBox(
                          context, context.read<TimelineCubit>());
                    },
                    child: const Text(
                      'CREATE TIMELINE',
                    )),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final timelineCubit = context.read<TimelineCubit>();
    final _scrollController = ScrollController();

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
            previous.timelineMode != current.timelineMode ||
            previous.isWithdrawn != current.isWithdrawn,
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(children: <Widget>[
                  state.currentTimeline == null || state.isPageLoading
                      ? const SizedBox.shrink()
                      : Row(
                          children: [
                            if (!state.isWithdrawn)
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                          padding: EdgeInsets.only(
                                              left: 50.0, right: 19),
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
                                            Text(state.currentTimeline?.email ??
                                                '')
                                          ],
                                        ),
                                        //check whether edit mode or not; needs refactor
                                        const Spacer(),
                                        state.timelineMode == TimelineMode.edit
                                            ? CustomButton(
                                                onPressFunction: () {
                                                  context
                                                      .read<TimelineCubit>()
                                                      .updateTimeline(
                                                          timelineCubit
                                                              .state
                                                              .currentTimeline!
                                                              .steps!,
                                                          timelineCubit
                                                              .state
                                                              .currentTimeline!
                                                              .timeline!
                                                              .id!);
                                                },
                                                child: BlocBuilder<
                                                    TimelineCubit,
                                                    TimelineState>(
                                                  buildWhen: (previous,
                                                          current) =>
                                                      previous
                                                          .isButtonLoading !=
                                                      current.isButtonLoading,
                                                  builder: (context, state) {
                                                    return state.isButtonLoading
                                                        ? const CircularProgressIndicator()
                                                        : const Text(
                                                            'Save Timeline',
                                                          );
                                                  },
                                                ))
                                            : state.timelineMode ==
                                                    TimelineMode.general
                                                ? const SizedBox.shrink()
                                                : getUserRole() == 'candidate'
                                                    ? CustomButton(
                                                        onPressFunction: () {
                                                          context
                                                              .read<
                                                                  TimelineCubit>()
                                                              .withdrawTimeline();
                                                        },
                                                        child: BlocBuilder<
                                                            TimelineCubit,
                                                            TimelineState>(
                                                          buildWhen: (previous,
                                                                  current) =>
                                                              previous
                                                                  .isButtonLoading !=
                                                              current
                                                                  .isButtonLoading,
                                                          builder:
                                                              (context, state) {
                                                            return state
                                                                    .isButtonLoading
                                                                ? const CircularProgressIndicator()
                                                                : const Text(
                                                                    'WITHDRAW FROM TIMELINE',
                                                                  );
                                                          },
                                                        ))
                                                    : Row(
                                                        children: [
                                                          CustomButton(
                                                              onPressFunction:
                                                                  () {
                                                                pageController!
                                                                    .nextPage(
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  curve: Curves
                                                                      .easeIn,
                                                                );
                                                              },
                                                              child: const Text(
                                                                'MANAGE CANDIDATES',
                                                              )),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                            child: CustomButton(
                                                              onPressFunction:
                                                                  () {
                                                                context
                                                                    .read<
                                                                        TimelineCubit>()
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
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              _buildShareLinkAlertBox(
                                                                  context,
                                                                  state
                                                                      .currentTimeline
                                                                      ?.timeline
                                                                      ?.id);
                                                              // Share.share(
                                                              //     'Jobline link : ${window.location.hostname}/timeline/${state.currentTimeline?.timeline?.id}',
                                                              //     subject:
                                                              //         'You have been invited to ${state.currentTimeline?.timeline?.company} as ${state.currentTimeline?.timeline?.jobTitle} tap the link : ${window.location.hostname}/timeline/${state.currentTimeline?.timeline?.id}');
                                                            },
                                                            icon: const Icon(
                                                                Icons.share),
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
                      ? _buildEditTimeline(_scrollController)
                      : _buildTimeline()
                ]),
              ),
              if (state.timelineMode == TimelineMode.edit)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton.extended(
                    label: const Text('Add new phase'),
                    onPressed: () {
                      timelineCubit.addStep();
                    },
                    icon: const Icon(Icons.add),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _buildInviteConfirmationAlertBox(
      BuildContext context, CurrentTimeline currentTimeline) {
    customAlertDialog(
        context: context,
        title: 'Confirm your invite',
        actions: [
          Align(
            alignment: Alignment.bottomRight,
            child: CustomButton(
                onPressFunction: () {
                  context.read<TimelineCubit>().verifyCandidate();
                  context.pop();
                },
                child: const Text(
                  'CONFIRM',
                )),
          )
        ],
        body: Column(
          children: [
            RichText(
                text: TextSpan(
              text: 'Is ',
              children: [
                TextSpan(
                    text:
                        '${currentTimeline.timeline?.jobTitle} @ ${currentTimeline.timeline?.company} ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: JoblineColors.primaryColor)),
                const TextSpan(
                  text: 'the job you applied for?',
                ),
              ],
            ))
          ],
        ));
  }
}
