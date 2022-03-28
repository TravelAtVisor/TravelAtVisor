class UserSuggestion {
  final String userId;
  final String userName;
  final String fullName;
  final String photoUrl;

  UserSuggestion(
    this.userId,
    this.userName,
    this.fullName,
    this.photoUrl,
  );

  static UserSuggestion fromDynamic(dynamic data) {
    return UserSuggestion(
      data["userId"],
      data["userName"],
      data["fullName"],
      data["photoUrl"],
    );
  }
}
