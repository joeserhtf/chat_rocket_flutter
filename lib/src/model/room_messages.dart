class RoomMessages {
  List<Messages>? messages;
  int? count;
  int? offset;
  int? total;
  bool? success;

  RoomMessages({
    this.messages,
    this.count,
    this.offset,
    this.total,
    this.success,
  });

  RoomMessages.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      messages = [];
      json['messages'].forEach((v) {
        messages?.add(Messages.fromJson(v));
      });
    }
    count = json['count'];
    offset = json['offset'];
    total = json['total'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.messages != null) {
      data['messages'] = this.messages?.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['offset'] = this.offset;
    data['total'] = this.total;
    data['success'] = this.success;
    return data;
  }
}

class Messages {
  String? sId;
  String? t;
  String? rid;
  String? ts;
  String? message;
  U? u;
  bool? groupable;
  String? sUpdatedAt;
  bool? transcriptRequested;
  String? token;
  String? alias;
  File? file;
  List<Attachments>? attachments;
  bool? parseUrls;
  List<Urls>? urls;
  TransferData? transferData;

  Messages({
    this.sId,
    this.t,
    this.rid,
    this.ts,
    this.message,
    this.u,
    this.groupable,
    this.sUpdatedAt,
    this.transcriptRequested,
    this.token,
    this.alias,
    this.file,
    this.attachments,
    this.parseUrls,
    this.urls,
    this.transferData,
  });

  Messages.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    t = json['t'];
    rid = json['rid'];
    ts = json['ts'];
    message = json['msg'];
    u = json['u'] != null ? U.fromJson(json['u']) : null;
    groupable = json['groupable'];
    sUpdatedAt = json['_updatedAt'];
    transcriptRequested = json['transcriptRequested'];
    token = json['token'];
    alias = json['alias'];
    file = json['file'] != null ? File.fromJson(json['file']) : null;
    if (json['attachments'] != null) {
      attachments = [];
      json['attachments'].forEach((v) {
        attachments?.add(Attachments.fromJson(v));
      });
    }
    parseUrls = json['parseUrls'];
    if (json['urls'] != null) {
      urls = [];
      json['urls'].forEach((v) {
        urls?.add(Urls.fromJson(v));
      });
    }
    transferData = json['transferData'] != null
        ? TransferData.fromJson(json['transferData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['t'] = this.t;
    data['rid'] = this.rid;
    data['ts'] = this.ts;
    data['msg'] = this.message;
    if (this.u != null) {
      data['u'] = this.u?.toJson();
    }
    data['groupable'] = this.groupable;
    data['_updatedAt'] = this.sUpdatedAt;
    data['transcriptRequested'] = this.transcriptRequested;
    data['token'] = this.token;
    data['alias'] = this.alias;
    if (this.file != null) {
      data['file'] = this.file?.toJson();
    }
    if (this.attachments != null) {
      data['attachments'] = this.attachments?.map((v) => v.toJson()).toList();
    }
    data['parseUrls'] = this.parseUrls;
    if (this.urls != null) {
      data['urls'] = this.urls?.map((v) => v.toJson()).toList();
    }
    if (this.transferData != null) {
      data['transferData'] = this.transferData?.toJson();
    }
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
  int? audioSize;
  String? type;
  ImageDimensions? imageDimensions;
  String? imagePreview;
  String? imageUrl;
  String? imageType;
  int? imageSize;

  Attachments({
    this.ts,
    this.title,
    this.titleLink,
    this.titleLinkDownload,
    this.audioUrl,
    this.audioType,
    this.audioSize,
    this.type,
    this.imageDimensions,
    this.imagePreview,
    this.imageUrl,
    this.imageType,
    this.imageSize,
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
    imageDimensions = json['image_dimensions'] != null
        ? ImageDimensions.fromJson(json['image_dimensions'])
        : null;
    imagePreview = json['image_preview'];
    imageUrl = json['image_url'];
    imageType = json['image_type'];
    imageSize = json['image_size'];
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
    if (this.imageDimensions != null) {
      data['image_dimensions'] = this.imageDimensions?.toJson();
    }
    data['image_preview'] = this.imagePreview;
    data['image_url'] = this.imageUrl;
    data['image_type'] = this.imageType;
    data['image_size'] = this.imageSize;
    return data;
  }
}

class ImageDimensions {
  int? width;
  int? height;

  ImageDimensions({
    this.width,
    this.height,
  });

  ImageDimensions.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
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
    headers =
        json['headers'] != null ? Headers.fromJson(json['headers']) : null;
    parsedUrl = json['parsedUrl'] != null
        ? ParsedUrl.fromJson(json['parsedUrl'])
        : null;
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
  String? contentLength;

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
  Null hash;
  String? pathname;
  String? protocol;
  Null port;
  Null query;
  Null search;
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

class TransferData {
  TransferredBy? transferredBy;
  String? ts;
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
    transferredBy = json['transferredBy'] != null
        ? TransferredBy.fromJson(json['transferredBy'])
        : null;
    ts = json['ts'];
    scope = json['scope'];
    comment = json['comment'];
    previousDepartment = json['previousDepartment'];
    transferredTo = json['transferredTo'] != null
        ? U.fromJson(json['transferredTo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.transferredBy != null) {
      data['transferredBy'] = this.transferredBy?.toJson();
    }
    data['ts'] = this.ts;
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
