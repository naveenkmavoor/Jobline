import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/features/timeline/cubit/timeline_cubit.dart';
import 'package:jobline/shared/data/timeline/models/job.dart';
import 'package:jobline/widgets/custom_alert_dialog.dart';
import 'package:jobline/widgets/custom_button.dart';

void buildAlertDialogBox(BuildContext context, TimelineCubit timelineCubit) {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? title;
  String? companyName;
  String? jobLinktoPost;
  int? totalPhases;
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
            Text('Tell us the initial details before you create your timeline.',
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
