import 'dart:convert';

Job jobFromJson(String str){
  final jsonData = json.decode(str);
  return Job.fromMap(jsonData);
}

String jobToJson(Job data){
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Job {
  int? id;
  String? jobName;
  int? isChecked;

  Job({
    this.id,
    this.jobName,
    this.isChecked
  });

  factory Job.fromMap(Map<String, dynamic> json) => Job(
    id: json['id'],
    jobName: json['job_name'],
    isChecked: json['is_check']
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'job_name' : jobName,
    'is_check' : isChecked
  };
}