import 'package:jobline/shared/data/timeline/models/steps.dart';
import 'package:jobline/shared/data/timeline/models/timeline.dart';

class CurrentTimeline {
  final Timeline? timeline;
  final List<Steps>? steps;
  final List<Status>? status;
  final int? numberOfSteps;

  CurrentTimeline({
    this.timeline,
    this.steps,
    this.status,
    this.numberOfSteps,
  });

  CurrentTimeline.fromJson(Map<String, dynamic> json)
      : timeline = (json['timeline'] as Map<String, dynamic>?) != null
            ? Timeline.fromJson(json['timeline'] as Map<String, dynamic>)
            : null,
        steps = (json['steps'] as List?)
            ?.map((dynamic e) => Steps.fromJson(e as Map<String, dynamic>))
            .toList(),
        status = (json['status'] as List?)
            ?.map((dynamic e) => Status.fromJson(e as Map<String, dynamic>))
            .toList(),
        numberOfSteps = json['numberOfSteps'] as int?;

  Map<String, dynamic> toJson() => {
        'timeline': timeline?.toJson(),
        'steps': steps?.map((e) => e.toJson()).toList(),
        'status': status?.map((e) => e.toJson()).toList(),
        'numberOfSteps': numberOfSteps
      };

  CurrentTimeline copyWith({
    Timeline? timeline,
    List<Steps>? steps,
    List<Status>? status,
    int? numberOfSteps,
  }) {
    return CurrentTimeline(
      timeline: timeline ?? this.timeline,
      steps: steps ?? this.steps,
      status: status ?? this.status,
      numberOfSteps: numberOfSteps ?? this.numberOfSteps,
    );
  }
}

class Status {
  final String? id;
  final String? name;
  final String? stepId;
  final int? stepIdx;
  final String? timelineId;
  final String? status;
  final String? email;
  final int? v;
  bool? isSelected;

  Status({
    this.id,
    this.stepId,
    this.name,
    this.stepIdx,
    this.timelineId,
    this.status,
    this.email,
    this.v,
    this.isSelected = false,
  });

  Status.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        stepId = json['stepId'] as String?,
        stepIdx = json['stepIdx'] as int?,
        timelineId = json['timelineId'] as String?,
        name = json['name'] as String?,
        status = json['status'] as String?,
        email = json['email'] as String?,
        v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'stepId': stepId,
        'stepIdx': stepIdx,
        'timelineId': timelineId,
        'status': status,
        'email': email,
        '__v': v
      };

  Status copyWith({
    String? id,
    String? name,
    String? stepId,
    int? stepIdx,
    String? timelineId,
    String? status,
    String? email,
    int? v,
    bool? isSelected,
  }) {
    return Status(
      id: id ?? this.id,
      name: name ?? this.name,
      stepId: stepId ?? this.stepId,
      stepIdx: stepIdx ?? this.stepIdx,
      timelineId: timelineId ?? this.timelineId,
      status: status ?? this.status,
      email: email ?? this.email,
      v: v ?? this.v,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
