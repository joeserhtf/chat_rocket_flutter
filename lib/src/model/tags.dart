class Tag {
  List<Tags>? tags;
  int? count;
  int? offset;
  int? total;
  bool? success;

  Tag({
    this.tags,
    this.count,
    this.offset,
    this.total,
    this.success,
  });

  Tag.fromJson(Map<String, dynamic> json) {
    if (json['tags'] != null) {
      tags = [];
      json['tags'].forEach((v) {
        tags?.add(new Tags.fromJson(v));
      });
    }
    count = json['count'];
    offset = json['offset'];
    total = json['total'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['offset'] = this.offset;
    data['total'] = this.total;
    data['success'] = this.success;
    return data;
  }
}

class Tags {
  String? sId;
  String? name;
  String? description;
  int? numDepartments;
  List<String>? departments;
  String? sUpdatedAt;

  Tags({
    this.sId,
    this.name,
    this.description,
    this.numDepartments,
    this.departments,
    this.sUpdatedAt,
  });

  Tags.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    numDepartments = json['numDepartments'];
    departments = json['departments'].cast<String>();
    sUpdatedAt = json['_updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['numDepartments'] = this.numDepartments;
    data['departments'] = this.departments;
    data['_updatedAt'] = this.sUpdatedAt;
    return data;
  }
}
