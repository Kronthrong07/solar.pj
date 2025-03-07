class User {
  String? message;
  String? userID;
  String? email;
  String? phone;
  String? username;
  String? password;
  String? location;
  String? imageName;
  String? updated_at;
  String? rank;

  User({
    this.message,
    this.userID,
    this.email,
    this.phone,
    this.username,
    this.password,
    this.location,
    this.imageName,
    this.updated_at,
    this.rank,
  });

  User.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userID = json['userID'];
    email = json['email'];
    phone = json['phone'];
    username = json['username'];
    password = json['password'];
    location = json['location'];
    imageName = json['imageName'];
    updated_at = json['updated_at'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['userID'] = this.userID;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['username'] = this.username;
    data['password'] = this.password;
    data['location'] = this.location;
    data['imageName'] = this.imageName;
    data['updated_at'] = this.updated_at;
    data['rank'] = this.rank;
    return data;
  }
}
