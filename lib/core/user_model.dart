class UserModel {

  int    userId;
  String first_name;
  String last_name;


  UserModel({this.userId, this.first_name, this.last_name});

  UserModel.fromMap(Map<String, dynamic> map) {
    userId     = map['userId'];
    first_name = map['first_name'];
    last_name  = map['last_name'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userId'      : userId,
      'first_name'  : first_name,
      'last_name'   : last_name,
    };
  }
}