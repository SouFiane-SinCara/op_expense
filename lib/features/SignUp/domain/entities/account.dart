class Account {
  final String name;
  final String email;
  final String password;
  final bool isVerified;
  final String userId;

  const Account({
    required this.name,
    required this.email,
    required this.password,
    required this.isVerified,
    required this.userId,
  });
}
