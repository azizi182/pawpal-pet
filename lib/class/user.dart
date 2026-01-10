class User {
  String? userId;
  String? userEmail;
  String? userPassword;
  String? userName;
  String? userPhone;
  String? userRegdate;
  String? userImage;

  String? userWallet;

  User({
    this.userId,
    this.userEmail,
    this.userPassword,
    this.userName,
    this.userPhone,
    this.userRegdate,
    this.userImage,
    this.userWallet,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userEmail = json['user_email'];
    userPassword = json['user_password'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
    userRegdate = json['user_regdate'];
    userImage = json['user_picture'];
    userWallet = json['user_wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_email'] = userEmail;
    data['user_password'] = userPassword;
    data['user_name'] = userName;
    data['user_phone'] = userPhone;
    data['user_regdate'] = userRegdate;
    data['user_picture'] = userImage;
    data['user_wallet'] = userWallet;
    return data;
  }
}
