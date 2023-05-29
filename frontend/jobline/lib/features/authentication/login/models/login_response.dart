class LoginResponse {
  bool? success;
  LoginData? data;
  String? msg;

  LoginResponse({this.success, this.data, this.msg});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class LoginData {
  String? accessToken;
  String? email;
  String? nextPage;

  LoginData({
    this.accessToken,
    this.email,
    this.nextPage,
  });

  LoginData.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];

    email = json['email'];
    nextPage = json['nextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['email'] = this.email;
    data['nextPage'] = this.nextPage;

    return data;
  }
}
