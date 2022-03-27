class Friend {
  String userId;
  String photoUrl;

  Friend(this.userId, this.photoUrl);

  static Friend fromDynamic(dynamic data) {
    return Friend(
      data["userId"],
      data["photoUrl"],
    );
  }
}
