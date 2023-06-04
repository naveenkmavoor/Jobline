import 'package:equatable/equatable.dart';

class Timelines extends Equatable {
  final List<Timeline>? timelines;

  const Timelines({
    this.timelines,
  });

  Timelines copyWith({
    List<Timeline>? timelines,
  }) {
    return Timelines(
      timelines: timelines ?? this.timelines,
    );
  }

  Timelines.fromJson(List<dynamic>? json)
      : timelines = (json as List<dynamic>?)
            ?.map((dynamic e) => Timeline.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() =>
      {'timelines': timelines?.map((e) => e.toJson()).toList()};

  /// Empty user which represents an unauthenticated user.
  static const empty = Timelines(timelines: []);

  /// Convenience getter to determine whether the current Timelines is empty.
  bool get isEmpty => this == Timelines.empty;

  /// Convenience getter to determine whether the current Timelines is not empty.
  bool get isNotEmpty => this != Timelines.empty;
  @override
  // TODO: implement props
  List<Object?> get props => [timelines];
}

class Timeline {
  final String? id;
  final String? jobTitle;
  final String? recruiterId;
  final String? company;
  final String? jobPostLink;
  final List<String>? steps;
  final int? v;

  Timeline({
    this.id,
    this.jobTitle,
    this.jobPostLink,
    this.company,
    this.recruiterId,
    this.steps,
    this.v,
  });

  Timeline copyWith({
    String? id,
    String? jobTitle,
    String? jobPostLink,
    String? company,
    String? recruiterId,
    List<String>? steps,
    int? v,
  }) {
    return Timeline(
      id: id ?? this.id,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      recruiterId: recruiterId ?? this.recruiterId,
      jobPostLink: jobPostLink ?? this.jobPostLink,
      steps: steps ?? this.steps,
      v: v ?? this.v,
    );
  }

  Timeline.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        company = json['company'] as String?,
        jobTitle = json['jobTitle'] as String?,
        recruiterId = json['recruiterId'] as String?,
        jobPostLink = json['jobPostLink'] as String?,
        steps =
            (json['steps'] as List?)?.map((dynamic e) => e as String).toList(),
        v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {
        '_id': id,
        'company': company,
        'jobTitle': jobTitle,
        'jobPostLink': jobPostLink,
        'recruiterId': recruiterId,
        'steps': steps,
        '__v': v
      };
}
