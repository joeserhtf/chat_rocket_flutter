class AgentsOnline {
  List<Users> users;
  int count;
  int offset;
  int total;
  bool success;

  AgentsOnline({this.users, this.count, this.offset, this.total, this.success});

  AgentsOnline.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = new List<Users>();
      json['users'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
    count = json['count'];
    offset = json['offset'];
    total = json['total'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['offset'] = this.offset;
    data['total'] = this.total;
    data['success'] = this.success;
    return data;
  }
}

class Users {
  String sId;
  List<Emails> emails;
  String status;
  String name;
  String username;
  String statusLivechat;
  Livechat livechat;

  Users({this.sId, this.emails, this.status, this.name, this.username, this.statusLivechat, this.livechat});

  Users.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['emails'] != null) {
      emails = new List<Emails>();
      json['emails'].forEach((v) {
        emails.add(new Emails.fromJson(v));
      });
    }
    status = json['status'];
    name = json['name'];
    username = json['username'];
    statusLivechat = json['statusLivechat'];
    livechat = json['livechat'] != null ? new Livechat.fromJson(json['livechat']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.emails != null) {
      data['emails'] = this.emails.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['name'] = this.name;
    data['username'] = this.username;
    data['statusLivechat'] = this.statusLivechat;
    if (this.livechat != null) {
      data['livechat'] = this.livechat.toJson();
    }
    return data;
  }
}

class Emails {
  String address;
  bool verified;

  Emails({this.address, this.verified});

  Emails.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    verified = json['verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['verified'] = this.verified;
    return data;
  }
}

class Livechat {
  String maxNumberSimultaneousChat;

  Livechat({this.maxNumberSimultaneousChat});

  Livechat.fromJson(Map<String, dynamic> json) {
    maxNumberSimultaneousChat = json['maxNumberSimultaneousChat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['maxNumberSimultaneousChat'] = this.maxNumberSimultaneousChat;
    return data;
  }
}
