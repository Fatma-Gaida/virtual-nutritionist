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
  final String? dashBoardQuotidienId;
  final List<String> notificationIds;
  final List<String> objectifIds;
  final List<String> platFavoriIds;
  final int calorieGoal;

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
    this.dashBoardQuotidienId,
    this.notificationIds = const [],
    this.objectifIds = const [],
    this.platFavoriIds = const [],
    this.calorieGoal = 2000,

  

  });
   Map<String, dynamic> toRegistrationJson() {
    return {
      'nom': nom,
      'email': email,
      'motDePasse': motDePasse,
    };
  }

  // Convert JSON to User
   factory User.fromJson(Map<String, dynamic> json) {
    return User(
      //idU: IdU.fromJson(json['idU']),
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      motDePasse: json['motDePasse'],
      dob: json['dob'] != null
          ? DateTime.parse(json['dob'])
          : null,
    
      sexe: json['sexe'],
      taille: json['taille'].toDouble(),
      poids: json['poids'].toDouble(),
      allergies: List<String>.from(json['allergies']),
      maladies: List<String>.from(json['maladies']),
      etatActivite: json['etatActivite'],
      dashBoardQuotidienId: json['dashBoardQuotidienId'],
      notificationIds: List<String>.from(json['notificationIds']),
      objectifIds: List<String>.from(json['objectifIds']),
      platFavoriIds: List<String>.from(json['platFavoriIds']),
      calorieGoal: json['calorieGoal'] != null ? json['calorieGoal'] : 2000,
    );
  }

  @override
  String toString() {
    return 'User{name: $nom, email: $email}';
  }
  // Convert User to JSON (for POST/PUT requests)
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'email': email,
      'motDePasse': motDePasse,
      'dob': dob/*?.toIso8601String()*/,
      'sexe': sexe,
      'taille': taille,
      'poids': poids,
      'allergies': allergies,
      'maladies': maladies,
      'etatActivite': etatActivite,
      'dashBoardQuotidienId': dashBoardQuotidienId,
      'notificationIds': notificationIds,
      'objectifIds': objectifIds,
      'platFavoriIds': platFavoriIds,
      'calorieGoal': calorieGoal,
    };
  }
 
}
