class User {
  final String id;
  final String nom;
  final String email;
  final String? motDePasse; // Only for login/registration
  final DateTime? dob;
  final String? sexe;
  final double? taille;
  final double? poids;
  final List<String> allergies;
  final List<String> maladies;
  final String? etatActivite;

  User({
    required this.id,
    required this.nom,
    required this.email,
    this.motDePasse,
    this.dob,
    this.sexe,
    this.taille,
    this.poids,
    this.allergies = const [],
    this.maladies = const [],
    this.etatActivite,
  });

  // Convert JSON to User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['idU'] ?? '',
      nom: json['nom'] ?? '',
      email: json['email'] ?? '',
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      sexe: json['sexe'],
      taille: json['taille']?.toDouble(),
      poids: json['poids']?.toDouble(),
      allergies: List<String>.from(json['allergies'] ?? []),
      maladies: List<String>.from(json['maladies'] ?? []),
      etatActivite: json['etatActivite'],
    );
  }

  // Convert User to JSON (for POST/PUT requests)
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'email': email,
      'motDePasse': motDePasse,
      'dob': dob?.toIso8601String(),
      'sexe': sexe,
      'taille': taille,
      'poids': poids,
      'allergies': allergies,
      'maladies': maladies,
      'etatActivite': etatActivite,
    };
  }
}