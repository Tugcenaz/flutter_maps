class UserModel {
  String? email;
  String? userId;

  UserModel(
      {this.email,
        this.userId,
      });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'userId': userId,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : email = map['email'],
        userId = map['userId'];


  @override
  String toString() {
    return 'UserModel{email: $email, userId: $userId}';
  }
}
