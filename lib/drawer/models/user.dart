class User {
  final String? displayName;
  final String? email;
  final String? githubUsername; // Add this property
  final String loginProvider; // Add this property to indicate login method

  User({
    this.displayName,
    this.email,
    this.githubUsername,
    required this.loginProvider,
  });
}
