class Message {
  List<Messages>? messages;
  dynamic unreadNotLoaded;

  Message({
    this.messages,
    this.unreadNotLoaded,
  });

  Message.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      messages = [];
      json['messages'].forEach((v) {
        messages?.add(Messages.fromJson(v));
      });
    }
    unreadNotLoaded = json['unreadNotLoaded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.messages != null) {
      data['messages'] = this.messages?.map((v) => v.toJson()).toList();
    }
    data['unreadNotLoaded'] = this.unreadNotLoaded;
    return data;
  }
}

class Messages {
  String? sId;
  String? rid;
  String? message;
  String? token;
  String? alias;
  Ts? ts;
  U? u;
  Ts? tUpdatedAt;
  List<Urls>? urls;
  File? file;
  bool? groupable;
  List<Attachments>? attachments;
  bool? parseUrls;
  String? t;
  TransferData? transferData;

  Messages({
    this.sId,
    this.rid,
    this.message,
    this.token,
    this.alias,
    this.ts,
    this.u,
    this.tUpdatedAt,
    this.urls,
    this.file,
    this.groupable,
    this.attachments,
    this.parseUrls,
    this.t,
    this.transferData,
  });

  Messages.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    rid = json['rid'];
    message = json['msg'];
    token = json['token'];
    alias = json['alias'];
    //ts = json['ts'] != null ? Ts.fromJson(json['ts']) : null;
    u = json['u'] != null ? U.fromJson(json['u']) : null;
    //tUpdatedAt = json['_updatedAt'] != null ? Ts.fromJson(json['_updatedAt']) : null;
    if (json['urls'] != null) {
      urls = [];
      json['urls'].forEach((v) {
        urls?.add(Urls.fromJson(v));
      });
    }
    file = json['file'] != null ? File.fromJson(json['file']) : null;
    groupable = json['groupable'];
    if (json['attachments'] != null) {
      attachments = [];
      json['attachments'].forEach((v) {
        attachments?.add(Attachments.fromJson(v));
      });
    }
    parseUrls = json['parseUrls'];
    t = json['t'];
    transferData = json['transferData'] != null ? TransferData.fromJson(json['transferData']) : null;
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
    if (this.tUpdatedAt != null) {
      data['_updatedAt'] = this.tUpdatedAt?.toJson();
    }
    if (this.urls != null) {
      data['urls'] = this.urls?.map((v) => v.toJson()).toList();
    }
    if (this.file != null) {
      data['file'] = this.file?.toJson();
    }
    data['groupable'] = this.groupable;
    if (this.attachments != null) {
      data['attachments'] = this.attachments?.map((v) => v.toJson()).toList();
    }
    data['parseUrls'] = this.parseUrls;
    data['t'] = this.t;
    if (this.transferData != null) {
      data['transferData'] = this.transferData?.toJson();
    }
    return data;
  }
}

class Ts {
  dynamic date;

  Ts({
    this.date,
  });

  Ts.fromJson(Map<String, dynamic> json) {
    date = json['\$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['\$date'] = this.date;
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

class Urls {
  String? url;
  Headers? headers;
  ParsedUrl? parsedUrl;

  Urls({
    this.url,
    this.headers,
    this.parsedUrl,
  });

  Urls.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    headers = json['headers'] != null ? Headers.fromJson(json['headers']) : null;
    parsedUrl = json['parsedUrl'] != null ? ParsedUrl.fromJson(json['parsedUrl']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = this.url;
    if (this.headers != null) {
      data['headers'] = this.headers?.toJson();
    }
    if (this.parsedUrl != null) {
      data['parsedUrl'] = this.parsedUrl?.toJson();
    }
    return data;
  }
}

class Headers {
  String? contentType;
  dynamic contentLength;

  Headers({
    this.contentType,
    this.contentLength,
  });

  Headers.fromJson(Map<String, dynamic> json) {
    contentType = json['contentType'];
    contentLength = json['contentLength'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['contentType'] = this.contentType;
    data['contentLength'] = this.contentLength;
    return data;
  }
}

class ParsedUrl {
  String? host;
  dynamic hash;
  String? pathname;
  String? protocol;
  dynamic port;
  dynamic query;
  dynamic search;
  String? hostname;

  ParsedUrl({
    this.host,
    this.hash,
    this.pathname,
    this.protocol,
    this.port,
    this.query,
    this.search,
    this.hostname,
  });

  ParsedUrl.fromJson(Map<String, dynamic> json) {
    host = json['host'];
    hash = json['hash'];
    pathname = json['pathname'];
    protocol = json['protocol'];
    port = json['port'];
    query = json['query'];
    search = json['search'];
    hostname = json['hostname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['host'] = this.host;
    data['hash'] = this.hash;
    data['pathname'] = this.pathname;
    data['protocol'] = this.protocol;
    data['port'] = this.port;
    data['query'] = this.query;
    data['search'] = this.search;
    data['hostname'] = this.hostname;
    return data;
  }
}

class File {
  String? sId;
  String? name;
  String? type;

  File({
    this.sId,
    this.name,
    this.type,
  });

  File.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

class Attachments {
  String? ts;
  String? title;
  String? titleLink;
  bool? titleLinkDownload;
  String? audioUrl;
  String? audioType;
  dynamic audioSize;
  String? type;

  Attachments({
    this.ts,
    this.title,
    this.titleLink,
    this.titleLinkDownload,
    this.audioUrl,
    this.audioType,
    this.audioSize,
    this.type,
  });

  Attachments.fromJson(Map<String, dynamic> json) {
    ts = json['ts'];
    title = json['title'];
    titleLink = json['title_link'];
    titleLinkDownload = json['title_link_download'];
    audioUrl = json['audio_url'];
    audioType = json['audio_type'];
    audioSize = json['audio_size'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ts'] = this.ts;
    data['title'] = this.title;
    data['title_link'] = this.titleLink;
    data['title_link_download'] = this.titleLinkDownload;
    data['audio_url'] = this.audioUrl;
    data['audio_type'] = this.audioType;
    data['audio_size'] = this.audioSize;
    data['type'] = this.type;
    return data;
  }
}

class TransferData {
  TransferredBy? transferredBy;
  Ts? ts;
  String? scope;
  String? comment;
  String? previousDepartment;
  U? transferredTo;

  TransferData({
    this.transferredBy,
    this.ts,
    this.scope,
    this.comment,
    this.previousDepartment,
    this.transferredTo,
  });

  TransferData.fromJson(Map<String, dynamic> json) {
    transferredBy = json['transferredBy'] != null ? TransferredBy.fromJson(json['transferredBy']) : null;
    //ts = json['ts'] != null ? Ts.fromJson(json['ts']) : null;
    scope = json['scope'];
    comment = json['comment'];
    previousDepartment = json['previousDepartment'];
    transferredTo = json['transferredTo'] != null ? U.fromJson(json['transferredTo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.transferredBy != null) {
      data['transferredBy'] = this.transferredBy?.toJson();
    }
    if (this.ts != null) {
      data['ts'] = this.ts?.toJson();
    }
    data['scope'] = this.scope;
    data['comment'] = this.comment;
    data['previousDepartment'] = this.previousDepartment;
    if (this.transferredTo != null) {
      data['transferredTo'] = this.transferredTo?.toJson();
    }
    return data;
  }
}

class TransferredBy {
  String? sId;
  String? username;
  String? name;
  String? type;

  TransferredBy({
    this.sId,
    this.username,
    this.name,
    this.type,
  });

  TransferredBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}
