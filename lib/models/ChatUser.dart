class ChatUser {
  ChatUser({
    required this.about,
    required this.createdAt,
    required this.uid,
    required this.email,
    required this.image,
    required this.isOnline,
    required this.lastActive,
    required this.name,
    required this.deviceTokens,
  });
   String? about;
   String? createdAt;
   String? uid;
   String? email;
   String? image;
   bool? isOnline;
   bool? lastActive;
   String? name;
   List<String>? deviceTokens;

  ChatUser.fromJson(Map<String, dynamic> json){
    about = json['about'] ?? '' ;
    createdAt = json['created_at'] ?? '';
    uid = json['uid'] ?? '';
    email = json['email'] ?? '';
    image = json['image'] ?? '';
    isOnline = json['is_online'] ?? '';
    lastActive = json['last_active'] ?? '';
    name = json['name'] ?? '';
    deviceTokens = List.castFrom<dynamic, String>(json['deviceTokens']) ?? [];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['about'] = about;
    data['created_at'] = createdAt;
    data['uid'] = uid;
    data['email'] = email;
    data['image'] = image;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['name'] = name;
    data['deviceTokens'] = deviceTokens;
    return data;
  }
}