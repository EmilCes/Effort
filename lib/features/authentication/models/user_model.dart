class UserModel {

  String? userId;
  String? email;
  String? username;
  String? password;
  String? userType;
  String? name;
  String? middlename;
  String? lastname;
  String? bio;
  double? weight;
  int? height;
  int? streak;
  String? dateOfBirth;
  String? profilePicture;
  int? fileId;

  UserModel({
    this.userId,
    this.password,
    this.middlename,
    this.bio,
    this.weight,
    this.height,
    this.streak,
    this.dateOfBirth,
    this.email,
    this.username,
    this.userType,
    this.name,
    this.lastname,
    this.fileId,
    this.profilePicture
  });

  String get fullName => '$name $lastname';

  static UserModel empty() => UserModel(dateOfBirth: '', email: '', username: '', userType: '', name: '', lastname: '', profilePicture: '', bio: '', streak: 0);

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "username": username,
      "name": name,
      "lastname": lastname,
      "userType": userType,
      "dateOfBirth": dateOfBirth,
      if (bio != null) "bio": bio,
      if (weight != null) "weight": weight,
      if (height != null) "height": height
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      username: json['username'] as String?,
      name: json['name'] as String?,
      middlename: json['middlename'] as String?,
      lastname: json['lastname'] as String?,
      weight: json["weight"] != null ? json['weight'].toDouble() : null,
      height: json['height'] as int?,
      dateOfBirth: json['dateOfBirth'] as String?,
      bio: json['bio'] as String?,
      streak: json['streak'] as int?,
      userType: json['userType'] as String?,
      fileId: json['file.fileId'] as int?
    );
  }

}