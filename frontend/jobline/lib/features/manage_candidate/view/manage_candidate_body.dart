import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/features/manage_candidate/cubit/manage_candidate_cubit.dart';
import 'package:jobline/features/timeline/cubit/timeline_cubit.dart';
import 'package:jobline/shared/data/manage_canididate/manage_candidate_repository.dart';
import 'package:jobline/shared/data/timeline/models/current_timeline.dart';
import 'package:jobline/shared/data/timeline/models/steps.dart';
import 'package:jobline/typography/font_weights.dart';
import 'package:jobline/widgets/custom_alert_dialog.dart';
import 'package:jobline/widgets/custom_avatar.dart';
import 'package:jobline/widgets/custom_button.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:jobline/shared/utility.dart';

class ManageCandidateBody extends StatelessWidget {
  final PageController? pageController;
  final _manageCandidateRepository = ManageCandidateRepository();
  ManageCandidateBody({
    super.key,
    this.pageController,
  });

  void _buildInviteCandidateDialogBox(
      BuildContext context, ManageCandidateCubit manageCubit, Steps steps) {
    List<String> _values = [];
    final FocusNode _focusNode = FocusNode();
    final TextEditingController _textEditingController =
        TextEditingController();
    final textTheme = Theme.of(context).textTheme;
    customAlertDialog(
        context: context,
        actions: [],
        title: 'Invite Candidates',
        body: StatefulBuilder(builder: (context, StateSetter setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TagEditor(
                      length: _values.length,
                      controller: _textEditingController,
                      focusNode: _focusNode,
                      delimiters: const [',', ' ', '\n'],
                      hasAddButton: false,
                      resetTextOnSubmitted: true,
                      // This is set to grey just to illustrate the `textStyle` prop
                      textStyle: const TextStyle(),
                      onSubmitted: (outstandingValue) {
                        setState(() {
                          _values.add(outstandingValue);
                        });
                      },
                      inputDecoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email Here...',
                      ),
                      onTagChanged: (newValue) {
                        setState(() {
                          _values.add(newValue);
                        });
                      },
                      tagBuilder: (context, index) => _Chip(
                        index: index,
                        label: _values[index],
                        onDeleted: (index) {
                          setState(() {
                            _values.removeAt(index);
                          });
                        },
                      ),
                      // InputFormatters example, this disallow \ and /
                      // inputFormatters: [
                      // FilteringTextInputFormatter.deny(RegExp(
                      //   r"^[a-zA-Z][a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                      // ))
                      // ],
                    ),
                  ),
                  Expanded(
                    child:
                        BlocBuilder<ManageCandidateCubit, ManageCandidateState>(
                      bloc: manageCubit,
                      buildWhen: (previous, current) =>
                          previous.sendInviteLoading !=
                          current.sendInviteLoading,
                      builder: (context, state) {
                        return CustomButton(
                            onPressFunction: () {
                              if (!state.sendInviteLoading)
                                manageCubit.addCandidate(steps.id!, _values);
                            },
                            child: state.sendInviteLoading
                                ? const CircularProgressIndicator()
                                : const Text('SEND INVITE'));
                      },
                    ),
                  )
                ],
              ),
            ],
          );
        }));
  }

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
                CustomScrollView(slivers: [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    backgroundColor: JoblineColors.transparent,
                    flexibleSpace: SearchBar(
                      hintText: "Search a candidate",
                      leading: const Icon(Icons.search_rounded),
                      onChanged: (value) {
                        manageCubit.searchCandidate(value, steps.id!);
                      },
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, subindex) {
                        if (manageCubit.state.searchQueryTimeline?.steps !=
                            null) {
                          final name = manageCubit.state.searchQueryTimeline
                              ?.steps?[stepIndex].status?[subindex].name;
                          final email = manageCubit.state.searchQueryTimeline
                              ?.steps?[stepIndex].status?[subindex].email;

                          return InkWell(
                            onTap: () {
                              context
                                  .read<ManageCandidateCubit>()
                                  .selectCandidate(
                                      steps.status![subindex].email!,
                                      steps.id!);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: manageCubit
                                          .state
                                          .searchQueryTimeline!
                                          .steps![stepIndex]
                                          .status![subindex]
                                          .isSelected
                                      ? JoblineColors.lightOrange
                                      : null),
                              child: ListTile(
                                leading:
                                    CustomAvatar(name: name ?? email ?? ''),
                                title: Text('${name ?? email}'),
                                subtitle: name != null ? Text('$email') : null,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                      childCount: manageCubit.state.searchQueryTimeline
                          ?.steps?[stepIndex].status?.length,
                    ),
                  )
                ]),
                Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                        onPressed: () {
                          _buildInviteCandidateDialogBox(
                              context, manageCubit, steps);
                        },
                        child: const Icon(Icons.person_add_alt_1_rounded))),
              ],
            ),

            //  Stack(
            //   children: [
            //     Column(children: [
            //       SearchBar(
            //         hintText: "Search a candidate",
            //         leading: const Icon(Icons.search_rounded),
            //         onChanged: (value) {
            //           manageCubit.searchCandidate(value, steps.id!);
            //         },
            //       ),
            //       const SizedBox(
            //         height: 8,
            //       ),
            //       ListView.builder(
            //           itemCount: manageCubit.state.searchQueryTimeline
            //               ?.steps?[stepIndex].status?.length,
            //           shrinkWrap: true,
            //           physics: BouncingScrollPhysics(),
            //           itemBuilder: (context, subindex) {
            //             if (manageCubit.state.searchQueryTimeline?.steps !=
            //                 null) {
            //               final name = manageCubit.state.searchQueryTimeline
            //                   ?.steps?[stepIndex].status?[subindex].name;
            //               final email = manageCubit.state.searchQueryTimeline
            //                   ?.steps?[stepIndex].status?[subindex].email;

            //               return InkWell(
            //                 onTap: () {
            //                   context
            //                       .read<ManageCandidateCubit>()
            //                       .selectCandidate(
            //                           steps.status![subindex].email!,
            //                           steps.id!);
            //                 },
            //                 child: Container(
            //                   decoration: BoxDecoration(
            //                       borderRadius: BorderRadius.circular(10.0),
            //                       color: manageCubit
            //                               .state
            //                               .searchQueryTimeline!
            //                               .steps![stepIndex]
            //                               .status![subindex]
            //                               .isSelected
            //                           ? JoblineColors.lightOrange
            //                           : null),
            //                   child: ListTile(
            //                     leading:
            //                         CustomAvatar(name: name ?? email ?? ''),
            //                     title: Text('${name ?? email}'),
            //                     subtitle:
            //                         name != null ? Text('$email') : null,
            //                   ),
            //                 ),
            //               );
            //             } else {
            //               return const SizedBox.shrink();
            //             }
            //           })
            //     ]),
            //     Align(
            //         alignment: Alignment.bottomRight,
            //         child: FloatingActionButton(
            //             onPressed: () {
            //               List<String> _values = [];
            //               final FocusNode _focusNode = FocusNode();
            //               final TextEditingController _textEditingController =
            //                   TextEditingController();
            //               customAlertDialog(
            //                   context: context,
            //                   actions: [],
            //                   body: StatefulBuilder(
            //                       builder: (context, StateSetter setState) {
            //                     return Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text('Invite Candidates'),
            //                         Row(
            //                           children: [
            //                             Expanded(
            //                               flex: 2,
            //                               child: TagEditor(
            //                                 length: _values.length,
            //                                 controller: _textEditingController,
            //                                 focusNode: _focusNode,
            //                                 delimiters: [',', ' '],
            //                                 hasAddButton: true,
            //                                 resetTextOnSubmitted: true,
            //                                 // This is set to grey just to illustrate the `textStyle` prop
            //                                 textStyle: const TextStyle(),
            //                                 onSubmitted: (outstandingValue) {
            //                                   setState(() {
            //                                     _values.add(outstandingValue);
            //                                   });
            //                                 },
            //                                 inputDecoration:
            //                                     const InputDecoration(
            //                                   border: InputBorder.none,
            //                                   hintText: 'Email Here...',
            //                                 ),
            //                                 onTagChanged: (newValue) {
            //                                   setState(() {
            //                                     _values.add(newValue);
            //                                   });
            //                                 },
            //                                 tagBuilder: (context, index) =>
            //                                     _Chip(
            //                                   index: index,
            //                                   label: _values[index],
            //                                   onDeleted: (index) {
            //                                     setState(() {
            //                                       _values.removeAt(index);
            //                                     });
            //                                   },
            //                                 ),
            //                                 // InputFormatters example, this disallow \ and /
            //                                 inputFormatters: [
            //                                   FilteringTextInputFormatter.deny(
            //                                       RegExp(r'[/\\]'))
            //                                 ],
            //                               ),
            //                             ),
            //                             Expanded(
            //                               child: CustomButton(
            //                                   onPressFunction: () {
            //                                     manageCubit.addCandidate(
            //                                         steps.id!, _values);
            //                                   },
            //                                   child: Text('SEND INVITE')),
            //                             )
            //                           ],
            //                         ),
            //                       ],
            //                     );
            //                   }));
            //             },
            //             child: const Icon(Icons.person_add_alt_1_rounded)))
            //   ],
            // ),
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
          previous.copyTimelineDetails != current.copyTimelineDetails ||
          previous.searchQueryTimeline?.steps !=
              current.searchQueryTimeline?.steps,
      builder: (context, state) {
        final searchTimeline = state.searchQueryTimeline ??
            context.read<TimelineCubit>().state.currentTimeline!;
        return ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            separatorBuilder: (context, index) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<ManageCandidateCubit>().moveToNextStep(
                              currentStepIndex: index,
                              moveToNextStep: MoveToNextStep.moveToFrontStep,
                            );
                      },
                      icon: const Icon(
                        Icons.arrow_circle_right_outlined,
                        size: 40,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          context.read<ManageCandidateCubit>().moveToNextStep(
                                currentStepIndex: index + 1,
                                moveToNextStep: MoveToNextStep.moveToBackStep,
                              );
                        },
                        icon: const Icon(
                          Icons.arrow_circle_left_outlined,
                          size: 40,
                        ))
                  ],
                ),
            itemCount: searchTimeline.numberOfSteps!,
            itemBuilder: (context, index) =>
                _buildPhaseCard(searchTimeline.steps![index], context, index));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return RepositoryProvider.value(
      value: _manageCandidateRepository,
      child: BlocProvider(
        create: (context) => ManageCandidateCubit(_manageCandidateRepository)
          ..getCurrentTimeline(
              // context.read<TimelineCubit>().state.currentTimeline!),
              getDummyTimelineData()),
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
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CustomAvatar(name: label),
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
