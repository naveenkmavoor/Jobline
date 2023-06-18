import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/features/manage_candidate/view/manage_candidate.dart';
import 'package:jobline/features/timeline/cubit/timeline_cubit.dart';
import 'package:jobline/features/timeline/timeline_main_body.dart';
import 'package:jobline/shared/data/timeline/timeline_repository.dart';
import 'package:jobline/shared/utility.dart';
import 'package:jobline/widgets/appBarType.dart';
import 'package:jobline/widgets/create_job_alertbox.dart';
import 'package:jobline/widgets/custom_alert_dialog.dart';
import 'package:jobline/widgets/custom_button.dart';
import 'package:jobline/widgets/layout_scaffold.dart';

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
  final pageViewcontroller = PageController(initialPage: 0);
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
    if (widget.timelineId != null && widget.timelineId != " ") {
      putTimelineId(widget.timelineId!);
      timelineCubit.getTimelineWithId(id: widget.timelineId!);
    } else {
      timelineCubit.getAllTimeline();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isGeneralMode = widget.timelineId != null && widget.timelineId != " ";
    final isRecruiter = getUserRole() == 'recruiter';
    return RepositoryProvider.value(
        value: (_) => TimelineRepository(),
        child: BlocProvider.value(
            value: timelineCubit,
            child: LayoutScaffold(
                appBarTypes:
                    isGeneralMode ? AppBarTypes.general : AppBarTypes.common,
                body: isGeneralMode
                    ? const TimelineMainBody()
                    // !isGeneralMode
                    //     ? ManageCandidateBody()
                    : Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: BlocBuilder<TimelineCubit, TimelineState>(
                              buildWhen: (previous, current) =>
                                  previous.timelines != current.timelines,
                              builder: (context, state) {
                                if (timelineCubit.state.timelineMode ==
                                    TimelineMode.edit) {
                                  _selectedIndex = 0;
                                }
                                listNavigationRailDestination =
                                    state.timelines?.timelines?.map(
                                          (e) {
                                            return NavigationRailDestination(
                                                icon: const Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                  size: 15,
                                                ),
                                                label: Text(
                                                  e.jobTitle!,
                                                ));
                                          },
                                        ).toList() ??
                                        const [];

                                if (listNavigationRailDestination.length == 1) {
                                  listNavigationRailDestination
                                      .add(const NavigationRailDestination(
                                    indicatorColor: JoblineColors.transparent,
                                    icon: SizedBox.shrink(), // Empty icon
                                    label: SizedBox.shrink(), // Empty label
                                  ));
                                }

                                return NavigationRail(
                                  extended: true,
                                  useIndicator: state.timelines?.timelines ==
                                              null ||
                                          state.timelines!.timelines!.isEmpty
                                      ? false
                                      : true,
                                  backgroundColor: JoblineColors.white,
                                  selectedIndex: _selectedIndex,
                                  indicatorColor: JoblineColors.lightOrange,
                                  selectedLabelTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: JoblineColors.lightOrange,
                                      ),
                                  unselectedLabelTextStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                  groupAlignment: groupAlignment,
                                  onDestinationSelected: (int index) {
                                    if (timelineCubit.state.timelineMode ==
                                        TimelineMode.edit) {
                                      customAlertDialog(
                                          context: context,
                                          actions: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Expanded(
                                                    child: TextButton(
                                                        onPressed: () {
                                                          context.pop();
                                                        },
                                                        child: const Text(
                                                            'CANCEL'))),
                                                CustomButton(
                                                    onPressFunction: () {
                                                      timelineCubit.updateTimeline(
                                                          state.currentTimeline!
                                                              .steps!,
                                                          state.currentTimeline!
                                                              .timeline!.id!);
                                                    },
                                                    child: const Text('SAVE'))
                                              ],
                                            )
                                          ],
                                          body: Column(
                                            children: [
                                              const Icon(
                                                Icons.info_outline_rounded,
                                                color:
                                                    JoblineColors.primaryColor,
                                                size: 50,
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Text(
                                                'Save changes?',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              const Text(
                                                  'Your unsaved changes will be lost.\n Save changes before closing?')
                                            ],
                                          ));

                                      return;
                                    }
                                    timelineCubit.getTimeline(index);
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                  },
                                  leading: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (isRecruiter)
                                        CustomButton(
                                          onPressFunction: () {
                                            buildAlertDialogBox(
                                                context, timelineCubit);
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
                                              )
                                            ],
                                          ),
                                        ),
                                      if (isRecruiter)
                                        const SizedBox(
                                          height: 24,
                                        ),
                                      state.timelines?.timelines == null ||
                                              state
                                                  .timelines!.timelines!.isEmpty
                                          ? const SizedBox.shrink()
                                          : Row(
                                              children: [
                                                const Icon(Icons
                                                    .arrow_drop_down_outlined),
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
                                  destinations: listNavigationRailDestination
                                          .isEmpty
                                      ? listNavigationRailDestinationWhenEmpty
                                      : listNavigationRailDestination,
                                );
                              },
                            ),
                          ),
                          const VerticalDivider(thickness: 1, width: 1),
                          Expanded(
                              child: PageView(
                            onPageChanged: (value) {},
                            controller: pageViewcontroller,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              TimelineMainBody(
                                  pageController: pageViewcontroller),
                              if (timelineCubit
                                      .state.currentTimeline?.timeline !=
                                  null)
                                ManageCandidateBody(
                                  pageController: pageViewcontroller,
                                )
                            ],
                          ))
                        ],
                      ))));
  }
}
