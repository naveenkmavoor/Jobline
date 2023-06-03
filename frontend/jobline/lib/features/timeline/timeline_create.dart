import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/features/timeline/cubit/timeline_cubit.dart';
import 'package:jobline/shared/data/timeline/models/job.dart';
import 'package:jobline/shared/data/timeline/models/timeline.dart';
import 'package:jobline/shared/data/timeline/timeline_repository.dart';
import 'package:jobline/widgets/custom_alert_dialog.dart';
import 'package:jobline/widgets/custom_button.dart';
import 'package:jobline/widgets/custom_snackbar.dart';
import 'package:jobline/widgets/layout_scaffold.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineCreate extends StatelessWidget {
  final String? timelineId;
  const TimelineCreate({super.key, this.timelineId});

  @override
  Widget build(BuildContext context) {
    return const NavRailExample();
  }
}

class NavRailExample extends StatefulWidget {
  const NavRailExample({super.key});

  @override
  State<NavRailExample> createState() => _NavRailExampleState();
}

class _NavRailExampleState extends State<NavRailExample> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -1.0;
  final timelineCubit = TimelineCubit(TimelineRepository());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? title;
  String? companyName;
  String? jobLinktoPost;
  int? totalPhases;
  @override
  void initState() {
    // final fetchTimeline = DioClient().get('/api/');
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
                child: const Text(
                  'CREATE TIMELINE',
                  style: TextStyle(color: JoblineColors.white),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TimelineTile(
          alignment: TimelineAlign.center,
          isFirst: true,
          indicatorStyle: const IndicatorStyle(
            width: 20,
            color: JoblineColors.lightOrange,
          ),
          beforeLineStyle: const LineStyle(
            color: JoblineColors.neutralLight,
            thickness: 6,
          ),
          startChild: Container(
            decoration: BoxDecoration(
                color: JoblineColors.lightOrange.withOpacity(0.21),
                borderRadius: BorderRadius.circular(15)),
            constraints: const BoxConstraints(
              minHeight: 120,
            ),
            child: const Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Phase 1'),
                    Text('Description'),
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.delete_outline_outlined),
                    )
                  ]),
            ),
          ),
        ),
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
          indicatorStyle: const IndicatorStyle(
              width: 150,
              height: 50,
              color: Colors.cyan,
              indicator: Align(
                alignment: Alignment.center,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('2-3 days'),
                  ),
                  color: JoblineColors.neutralLight,
                ),
              )),
        ),
        TimelineTile(
          alignment: TimelineAlign.center,
          isLast: true,
          beforeLineStyle: const LineStyle(
            color: JoblineColors.neutralLight,
            thickness: 6,
          ),
          indicatorStyle: const IndicatorStyle(
            width: 20,
            color: JoblineColors.neutralLight,
          ),
          endChild: Container(
            decoration: BoxDecoration(
                color: JoblineColors.lightOrange.withOpacity(0.21),
                borderRadius: BorderRadius.circular(15)),
            constraints: const BoxConstraints(
              minHeight: 80,
            ),
            child: const Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Phase 1'),
                    Text('Description'),
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.delete_outline_outlined),
                    )
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TimelineTile(
          alignment: TimelineAlign.center,
          isFirst: true,
          indicatorStyle: const IndicatorStyle(
            width: 20,
            color: JoblineColors.lightOrange,
          ),
          beforeLineStyle: const LineStyle(
            color: JoblineColors.neutralLight,
            thickness: 6,
          ),
          startChild: Container(
            decoration: BoxDecoration(
                color: JoblineColors.lightOrange.withOpacity(0.21),
                borderRadius: BorderRadius.circular(15)),
            constraints: const BoxConstraints(
              minHeight: 120,
            ),
            child: const Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Phase 1'),
                    Text('Description'),
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.delete_outline_outlined),
                    )
                  ]),
            ),
          ),
        ),
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
          indicatorStyle: const IndicatorStyle(
              width: 150,
              height: 50,
              color: Colors.cyan,
              indicator: Align(
                alignment: Alignment.center,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('2-3 days'),
                  ),
                  color: JoblineColors.neutralLight,
                ),
              )),
        ),
        TimelineTile(
          alignment: TimelineAlign.center,
          isLast: true,
          beforeLineStyle: const LineStyle(
            color: JoblineColors.neutralLight,
            thickness: 6,
          ),
          indicatorStyle: const IndicatorStyle(
            width: 20,
            color: JoblineColors.neutralLight,
          ),
          endChild: Container(
            decoration: BoxDecoration(
                color: JoblineColors.lightOrange.withOpacity(0.21),
                borderRadius: BorderRadius.circular(15)),
            constraints: const BoxConstraints(
              minHeight: 80,
            ),
            child: const Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Phase 1'),
                    Text('Description'),
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.delete_outline_outlined),
                    )
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: (_) => TimelineRepository(),
        child: BlocProvider.value(
            value: timelineCubit..getAllTimeline(),
            child: LayoutScaffold(
                body: Row(
              children: <Widget>[
                NavigationRail(
                  extended: true,
                  backgroundColor: JoblineColors.neutralLight,
                  selectedIndex: _selectedIndex,
                  groupAlignment: groupAlignment,
                  useIndicator: false,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  leading: CustomButton(
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
                          style: TextStyle(color: JoblineColors.white),
                        )
                      ],
                    ),
                  ),
                  destinations: const <NavigationRailDestination>[
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
                    // NavigationRailDestination(
                    //   icon: Icon(Icons.star_border),
                    //   selectedIcon: Icon(Icons.star),
                    //   label: Text('Third'),
                    // ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                // This is the main content.
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<TimelineCubit, TimelineState>(
                      buildWhen: (previous, current) =>
                          previous.isTimelineCreationSuccess !=
                          current.isTimelineCreationSuccess,
                      builder: (context, state) {
                        return Column(children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                    padding: EdgeInsets.all(15),
                                    height: 100,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: JoblineColors.neutralLight)),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Shopify",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge),
                                            Text(
                                              "UX Designer",
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
                                            Text("5 Phases"),
                                            Text("Link to job post"),
                                            Text('email')
                                          ],
                                        ),
                                        Spacer(),
                                        CustomButton(
                                            onPressFunction: () {},
                                            child: Text('Save Timeline'))
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 150,
                          ),
                          state.isTimelineCreationSuccess
                              ? _buildEditTimeline()
                              : _buildTimeline()
                        ]);
                      },
                    ),
                  ),
                ),
              ],
            ))));
  }
}
