class Job {
  final String? title;
  final String? companyName;
  final String? jobLinktoPost;
  final int? totalPhases;

  Job({
    this.title,
    this.companyName,
    this.jobLinktoPost,
    this.totalPhases,
  });

  Job.fromJson(Map<String, dynamic> json)
      : title = json['jobTitle'] as String?,
        companyName = json['company'] as String?,
        jobLinktoPost = json['jobPostLinks'] as String?,
        totalPhases = json['totalPhases'] as int?;

  Map<String, dynamic> toJson() => {
        'jobTitle': title,
        'company': companyName,
        'jobLink': jobLinktoPost,
      };
}
