class Department {
  List<Departments> departments;
  int count;
  int offset;
  int total;
  bool success;

  Department({
    this.departments,
    this.count,
    this.offset,
    this.total,
    this.success,
  });

  Department.fromJson(Map<String, dynamic> json) {
    if (json['departments'] != null) {
      departments = [];
      json['departments'].forEach((v) {
        departments.add(Departments.fromJson(v));
      });
    }
    count = json['count'];
    offset = json['offset'];
    total = json['total'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.departments != null) {
      data['departments'] = this.departments.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    data['offset'] = this.offset;
    data['total'] = this.total;
    data['success'] = this.success;
    return data;
  }
}

class Departments {
  String sId;
  bool enabled;
  String name;
  String description;
  bool showOnRegistration;
  bool showOnOfflineForm;
  bool requestTagBeforeClosingChat;
  String email;
  List<String> chatClosingTags;
  String maxNumberSimultaneousChat;
  String waitingQueueMessage;
  String type;
  int numAgents;
  String sUpdatedAt;
  String offlineMessageChannelName;
  String abandonedRoomsCloseCustomMessage;
  String departmentsAllowedToForward;
  String visitorInactivityTimeoutInSeconds;

  Departments({
    this.sId,
    this.enabled,
    this.name,
    this.description,
    this.showOnRegistration,
    this.showOnOfflineForm,
    this.requestTagBeforeClosingChat,
    this.email,
    this.chatClosingTags,
    this.maxNumberSimultaneousChat,
    this.waitingQueueMessage,
    this.type,
    this.numAgents,
    this.sUpdatedAt,
    this.offlineMessageChannelName,
    this.abandonedRoomsCloseCustomMessage,
    this.departmentsAllowedToForward,
    this.visitorInactivityTimeoutInSeconds,
  });

  Departments.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    enabled = json['enabled'];
    name = json['name'];
    description = json['description'];
    showOnRegistration = json['showOnRegistration'];
    showOnOfflineForm = json['showOnOfflineForm'];
    requestTagBeforeClosingChat = json['requestTagBeforeClosingChat'];
    email = json['email'];
    chatClosingTags = json['chatClosingTags'].cast<String>();
    maxNumberSimultaneousChat = json['maxNumberSimultaneousChat'];
    waitingQueueMessage = json['waitingQueueMessage'];
    type = json['type'];
    numAgents = json['numAgents'];
    sUpdatedAt = json['_updatedAt'];
    offlineMessageChannelName = json['offlineMessageChannelName'];
    abandonedRoomsCloseCustomMessage = json['abandonedRoomsCloseCustomMessage'];
    departmentsAllowedToForward = json['departmentsAllowedToForward'];
    visitorInactivityTimeoutInSeconds =
        json['visitorInactivityTimeoutInSeconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['enabled'] = this.enabled;
    data['name'] = this.name;
    data['description'] = this.description;
    data['showOnRegistration'] = this.showOnRegistration;
    data['showOnOfflineForm'] = this.showOnOfflineForm;
    data['requestTagBeforeClosingChat'] = this.requestTagBeforeClosingChat;
    data['email'] = this.email;
    data['chatClosingTags'] = this.chatClosingTags;
    data['maxNumberSimultaneousChat'] = this.maxNumberSimultaneousChat;
    data['waitingQueueMessage'] = this.waitingQueueMessage;
    data['type'] = this.type;
    data['numAgents'] = this.numAgents;
    data['_updatedAt'] = this.sUpdatedAt;
    data['offlineMessageChannelName'] = this.offlineMessageChannelName;
    data['abandonedRoomsCloseCustomMessage'] =
        this.abandonedRoomsCloseCustomMessage;
    data['departmentsAllowedToForward'] = this.departmentsAllowedToForward;
    data['visitorInactivityTimeoutInSeconds'] =
        this.visitorInactivityTimeoutInSeconds;
    return data;
  }
}
