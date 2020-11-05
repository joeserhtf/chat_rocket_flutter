class LiveRoomsClass {
  List<Rooms> rooms;
  int count;
  int offset;
  int total;
  bool success;

  LiveRoomsClass({this.rooms, this.count, this.offset, this.total, this.success});

  LiveRoomsClass.fromJson(Map<String, dynamic> json) {
    if (json['rooms'] != null) {
      rooms = new List<Rooms>();
      json['rooms'].forEach((v) {
        rooms.add(new Rooms.fromJson(v));
      });
    }
    count = json['count'];
    offset = json['offset'];
    total = json['total'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rooms != null) {
      data['rooms'] = this.rooms.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['offset'] = this.offset;
    data['total'] = this.total;
    data['success'] = this.success;
    return data;
  }
}

class Rooms {
  String sId;
  int msgs;
  int usersCount;
  String lm;
  String fname;
  String t;
  String ts;
  String departmentId;
  V v;
  bool cl;
  bool open;
  bool waitingResponse;
  String sUpdatedAt;
  LastMessage lastMessage;
  ResponseBy responseBy;
  Department department;

  Rooms(
      {this.sId,
      this.msgs,
      this.usersCount,
      this.lm,
      this.fname,
      this.t,
      this.ts,
      this.departmentId,
      this.v,
      this.cl,
      this.open,
      this.waitingResponse,
      this.sUpdatedAt,
      this.lastMessage,
      this.responseBy,
      this.department});

  Rooms.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    msgs = json['msgs'];
    usersCount = json['usersCount'];
    lm = json['lm'];
    fname = json['fname'];
    t = json['t'];
    ts = json['ts'];
    departmentId = json['departmentId'];
    v = json['v'] != null ? new V.fromJson(json['v']) : null;
    cl = json['cl'];
    open = json['open'];
    waitingResponse = json['waitingResponse'] ?? false;
    sUpdatedAt = json['_updatedAt'];
    lastMessage = json['lastMessage'] != null ? new LastMessage.fromJson(json['lastMessage']) : null;
    responseBy = json['responseBy'] != null ? new ResponseBy.fromJson(json['responseBy']) : null;
    department = json['department'] != null ? new Department.fromJson(json['department']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['msgs'] = this.msgs;
    data['usersCount'] = this.usersCount;
    data['lm'] = this.lm;
    data['fname'] = this.fname;
    data['t'] = this.t;
    data['ts'] = this.ts;
    data['departmentId'] = this.departmentId;
    if (this.v != null) {
      data['v'] = this.v.toJson();
    }
    data['cl'] = this.cl;
    data['open'] = this.open;
    data['_updatedAt'] = this.sUpdatedAt;
    data['waitingResponse'] = this.waitingResponse;
    if (this.lastMessage != null) {
      data['lastMessage'] = this.lastMessage.toJson();
    }
    if (this.responseBy != null) {
      data['responseBy'] = this.responseBy.toJson();
    }
    if (this.department != null) {
      data['department'] = this.department.toJson();
    }
    return data;
  }
}

class V {
  String sId;
  String username;
  String token;
  String status;
  String lastMessageTs;

  V({this.sId, this.username, this.token, this.status, this.lastMessageTs});

  V.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    token = json['token'];
    status = json['status'];
    lastMessageTs = json['lastMessageTs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['token'] = this.token;
    data['status'] = this.status;
    data['lastMessageTs'] = this.lastMessageTs;
    return data;
  }
}

class ServedBy {
  String sId;
  String username;
  String ts;

  ServedBy({this.sId, this.username, this.ts});

  ServedBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    ts = json['ts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['ts'] = this.ts;
    return data;
  }
}

class LastMessage {
  String sId;
  String rid;
  String msg;
  String ts;
  U u;
  String sUpdatedAt;
  String token;
  String alias;
  bool newRoom;
  bool showConnecting;

  LastMessage({this.sId, this.rid, this.msg, this.ts, this.u, this.sUpdatedAt, this.token, this.alias, this.newRoom, this.showConnecting});

  LastMessage.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    rid = json['rid'];
    msg = json['msg'];
    ts = json['ts'];
    u = json['u'] != null ? new U.fromJson(json['u']) : null;
    sUpdatedAt = json['_updatedAt'];
    token = json['token'];
    alias = json['alias'];
    newRoom = json['newRoom'];
    showConnecting = json['showConnecting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['rid'] = this.rid;
    data['msg'] = this.msg;
    data['ts'] = this.ts;
    if (this.u != null) {
      data['u'] = this.u.toJson();
    }
    data['_updatedAt'] = this.sUpdatedAt;
    data['token'] = this.token;
    data['alias'] = this.alias;
    data['newRoom'] = this.newRoom;
    data['showConnecting'] = this.showConnecting;
    return data;
  }
}

class U {
  String sId;
  String username;
  String name;

  U({this.sId, this.username, this.name});

  U.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['name'] = this.name;
    return data;
  }
}

class Reaction {
  String fd;
  double ft;
  double tt;

  Reaction({this.fd, this.ft, this.tt});

  Reaction.fromJson(Map<String, dynamic> json) {
    fd = json['fd'];
    ft = json['ft'];
    tt = json['tt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fd'] = this.fd;
    data['ft'] = this.ft;
    data['tt'] = this.tt;
    return data;
  }
}

class Response {
  double avg;
  String fd;
  double ft;
  int total;
  double tt;

  Response({this.avg, this.fd, this.ft, this.total, this.tt});

  Response.fromJson(Map<String, dynamic> json) {
    avg = json['avg'];
    fd = json['fd'];
    ft = json['ft'];
    total = json['total'];
    tt = json['tt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avg'] = this.avg;
    data['fd'] = this.fd;
    data['ft'] = this.ft;
    data['total'] = this.total;
    data['tt'] = this.tt;
    return data;
  }
}

class ResponseBy {
  String sId;
  String username;
  String lastMessageTs;

  ResponseBy({this.sId, this.username, this.lastMessageTs});

  ResponseBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    lastMessageTs = json['lastMessageTs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['lastMessageTs'] = this.lastMessageTs;
    return data;
  }
}

class Department {
  String sId;
  String name;

  Department({this.sId, this.name});

  Department.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}
