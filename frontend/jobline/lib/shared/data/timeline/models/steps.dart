import 'package:jobline/shared/data/timeline/models/current_timeline.dart';

class Steps {
  final String? id;
  String? name;
  String? description;
  int? eta;
  final String? timelineId;
  int? order;
  final int? v;
  final List<Status>? status;

  Steps({
    this.id,
    this.name,
    this.description,
    this.eta,
    this.status,
    this.timelineId,
    this.order,
    this.v,
  });

  Steps.fromJson(Map<String, dynamic> json)
      : id = json['_id'] as String?,
        name = json['name'] as String?,
        description = json['description'] as String?,
        eta = json['eta'] as int?,
        timelineId = json['timelineId'] as String?,
        order = json['order'] as int?,
        v = json['__v'] as int?,
        status = (json['status'] as List?)
            ?.map((dynamic e) => Status.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'eta': eta,
        'timelineId': timelineId,
        'order': order,
        'status': status?.map((e) => e.toJson()).toList(),
      };

  Steps copyWith({
    String? id,
    String? name,
    String? description,
    int? eta,
    String? timelineId,
    int? order,
    int? v,
    List<Status>? status,
  }) {
    return Steps(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      eta: eta ?? this.eta,
      timelineId: timelineId ?? this.timelineId,
      order: order ?? this.order,
      v: v ?? this.v,
      status: status ?? this.status,
    );
  }
}
