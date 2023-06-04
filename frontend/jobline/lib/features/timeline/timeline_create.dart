import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/features/timeline/cubit/timeline_cubit.dart';
import 'package:jobline/shared/data/timeline/models/job.dart';
import 'package:jobline/shared/data/timeline/timeline_repository.dart';
import 'package:jobline/widgets/custom_alert_dialog.dart';
import 'package:jobline/widgets/custom_button.dart';
import 'package:jobline/widgets/custom_snackbar.dart';
import 'package:jobline/widgets/layout_scaffold.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineCreate extends StatefulWidget {
  final String? timelineId;
  const TimelineCreate({super.key, this.timelineId});

  @override
  State<TimelineCreate> createState() => _NavRailExampleState();
}

class _NavRailExampleState extends State<TimelineCreate> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -1.0;
  late TimelineCubit timelineCubit;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? title;
  String? companyName;
  String? jobLinktoPost;
  int? totalPhases;
  final listNavigationRailDestinationWhenEmpty =
      const <NavigationRailDestination>[
    //if no element in the list then
    NavigationRailDestination(
      indicatorColor: JoblineColors.transparent,
      icon: SizedBox.shrink(), // Empty icon
      label: SizedBox.shrink(), // Empty label
    ),
    NavigationRailDestination(
      indicatorColor: JoblineColors.transparent,
      icon: SizedBox.shrink(), // Empty icon
      label: SizedBox.shrink(), // Empty label
    ),
  ];

  List<NavigationRailDestination> listNavigationRailDestination = const [];
  @override
  void initState() {
    timelineCubit = TimelineCubit(TimelineRepository());
    if (widget.timelineId != null) {
      timelineCubit.getTimelineWithId(widget.timelineId!);
    } else {
      timelineCubit.getAllTimeline();
    }
    super.initState();
  }

  void _buildAlertDialogBox(TimelineCubit timelineCubit) {
    customAlertDialog(
        context: context,
        actions: [
          Container(
            child: CustomButton(
                radius: 30,
                onPressFunction: () {
                  _formKey.currentState!.save();
                  if (_formKey.currentState!.validate()) {
                    timelineCubit.createJobTimeline(Job(
                        companyName: companyName,
                        jobLinktoPost: jobLinktoPost,
                        title: title,
                        totalPhases: totalPhases));
                  }
                },
                child: BlocConsumer<TimelineCubit, TimelineState>(
                  bloc: timelineCubit,
                  listenWhen: (previous, current) =>
                      previous.isButtonLoading != current.isButtonLoading,
                  listener: (context, state) {
                    if (!state.isButtonLoading) {
                      context.pop();
                    }
                  },
                  buildWhen: (previous, current) =>
                      previous.isButtonLoading != current.isButtonLoading,
                  builder: (context, state) {
                    return state.isButtonLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'CREATE TIMELINE',
                            style: TextStyle(color: JoblineColors.white),
                          );
                  },
                )),
          ),
        ],
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'About the job',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                  'Tell us the initial details before you create your timeline.',
                  style: Theme.of(context).textTheme.bodyLarge),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Job title*'),
                validator: (value) {
                  if (value == null) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  title = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Company*'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a company name';
                  }
                  return null;
                },
                onSaved: (value) {
                  companyName = value;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: '# of phases*'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter the number of phases';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        totalPhases = value != null ? int.parse(value) : 0;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Link to job post'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return null;
                      },
                      onSaved: (value) {
                        jobLinktoPost = value;
                      },
                    ),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ],
          ),
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
                    _buildAlertDialogBox(timelineCubit);
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
                          constraints: const BoxConstraints(
                            minHeight: 80,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(e.name!),
                                  Text(e.description!),
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
                            minHeight: 120,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(e.name!),
                                  Text(e.description!),
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
                        width: 150,
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
                    _buildAlertDialogBox(timelineCubit);
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
                          constraints: const BoxConstraints(
                            minHeight: 80,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(e.name!),
                                  Text(e.description!),
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
                            minHeight: 120,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(e.name!),
                                  Text(e.description!),
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
                        width: 150,
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return RepositoryProvider.value(
        value: (_) => TimelineRepository(),
        child: BlocProvider.value(
            value: timelineCubit,
            child: LayoutScaffold(
                body: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: BlocBuilder<TimelineCubit, TimelineState>(
                    buildWhen: (previous, current) =>
                        previous.timelines != current.timelines,
                    builder: (context, state) {
                      listNavigationRailDestination =
                          state.timelines?.timelines?.map(
                                (e) {
                                  return NavigationRailDestination(
                                      icon: const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 15,
                                      ),
                                      label: Text(
                                        e.jobTitle!,
                                      ));
                                },
                              ).toList() ??
                              const [];

                      if (listNavigationRailDestination.length == 1)
                        listNavigationRailDestination
                            .add(NavigationRailDestination(
                          indicatorColor: JoblineColors.transparent,
                          icon: SizedBox.shrink(), // Empty icon
                          label: SizedBox.shrink(), // Empty label
                        ));

                      return NavigationRail(
                        extended: true,
                        useIndicator: state.timelines?.timelines == null ||
                                state.timelines!.timelines!.isEmpty
                            ? false
                            : true,
                        backgroundColor: JoblineColors.white,
                        selectedIndex: _selectedIndex,
                        indicatorColor: JoblineColors.lightOrange,
                        selectedLabelTextStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: JoblineColors.lightOrange,
                                ),
                        unselectedLabelTextStyle:
                            Theme.of(context).textTheme.bodyMedium,
                        groupAlignment: groupAlignment,
                        onDestinationSelected: (int index) {
                          timelineCubit.getTimeline(index);
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        leading: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomButton(
                              radius: 30,
                              onPressFunction: () {
                                _buildAlertDialogBox(timelineCubit);
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: JoblineColors.white,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'NEW TIMELINE',
                                    style:
                                        TextStyle(color: JoblineColors.white),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            state.timelines?.timelines == null ||
                                    state.timelines!.timelines!.isEmpty
                                ? const SizedBox.shrink()
                                : Row(
                                    children: [
                                      const Icon(
                                          Icons.arrow_drop_down_outlined),
                                      Text(
                                        'Job timelines',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  )
                          ],
                        ),
                        destinations: listNavigationRailDestination.isEmpty
                            ? listNavigationRailDestinationWhenEmpty
                            : listNavigationRailDestination,
                      );
                    },
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                // This is the main content.
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocConsumer<TimelineCubit, TimelineState>(
                      listenWhen: (previous, current) => current.error != null,
                      listener: (context, state) {
                        if (state.error != null) {
                          customSnackBar(
                              context: context,
                              snackBarType: SnackBarType.error,
                              title: "Something went wrong.");
                        }
                      },
                      buildWhen: (previous, current) =>
                          previous.isTimelineCreationSuccess !=
                              current.isTimelineCreationSuccess ||
                          previous.isPageLoading != current.isPageLoading,
                      builder: (context, state) {
                        return SingleChildScrollView(
                          child: Column(children: <Widget>[
                            state.timelines?.timelines == null ||
                                    state.timelines!.timelines!.isEmpty
                                ? const SizedBox.shrink()
                                : Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                            padding: const EdgeInsets.all(15),
                                            height: 100,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: JoblineColors
                                                        .neutralLight)),
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
                                                        state
                                                                .currentTimeline
                                                                ?.timeline
                                                                ?.company ??
                                                            '',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge),
                                                    Text(
                                                      state
                                                              .currentTimeline
                                                              ?.timeline
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
                                                    color: JoblineColors
                                                        .neutralLight,
                                                    thickness: 2,
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        '${state.currentTimeline?.numberOfSteps ?? '0'} Phases'),
                                                    Text(
                                                      state
                                                              .currentTimeline
                                                              ?.timeline
                                                              ?.jobPostLink ??
                                                          '',
                                                      style: const TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline),
                                                    ),
                                                    Text(
                                                        '${Hive.box('appBox').get('email')}')
                                                  ],
                                                ),
                                                const Spacer(),
                                                //check whether edit mode or not; needs refactor

                                                if (!state
                                                    .isTimelineCreationSuccess)
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
                                                if (!state
                                                    .isTimelineCreationSuccess)
                                                  CustomButton(
                                                    radius: 30,
                                                    onPressFunction: () {
                                                      _buildAlertDialogBox(
                                                          timelineCubit);
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

                                                if (!state
                                                    .isTimelineCreationSuccess)
                                                  IconButton(
                                                    onPressed: () {
                                                      Share.share(
                                                          'Jobline link : https://647b59554e613a11bc6dbe12--deluxe-gelato-829e45.netlify.app/timeline/${state.currentTimeline?.timeline?.id}',
                                                          subject:
                                                              'You have been invited to ${state.currentTimeline?.timeline?.company} as ${state.currentTimeline?.timeline?.jobTitle} tap the link : https://647b59554e613a11bc6dbe12--deluxe-gelato-829e45.netlify.app/timeline/${state.currentTimeline?.timeline?.id}');
                                                    },
                                                    icon:
                                                        const Icon(Icons.share),
                                                  ),
                                                if (state
                                                    .isTimelineCreationSuccess)
                                                  CustomButton(
                                                      radius: 30,
                                                      onPressFunction: () {
                                                        timelineCubit.updateTimeline(
                                                            state
                                                                .currentTimeline!
                                                                .steps!,
                                                            state
                                                                .currentTimeline!
                                                                .timeline!
                                                                .id!);
                                                      },
                                                      child: BlocBuilder<
                                                          TimelineCubit,
                                                          TimelineState>(
                                                        bloc: timelineCubit,
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
                                                              : Text(
                                                                  'Save Timeline',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .labelLarge!
                                                                      .copyWith(
                                                                          color:
                                                                              JoblineColors.white),
                                                                );
                                                        },
                                                      )),
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
                            _buildTimeline()
                          ]),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ))));
  }
}
