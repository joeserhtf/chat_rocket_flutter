class SocketRoom {
  List<Update>? update;

  SocketRoom({
    this.update,
  });

  SocketRoom.fromJson(Map<String, dynamic> json) {
    if (json['update'] != null) {
      update = [];
      json['update'].forEach((v) {
        update?.add(Update.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.update != null) {
      data['update'] = this.update?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Update {
  String? sId;
  int? usersCount;
  Lm? lm;
  String? fName;
  String? t;
  String? departmentId;
  V? v;
  bool? cl;
  bool? open;
  Lm? lUpdatedAt;
  ServedBy? servedBy;
  LastMessage? lastMessage;

  Update({
    this.sId,
    this.usersCount,
    this.lm,
    this.fName,
    this.t,
    this.departmentId,
    this.v,
    this.cl,
    this.open,
    this.lUpdatedAt,
    this.servedBy,
    this.lastMessage,
  });

  Update.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    usersCount = json['usersCount'];
    lm = json['lm'] != null ? Lm.fromJson(json['lm']) : null;
    fName = json['fname'];
    t = json['t'];
    departmentId = json['departmentId'];
    v = json['v'] != null ? V.fromJson(json['v']) : null;
    cl = json['cl'];
    open = json['open'];
    lUpdatedAt = json['_updatedAt'] != null ? Lm.fromJson(json['_updatedAt']) : null;
    servedBy = json['servedBy'] != null ? ServedBy.fromJson(json['servedBy']) : null;
    lastMessage = json['lastMessage'] != null ? LastMessage.fromJson(json['lastMessage']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['usersCount'] = this.usersCount;
    if (this.lm != null) {
      data['lm'] = this.lm?.toJson();
    }
    data['fname'] = this.fName;
    data['t'] = this.t;
    data['departmentId'] = this.departmentId;
    if (this.v != null) {
      data['v'] = this.v?.toJson();
    }
    data['cl'] = this.cl;
    data['open'] = this.open;
    if (this.lUpdatedAt != null) {
      data['_updatedAt'] = this.lUpdatedAt?.toJson();
    }
    if (this.servedBy != null) {
      data['servedBy'] = this.servedBy?.toJson();
    }
    if (this.lastMessage != null) {
      data['lastMessage'] = this.lastMessage?.toJson();
    }
    return data;
  }
}

class Lm {
  int? date;

  Lm({
    this.date,
  });

  Lm.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}

class V {
  String? sId;
  String? username;
  String? token;
  String? status;
  Lm? lastMessageTs;

  V({
    this.sId,
    this.username,
    this.token,
    this.status,
    this.lastMessageTs,
  });

  V.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    token = json['token'];
    status = json['status'];
    lastMessageTs = json['lastMessageTs'] != null ? Lm.fromJson(json['lastMessageTs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['token'] = this.token;
    data['status'] = this.status;
    if (this.lastMessageTs != null) {
      data['lastMessageTs'] = this.lastMessageTs?.toJson();
    }
    return data;
  }
}

class ServedBy {
  String? sId;
  String? username;
  Lm? ts;

  ServedBy({
    this.sId,
    this.username,
    this.ts,
  });

  ServedBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    ts = json['ts'] != null ? Lm.fromJson(json['ts']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    if (this.ts != null) {
      data['ts'] = this.ts?.toJson();
    }
    return data;
  }
}

class LastMessage {
  String? sId;
  String? rid;
  String? message;
  String? token;
  String? alias;
  Lm? ts;
  U? u;
  Lm? lUpdatedAt;
  bool? newRoom;
  bool? showConnecting;

  LastMessage({
    this.sId,
    this.rid,
    this.message,
    this.token,
    this.alias,
    this.ts,
    this.u,
    this.lUpdatedAt,
    this.newRoom,
    this.showConnecting,
  });

  LastMessage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    rid = json['rid'];
    message = json['msg'];
    token = json['token'];
    alias = json['alias'];
    ts = json['ts'] != null ? Lm.fromJson(json['ts']) : null;
    u = json['u'] != null ? U.fromJson(json['u']) : null;
    lUpdatedAt = json['_updatedAt'] != null ? Lm.fromJson(json['_updatedAt']) : null;
    newRoom = json['newRoom'];
    showConnecting = json['showConnecting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['rid'] = this.rid;
    data['msg'] = this.message;
    data['token'] = this.token;
    data['alias'] = this.alias;
    if (this.ts != null) {
      data['ts'] = this.ts?.toJson();
    }
    if (this.u != null) {
      data['u'] = this.u?.toJson();
    }
    if (this.lUpdatedAt != null) {
      data['_updatedAt'] = this.lUpdatedAt?.toJson();
    }
    data['newRoom'] = this.newRoom;
    data['showConnecting'] = this.showConnecting;
    return data;
  }
}

class U {
  String? sId;
  String? username;
  String? name;

  U({
    this.sId,
    this.username,
    this.name,
  });

  U.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['name'] = this.name;
    return data;
  }
}
