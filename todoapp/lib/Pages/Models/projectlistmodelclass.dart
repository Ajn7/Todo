class ProjectListModel {
  String? status;
  List<Result>? result;

  ProjectListModel({this.status, this.result});

  ProjectListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? projectId;
  String? title;
  String? createdAt;
  int? user;
  int? completed;
  int? total;

  Result(
      {this.projectId,
      this.title,
      this.createdAt,
      this.user,
      this.completed,
      this.total});

  Result.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
    title = json['title'];
    createdAt = json['created_at'];
    user = json['user'];
    completed = json['completed'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['project_id'] = this.projectId;
    data['title'] = this.title;
    data['created_at'] = this.createdAt;
    data['user'] = this.user;
    data['completed'] = this.completed;
    data['total'] = this.total;
    return data;
  }
}
