

class User {
  final String id;
  final String email;
  final String fullName;
  final AccessTokenModel accessToken;

  User({this.id, this.email, this.fullName, this.accessToken});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        fullName = json['fullName'],
        accessToken = json['accessToken'] != null ? AccessTokenModel.fromJson(json['accessToken']) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['fullName'] = this.fullName;
    if (this.accessToken != null) {
      data['accessToken'] = this.accessToken.toJson();
    }
    return data;
  }
}

class AccessTokenModel {
  final String token;
  final int expireIn;

  AccessTokenModel({this.token, this.expireIn});

  AccessTokenModel.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        expireIn = json['expireIn'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['expireIn'] = this.expireIn;
    return data;
  }
}
