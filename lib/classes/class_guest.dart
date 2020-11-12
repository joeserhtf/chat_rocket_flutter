class Guest {
  Visitor visitor;
  bool success;

  Guest({this.visitor, this.success});

  Guest.fromJson(Map<String, dynamic> json) {
    visitor = json['visitor'] != null ? new Visitor.fromJson(json['visitor']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.visitor != null) {
      data['visitor'] = this.visitor.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class Visitor {
  String sId;
  String username;
  String sUpdatedAt;
  String department;
  String name;
  String token;
  LivechatData livechatData;
  List<Phone> phone;

  Visitor({this.sId, this.username, this.sUpdatedAt, this.department, this.name, this.token, this.livechatData, this.phone});

  Visitor.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    sUpdatedAt = json['_updatedAt'];
    department = json['department'];
    name = json['name'];
    token = json['token'];
    livechatData = json['livechatData'] != null ? new LivechatData.fromJson(json['livechatData']) : null;
    if (json['phone'] != null) {
      phone = new List<Phone>();
      json['phone'].forEach((v) {
        phone.add(new Phone.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['_updatedAt'] = this.sUpdatedAt;
    data['department'] = this.department;
    data['name'] = this.name;
    data['token'] = this.token;
    if (this.livechatData != null) {
      data['livechatData'] = this.livechatData.toJson();
    }
    if (this.phone != null) {
      data['phone'] = this.phone.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LivechatData {
  String orgId;
  String whatsapp;

  LivechatData({this.orgId, this.whatsapp});

  LivechatData.fromJson(Map<String, dynamic> json) {
    orgId = json['orgId'];
    whatsapp = json['whatsapp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orgId'] = this.orgId;
    data['whatsapp'] = this.whatsapp;
    return data;
  }
}

class Phone {
  String phoneNumber;

  Phone({this.phoneNumber});

  Phone.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
