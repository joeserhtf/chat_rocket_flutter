class LoginClass {
  String status;
  Data data;

  LoginClass({this.status, this.data});

  LoginClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String userId;
  String authToken;
  Me me;

  Data({this.userId, this.authToken, this.me});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    authToken = json['authToken'];
    me = json['me'] != null ? new Me.fromJson(json['me']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['authToken'] = this.authToken;
    if (this.me != null) {
      data['me'] = this.me.toJson();
    }
    return data;
  }
}

class Me {
  String sId;
  Services services;
  List<Emails> emails;
  String status;
  bool active;
  String sUpdatedAt;
  List<String> roles;
  String name;
  String statusConnection;
  dynamic utcOffset;
  String username;
  String statusLivechat;
  String statusText;
  bool requirePasswordChange;
  String email;
  String avatarUrl;
  Settings settings;

  Me(
      {this.sId,
      this.services,
      this.emails,
      this.status,
      this.active,
      this.sUpdatedAt,
      this.roles,
      this.name,
      this.statusConnection,
      this.utcOffset,
      this.username,
      this.statusLivechat,
      this.statusText,
      this.requirePasswordChange,
      this.email,
      this.avatarUrl,
      this.settings});

  Me.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    services = json['services'] != null ? new Services.fromJson(json['services']) : null;
    if (json['emails'] != null) {
      emails = new List<Emails>();
      json['emails'].forEach((v) {
        emails.add(new Emails.fromJson(v));
      });
    }
    status = json['status'];
    active = json['active'];
    sUpdatedAt = json['_updatedAt'];
    roles = json['roles'].cast<String>();
    name = json['name'];
    statusConnection = json['statusConnection'];
    utcOffset = json['utcOffset'];
    username = json['username'];
    statusLivechat = json['statusLivechat'];
    statusText = json['statusText'];
    requirePasswordChange = json['requirePasswordChange'];
    email = json['email'];
    avatarUrl = json['avatarUrl'];
    settings = json['settings'] != null ? new Settings.fromJson(json['settings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.services != null) {
      data['services'] = this.services.toJson();
    }
    if (this.emails != null) {
      data['emails'] = this.emails.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['active'] = this.active;
    data['_updatedAt'] = this.sUpdatedAt;
    data['roles'] = this.roles;
    data['name'] = this.name;
    data['statusConnection'] = this.statusConnection;
    data['utcOffset'] = this.utcOffset;
    data['username'] = this.username;
    data['statusLivechat'] = this.statusLivechat;
    data['statusText'] = this.statusText;
    data['requirePasswordChange'] = this.requirePasswordChange;
    data['email'] = this.email;
    data['avatarUrl'] = this.avatarUrl;
    if (this.settings != null) {
      data['settings'] = this.settings.toJson();
    }
    return data;
  }
}

class Services {
  Password password;

  Services({this.password});

  Services.fromJson(Map<String, dynamic> json) {
    password = json['password'] != null ? new Password.fromJson(json['password']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.password != null) {
      data['password'] = this.password.toJson();
    }
    return data;
  }
}

class Password {
  String bcrypt;

  Password({this.bcrypt});

