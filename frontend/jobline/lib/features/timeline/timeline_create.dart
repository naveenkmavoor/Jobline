import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/features/timeline/cubit/timeline_cubit.dart';
import 'package:jobline/shared/data/network_client/dio_client.dart';
import 'package:jobline/widgets/custom_button.dart';
import 'package:jobline/widgets/layout_scaffold.dart';

class TimelineCreate extends StatelessWidget {
  const TimelineCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return NavRailExample();
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

  @override
  void initState() {
    // final fetchTimeline = DioClient().get('/api/');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimelineCubit(),
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
                // Add your onPressed code here!
              },
              backgroundColor: JoblineColors.white,
              child: const Row(
                children: [
                  Icon(
                    Icons.add,
                    color: JoblineColors.neutral25,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'New timeline',
                    style: TextStyle(color: JoblineColors.black),
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
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Your Jobs",
                        style: Theme.of(context).textTheme.headlineMedium,
                      )),
                  const SizedBox(
                    height: 150,
                  ),
                  Column(
                    children: [
                      Text('You currently do not have any job timelines.'),
                      CustomButton(
                          backgroundColor: JoblineColors.neutralLight,
                          onPressFunction: () {},
                          radius: 30,
                          child: Text(
                            'Create a timeline',
                            style: TextStyle(color: JoblineColors.black),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
