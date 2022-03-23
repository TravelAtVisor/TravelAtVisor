class UserSuggestion {
  final String userId;
  final String userName;
  final String fullName;
  final String? photoUrl;
  final String email;
  final String? biography;

  UserSuggestion(this.userId, this.userName, this.fullName, this.photoUrl,
      this.email, this.biography);

  static UserSuggestion fromDynamic(dynamic data) {
    return UserSuggestion(
      data["userId"],
      data["userName"],
      data["fullName"],
      data["photoUrl"],
      data["email"],
      data["biography"],
    );
  }
}