  Password.fromJson(Map<String, dynamic> json) {
    bcrypt = json['bcrypt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bcrypt'] = this.bcrypt;
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

class Settings {
  Preferences preferences;

  Settings({this.preferences});

  Settings.fromJson(Map<String, dynamic> json) {
    preferences = json['preferences'] != null ? new Preferences.fromJson(json['preferences']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.preferences != null) {
      data['preferences'] = this.preferences.toJson();
    }
    return data;
  }
}

class Preferences {
  bool enableAutoAway;
  dynamic idleTimeLimit;
  bool desktopNotificationRequireInteraction;
  String audioNotifications;
  String desktopNotifications;
  String mobileNotifications;
  bool unreadAlert;
  bool useEmojis;
  bool convertAsciiEmoji;
  bool autoImageLoad;
  bool saveMobileBandwidth;
  bool collapseMediaByDefault;
  bool hideUsernames;
  bool hideRoles;
  bool hideFlexTab;
  bool hideAvatars;
  bool sidebarGroupByType;
  String sidebarViewMode;
  bool sidebarHideAvatar;
  bool sidebarShowUnread;
  String sidebarSortby;
  bool sidebarShowFavorites;
  String sendOnEnter;
  dynamic messageViewMode;
  String emailNotificationMode;
  String newRoomNotification;
  String newMessageNotification;
  bool muteFocusedConversations;
  dynamic notificationsSoundVolume;
  bool sidebarShowDiscussion;
  bool showMessageInMainThread;

  Preferences(
      {this.enableAutoAway,
      this.idleTimeLimit,
      this.desktopNotificationRequireInteraction,
      this.audioNotifications,
      this.desktopNotifications,
      this.mobileNotifications,
      this.unreadAlert,
      this.useEmojis,
      this.convertAsciiEmoji,
      this.autoImageLoad,
      this.saveMobileBandwidth,
      this.collapseMediaByDefault,
      this.hideUsernames,
      this.hideRoles,
      this.hideFlexTab,
      this.hideAvatars,
      this.sidebarGroupByType,
      this.sidebarViewMode,
      this.sidebarHideAvatar,
      this.sidebarShowUnread,
      this.sidebarSortby,
      this.sidebarShowFavorites,
      this.sendOnEnter,
      this.messageViewMode,
      this.emailNotificationMode,
      this.newRoomNotification,
      this.newMessageNotification,
      this.muteFocusedConversations,
      this.notificationsSoundVolume,
      this.sidebarShowDiscussion,
      this.showMessageInMainThread});

  Preferences.fromJson(Map<String, dynamic> json) {
    enableAutoAway = json['enableAutoAway'];
    idleTimeLimit = json['idleTimeLimit'];
    desktopNotificationRequireInteraction = json['desktopNotificationRequireInteraction'];
    audioNotifications = json['audioNotifications'];
    desktopNotifications = json['desktopNotifications'];
    mobileNotifications = json['mobileNotifications'];
    unreadAlert = json['unreadAlert'];
    useEmojis = json['useEmojis'];
    convertAsciiEmoji = json['convertAsciiEmoji'];
    autoImageLoad = json['autoImageLoad'];
    saveMobileBandwidth = json['saveMobileBandwidth'];
    collapseMediaByDefault = json['collapseMediaByDefault'];
    hideUsernames = json['hideUsernames'];
    hideRoles = json['hideRoles'];
    hideFlexTab = json['hideFlexTab'];
    hideAvatars = json['hideAvatars'];
    sidebarGroupByType = json['sidebarGroupByType'];
    sidebarViewMode = json['sidebarViewMode'];
    sidebarHideAvatar = json['sidebarHideAvatar'];
    sidebarShowUnread = json['sidebarShowUnread'];
    sidebarSortby = json['sidebarSortby'];
    sidebarShowFavorites = json['sidebarShowFavorites'];
    sendOnEnter = json['sendOnEnter'];
    messageViewMode = json['messageViewMode'];
    emailNotificationMode = json['emailNotificationMode'];
    newRoomNotification = json['newRoomNotification'];
    newMessageNotification = json['newMessageNotification'];
    muteFocusedConversations = json['muteFocusedConversations'];
    notificationsSoundVolume = json['notificationsSoundVolume'];
    sidebarShowDiscussion = json['sidebarShowDiscussion'];
    showMessageInMainThread = json['showMessageInMainThread'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enableAutoAway'] = this.enableAutoAway;
    data['idleTimeLimit'] = this.idleTimeLimit;
    data['desktopNotificationRequireInteraction'] = this.desktopNotificationRequireInteraction;
    data['audioNotifications'] = this.audioNotifications;
    data['desktopNotifications'] = this.desktopNotifications;
    data['mobileNotifications'] = this.mobileNotifications;
    data['unreadAlert'] = this.unreadAlert;
    data['useEmojis'] = this.useEmojis;
    data['convertAsciiEmoji'] = this.convertAsciiEmoji;
    data['autoImageLoad'] = this.autoImageLoad;
    data['saveMobileBandwidth'] = this.saveMobileBandwidth;
    data['collapseMediaByDefault'] = this.collapseMediaByDefault;
    data['hideUsernames'] = this.hideUsernames;
    data['hideRoles'] = this.hideRoles;
    data['hideFlexTab'] = this.hideFlexTab;
    data['hideAvatars'] = this.hideAvatars;
    data['sidebarGroupByType'] = this.sidebarGroupByType;
    data['sidebarViewMode'] = this.sidebarViewMode;
    data['sidebarHideAvatar'] = this.sidebarHideAvatar;
    data['sidebarShowUnread'] = this.sidebarShowUnread;
    data['sidebarSortby'] = this.sidebarSortby;
    data['sidebarShowFavorites'] = this.sidebarShowFavorites;
    data['sendOnEnter'] = this.sendOnEnter;
    data['messageViewMode'] = this.messageViewMode;
    data['emailNotificationMode'] = this.emailNotificationMode;
    data['newRoomNotification'] = this.newRoomNotification;
    data['newMessageNotification'] = this.newMessageNotification;
    data['muteFocusedConversations'] = this.muteFocusedConversations;
    data['notificationsSoundVolume'] = this.notificationsSoundVolume;
    data['sidebarShowDiscussion'] = this.sidebarShowDiscussion;
    data['showMessageInMainThread'] = this.showMessageInMainThread;
    return data;
  }
}
