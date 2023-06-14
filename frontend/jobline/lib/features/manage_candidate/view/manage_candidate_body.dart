import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/features/manage_candidate/cubit/manage_candidate_cubit.dart';
import 'package:jobline/features/timeline/cubit/timeline_cubit.dart';
import 'package:jobline/shared/data/timeline/models/steps.dart';
import 'package:jobline/typography/font_weights.dart';
import 'package:jobline/widgets/custom_avatar.dart';

class ManageCandidateBody extends StatelessWidget {
  final PageController? pageController;
  const ManageCandidateBody({
    super.key,
    this.pageController,
  });

  Widget _buildHeader(TextTheme textTheme) => Row(
        children: [
          IconButton(
              onPressed: () {
                if (pageController != null) {
                  pageController!.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                }
              },
              icon: const Icon(Icons.arrow_back_rounded)),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Manage Candidate',
                    style: textTheme.headlineSmall!
                        .copyWith(fontWeight: JoblineFontWeight.semiBold)),
                Text(
                  'Invite candidates to a phase or move candidates from phase to phase',
                  style: textTheme.bodySmall,
                )
              ],
            ),
          ),
        ],
      );

//build phase card with name and number of candidates in each phase
  _buildPhaseCard(Steps steps, BuildContext context, int stepIndex) {
    final manageCubit = context.read<ManageCandidateCubit>();
    return Column(
      children: [
        Text(steps.name!),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: JoblineColors.lightPurple),
            padding: const EdgeInsets.all(8.0),
            width: 320,
            child: Stack(
              children: [
                Column(children: [
                  SearchBar(
                    hintText: "Search a candidate",
                    leading: const Icon(Icons.search_rounded),
                    onChanged: (value) {
                      manageCubit.searchCandidate(value, steps.id!);
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  BlocBuilder<ManageCandidateCubit, ManageCandidateState>(
                    buildWhen: (previous, current) =>
                        previous.searchQueryTimeline?.steps?[stepIndex] !=
                        current.searchQueryTimeline?.steps?[stepIndex]

                    // ||

                    //     previous
                    //                 .copyTimelineDetails
                    //                 ?.steps?[stepIndex]
                    //                 .status?[subindex]
                    //                 .isSelected !=
                    //             current
                    //                 .copyTimelineDetails
                    //                 ?.steps?[stepIndex]
                    //                 .status?[subindex]
                    //                 .isSelected
                    ,
                    builder: (context, _) {
                      return ListView.builder(
                          itemCount: manageCubit.state.searchQueryTimeline
                              ?.steps?[stepIndex].status?.length,
                          shrinkWrap: true,
                          itemBuilder: (context, subindex) {
                            if (manageCubit.state.searchQueryTimeline?.steps !=
                                null) {
                              final name = manageCubit.state.searchQueryTimeline
                                  ?.steps?[stepIndex].status?[subindex].name;
                              final email = manageCubit
                                  .state
                                  .searchQueryTimeline
                                  ?.steps?[stepIndex]
                                  .status?[subindex]
                                  .email;

                              return InkWell(
                                onTap: () {
                                  context
                                      .read<ManageCandidateCubit>()
                                      .selectCandidate(
                                          steps.status![subindex].email!,
                                          steps.id!);
                                },
                                child: ListTile(
                                  // tileColor: manageCubit
                                  //         .state
                                  //         .searchQueryTimeline!
                                  //         .steps![stepIndex]
                                  //         .status![subindex]
                                  //         .isSelected!
                                  //     ? JoblineColors.lightOrange
                                  //     : null,
                                  leading:
                                      CustomAvatar(name: name ?? email ?? ''),
                                  title: Text('${name ?? email}'),
                                  subtitle:
                                      name != null ? Text('$email') : null,
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          });
                    },
                  )
                ]),
                Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                        onPressed: () {},
                        child: const Icon(Icons.person_add_alt_1_rounded)))
              ],
            ),
          ),
        )
      ],
    );
  }

  //build corosel slider container with searchbar seperated by arrow front and back
//build list of phases with their name and number of candidates in each phase
  Widget _buildPhaseList() {
    return BlocBuilder<ManageCandidateCubit, ManageCandidateState>(
      buildWhen: (previous, current) =>
          previous.copyTimelineDetails != current.copyTimelineDetails,
      builder: (context, state) {
        final currentTimeline = state.copyTimelineDetails ??
            context.read<TimelineCubit>().state.currentTimeline!;
        return ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            separatorBuilder: (context, index) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 40,
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_circle_left_outlined,
                          size: 40,
                        ))
                  ],
                ),
            itemCount: currentTimeline.numberOfSteps!,
            itemBuilder: (context, index) =>
                _buildPhaseCard(currentTimeline.steps![index], context, index));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocProvider(
      create: (context) => ManageCandidateCubit()
        ..getCurrentTimeline(
            context.read<TimelineCubit>().state.currentTimeline!),
      child: Column(
        children: [
          _buildHeader(
            textTheme,
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      height: 400,
                      child: _buildPhaseList()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
