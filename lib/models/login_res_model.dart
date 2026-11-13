class LoginResModel {
  String? status;
  String? message;
  String? bearerToken;
  int? userId;
  Data? data;

  LoginResModel({this.status, this.message, this.bearerToken, this.userId, this.data});

  LoginResModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    message = json['message'];
    bearerToken = json['bearer_token'];
    userId = json['user_id'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['bearer_token'] = bearerToken;
    data['user_id'] = userId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  User? user;
  int? subscriptionStatus;
  String? subscriptionBureaus;
  int? aiAnalysisLimit;
  bool? aiMailDrafting;
  int? kycStatus;

  Data({
    this.user,
    this.subscriptionStatus,
    this.subscriptionBureaus,
    this.aiAnalysisLimit,
    this.aiMailDrafting,
    this.kycStatus,
  });

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    subscriptionStatus = json['subscription_status'];
    subscriptionBureaus = json['subscription_bureaus'];
    aiAnalysisLimit = json['ai_analysis_limit'];
    aiMailDrafting = json['ai_mail_drafting'] is bool 
        ? json['ai_mail_drafting'] 
        : (json['ai_mail_drafting'] == 1 || json['ai_mail_drafting'] == '1');
    kycStatus = json['kyc_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['subscription_status'] = subscriptionStatus;
    data['subscription_bureaus'] = subscriptionBureaus;
    data['ai_analysis_limit'] = aiAnalysisLimit;
    data['ai_mail_drafting'] = aiMailDrafting;
    data['kyc_status'] = kycStatus;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? type;
  String? token;

  User({this.id, this.name, this.email, this.phone, this.type, this.token});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone_number'] ?? json['phone'];
    type = json['type'];
    token = json['api_token'] ?? json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['type'] = type;
    data['token'] = token;
    return data;
  }
}
