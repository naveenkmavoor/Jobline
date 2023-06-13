class Steps {
  final String? id;
  String? name;
  String? description;
  int? eta;
  final String? timelineId;
  int? order;
  final int? v;

  Steps({
    this.id,
    this.name,
    this.description,
    this.eta,
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
        v = json['__v'] as int?;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'eta': eta,
        'timelineId': timelineId,
        'order': order,
      };
}
