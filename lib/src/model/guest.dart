class Guest {
  Visitor? visitor;
  bool? success;

  Guest({
    this.visitor,
    this.success,
  });

  Guest.fromJson(Map<String, dynamic> json) {
    visitor =
        json['visitor'] != null ? Visitor.fromJson(json['visitor']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.visitor != null) {
      data['visitor'] = this.visitor?.toJson();
    }
    data['success'] = this.success;
    return data;
  }
}

class Visitor {
  String? sId;
  String? username;
  String? sUpdatedAt;
  String? department;
  String? name;
  String? token;
  LiveChatData? liveChatData;
  List<Phone>? phone;

  Visitor({
    this.sId,
    this.username,
    this.sUpdatedAt,
    this.department,
    this.name,
    this.token,
    this.liveChatData,
    this.phone,
  });

  Visitor.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    sUpdatedAt = json['_updatedAt'];
    department = json['department'];
    name = json['name'];
    token = json['token'];
    liveChatData = json['livechatData'] != null
        ? LiveChatData.fromJson(json['livechatData'])
        : null;
    if (json['phone'] != null) {
      phone = [];
      json['phone'].forEach((v) {
        phone?.add(Phone.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['_updatedAt'] = this.sUpdatedAt;
    data['department'] = this.department;
    data['name'] = this.name;
    data['token'] = this.token;
    if (this.liveChatData != null) {
      data['livechatData'] = this.liveChatData?.toJson();
    }
    if (this.phone != null) {
      data['phone'] = this.phone?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LiveChatData {
  String? orgId;
  String? whatsApp;

  LiveChatData({
    this.orgId,
    this.whatsApp,
  });

  LiveChatData.fromJson(Map<String, dynamic> json) {
    orgId = json['orgId'];
    whatsApp = json['whatsapp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['orgId'] = this.orgId;
    data['whatsapp'] = this.whatsApp;
    return data;
  }
}

class Phone {
  String? phoneNumber;

  Phone({
    this.phoneNumber,
  });

  Phone.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
