class AuthRequest {
  final String email;
  final String motDePasse;

  AuthRequest({required this.email, required this.motDePasse});

  Map<String, dynamic> toJson() => {
    "email": email,
    "motDePasse": motDePasse,
  };

}
